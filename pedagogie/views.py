# pedagogie/views.py
from django.http import HttpResponse
from rest_framework import viewsets
from rest_framework.decorators import api_view, action
from rest_framework.response import Response
from rest_framework import status
from django.shortcuts import get_object_or_404

from .models import Note, Devoir, Absence, Trimestre, Seance, Pourcentage, Salle
from .serializers import (
    NoteSerializer, DevoirSerializer, AbsenceSerializer, TrimestreSerializer,
    SeanceSerializer, PourcentageSerializer
)
from .utils import (
    moyenne_par_eleve, moyenne_par_matiere,
    moyenne_par_eleve_trimestre, moyenne_par_eleve_annuelle,
    classement_salle_trimestre, classement_salle_annuelle,
    moyennes_tous_eleves, classement_global_trimestre,
    classement_global_annuelle
)
from .pdf_utils import generer_bulletin_pdf, generer_emploi_salle_pdf

# ---------------------------
# ViewSets
# ---------------------------
class NoteViewSet(viewsets.ModelViewSet):
    queryset = Note.objects.all()
    serializer_class = NoteSerializer

    def create(self, request, *args, **kwargs):
        valeur = request.data.get("valeur")
        devoir_id = request.data.get("devoir")

        # Vérifier que le devoir existe
        try:
            devoir = Devoir.objects.get(pk=devoir_id)
        except Devoir.DoesNotExist:
            return Response({"error": "Devoir introuvable"}, status=status.HTTP_404_NOT_FOUND)

        # Vérifier que la valeur de la note <= barème du devoir
        if valeur and float(valeur) > devoir.note_max:
            return Response(
                {"error": f"La valeur de la note ({valeur}) ne peut pas dépasser le barème du devoir ({devoir.note_max})"},
                status=status.HTTP_400_BAD_REQUEST
            )

        return super().create(request, *args, **kwargs)

class DevoirViewSet(viewsets.ModelViewSet):
    queryset = Devoir.objects.all()
    serializer_class = DevoirSerializer

class AbsenceViewSet(viewsets.ModelViewSet):
    queryset = Absence.objects.all()
    serializer_class = AbsenceSerializer

   # Liste des absences d’une salle
    @action(detail=False, methods=['get'], url_path='salle/(?P<salle_id>[^/.]+)')
    def absences_salle(self, request, salle_id=None):
        absences = Absence.objects.filter(seance__salle_id=salle_id, justifie=False)
        serializer = self.get_serializer(absences, many=True)
        return Response(serializer.data)

    # Liste des absences d’un établissement
    @action(detail=False, methods=['get'], url_path='etablissement/(?P<etab_id>[^/.]+)')
    def absences_etablissement(self, request, etab_id=None):
        absences = Absence.objects.filter(seance__salle__etablissement_id=etab_id, justifie=False)
        serializer = self.get_serializer(absences, many=True)
        return Response(serializer.data)

    # Justifier une absence
    @action(detail=True, methods=['patch'], url_path='justifier')
    def justifier_absence(self, request, pk=None):
        absence = self.get_object()
        absence.justifie = True
        absence.save()
        return Response({"status": "Absence justifiée"}, status=status.HTTP_200_OK)

    # Statistiques par classe
    @action(detail=False, methods=['get'], url_path='statistiques/classe/(?P<classe_id>[^/.]+)')
    def stats_classe(self, request, classe_id=None):
        total = Absence.objects.filter(seance__salle__classe_id=classe_id).count()
        justifiees = Absence.objects.filter(seance__salle__classe_id=classe_id, justifie=True).count()
        non_justifiees = total - justifiees
        return Response({
            "classe_id": classe_id,
            "total": total,
            "justifiees": justifiees,
            "non_justifiees": non_justifiees
        })

    # Statistiques établissement
    @action(detail=False, methods=['get'], url_path='statistiques/etablissement/(?P<etab_id>[^/.]+)')
    def stats_etablissement(self, request, etab_id=None):
        total = Absence.objects.filter(seance__salle__etablissement_id=etab_id).count()
        justifiees = Absence.objects.filter(seance__salle__etablissement_id=etab_id, justifie=True).count()
        non_justifiees = total - justifiees
        return Response({
            "etablissement_id": etab_id,
            "total": total,
            "justifiees": justifiees,
            "non_justifiees": non_justifiees
        })

class TrimestreViewSet(viewsets.ModelViewSet):
    queryset = Trimestre.objects.all()
    serializer_class = TrimestreSerializer

class PourcentageViewSet(viewsets.ModelViewSet):
    queryset = Pourcentage.objects.all()
    serializer_class = PourcentageSerializer

class SeanceViewSet(viewsets.ModelViewSet):
    queryset = Seance.objects.all()
    serializer_class = SeanceSerializer

# ---------------------------
# Emplois de temps
# ---------------------------
@api_view(['GET'])
def emploi_salle_pdf(request, salle_id):
    pdf, error = generer_emploi_salle_pdf(salle_id)
    if error:
        return Response({"error": error}, status=404)

    response = HttpResponse(pdf, content_type='application/pdf')
    response['Content-Disposition'] = f'attachment; filename="emploi_salle_{salle_id}.pdf"'
    return response

# PDF de l'emploi du temps
@api_view(['GET'])
def emploi_salle_pdf(request, salle_id):
    pdf, error = generer_emploi_salle_pdf(salle_id)
    if error:
        return Response({"error": error}, status=404)

    response = HttpResponse(pdf, content_type='application/pdf')
    response['Content-Disposition'] = f'attachment; filename="emploi_salle_{salle_id}.pdf"'
    return response

# ---------------------------
# Bulletins PDF
# ---------------------------
@api_view(['GET'])
def bulletin_pdf(request, ancien_eleve_id, annee_scolaire=None, trimestre_id=None):
    """
    Génère le bulletin PDF d'un élève.
    Les moyennes sont désormais pondérées selon les pourcentages des devoirs.
    """
    try:
        pdf = generer_bulletin_pdf(ancien_eleve_id, annee_scolaire, trimestre_id)
    except Exception as e:
        return Response({"error": str(e)}, status=404)

    response = HttpResponse(pdf, content_type='application/pdf')
    response['Content-Disposition'] = f'attachment; filename="bulletin_{ancien_eleve_id}.pdf"'
    return response

# ---------------------------
# Nouveaux Endpoints Globaux
# ---------------------------

@api_view(['GET'])
def get_moyennes_tous_eleves(request, annee_scolaire=None):
    """
    Retourne la moyenne pondérée de tous les élèves pour l'année scolaire donnée.
    """
    data = moyennes_tous_eleves(annee_scolaire)
    return Response([
        {
            "eleve_id": res["eleve"].id,
            "nom": res["eleve"].nom,
            "prenom": res["eleve"].prenom,
            "moyenne": res["moyenne"]
        }
        for res in data
    ])

@api_view(['GET'])
def get_classement_global_trimestre(request, trimestre_id):
    """
    Retourne le classement pondéré des élèves pour un trimestre spécifique.
    """
    data = classement_global_trimestre(trimestre_id)
    return Response([
        {
            "eleve_id": res["eleve"].id,
            "nom": res["eleve"].nom,
            "prenom": res["eleve"].prenom,
            "moyenne": res["moyenne"],
            "rang": res["rang"]
        }
        for res in data
    ])

@api_view(['GET'])
def get_classement_global_annuelle(request, annee_scolaire):
    """
    Retourne le classement pondéré des élèves pour une année scolaire complète.
    """
    data = classement_global_annuelle(annee_scolaire)
    return Response([
        {
            "eleve_id": res["eleve"].id,
            "nom": res["eleve"].nom,
            "prenom": res["eleve"].prenom,
            "moyenne": res["moyenne"],
            "rang": res["rang"]
        }
        for res in data
    ])