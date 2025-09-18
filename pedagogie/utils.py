# pedagogie/utils.py
from django.db.models import F
from .models import Note, Trimestre, AncienEleve, Salle

# ==========================
# Moyennes
# ==========================

def moyenne_par_matiere(ancien_eleve_id, cours_id, annee_scolaire=None):
    """
    Moyenne pondérée d'un élève pour une matière spécifique
    en tenant compte du pourcentage de chaque devoir.
    """
    notes = Note.objects.filter(
        ancien_eleve_id=ancien_eleve_id,
        devoir__cours_id=cours_id
    )
    if annee_scolaire:
        notes = notes.filter(devoir__annee_scolaire=annee_scolaire)

    total_pondere = 0
    total_pourcentage = 0

    for note in notes:
        if note.valeur is not None and note.devoir.pourcentage:
            pond = note.valeur * note.devoir.pourcentage.valeur / 100
            total_pondere += pond
            total_pourcentage += note.devoir.pourcentage.valeur

    if total_pourcentage == 0:
        return 0
    return round(total_pondere / total_pourcentage, 2)


def moyenne_par_eleve(ancien_eleve_id, annee_scolaire=None):
    """
    Moyenne générale de toutes matières pour un élève
    """
    cours_ids = Note.objects.filter(ancien_eleve_id=ancien_eleve_id)
    if annee_scolaire:
        cours_ids = cours_ids.filter(devoir__annee_scolaire=annee_scolaire)
    cours_ids = cours_ids.values_list('devoir__cours_id', flat=True).distinct()

    moyennes = []
    for cid in cours_ids:
        m = moyenne_par_matiere(ancien_eleve_id, cid, annee_scolaire)
        if m:
            moyennes.append(m)

    if not moyennes:
        return 0
    return round(sum(moyennes) / len(moyennes), 2)


def moyenne_par_eleve_trimestre(ancien_eleve_id, trimestre_id):
    """
    Moyenne d'un élève pour un trimestre
    """
    trimestre = Trimestre.objects.get(id=trimestre_id)
    notes = Note.objects.filter(
        ancien_eleve_id=ancien_eleve_id,
        devoir__date_devoir__range=(trimestre.date_debut, trimestre.date_fin)
    )

    matieres_ids = notes.values_list('devoir__cours_id', flat=True).distinct()
    moyennes = []
    for cid in matieres_ids:
        m = moyenne_par_matiere(ancien_eleve_id, cid)
        if m:
            moyennes.append(m)

    if not moyennes:
        return 0
    return round(sum(moyennes) / len(moyennes), 2)


def moyenne_par_eleve_annuelle(ancien_eleve_id, annee_scolaire):
    """
    Moyenne annuelle d'un élève
    """
    notes = Note.objects.filter(
        ancien_eleve_id=ancien_eleve_id,
        devoir__annee_scolaire=annee_scolaire
    )

    matieres_ids = notes.values_list('devoir__cours_id', flat=True).distinct()
    moyennes = []
    for cid in matieres_ids:
        m = moyenne_par_matiere(ancien_eleve_id, cid, annee_scolaire)
        if m:
            moyennes.append(m)

    if not moyennes:
        return 0
    return round(sum(moyennes) / len(moyennes), 2)


# ==========================
# Classements
# ==========================

def _calcul_classement(anciens_eleves, fonction_moyenne):
    """
    Calcul du classement à partir d'une liste d'anciens élèves et d'une fonction de calcul de moyenne
    """
    resultats = [{"eleve": e, "moyenne": fonction_moyenne(e.id)} for e in anciens_eleves]
    resultats.sort(key=lambda x: x["moyenne"], reverse=True)

    rang, prev = 0, None
    classement = []
    for i, r in enumerate(resultats, start=1):
        if r["moyenne"] != prev:
            rang = i
        r["rang"] = rang
        prev = r["moyenne"]
        classement.append(r)
    return classement


def classement_salle_trimestre(salle_id, trimestre_id):
    """
    Classement des élèves d'une salle pour un trimestre
    """
    eleves = AncienEleve.objects.filter(salle_id=salle_id)
    return _calcul_classement(eleves, lambda ae_id: moyenne_par_eleve_trimestre(ae_id, trimestre_id))


def classement_salle_annuelle(salle_id, annee_scolaire):
    """
    Classement des élèves d'une salle pour l'année scolaire
    """
    eleves = AncienEleve.objects.filter(salle_id=salle_id)
    return _calcul_classement(eleves, lambda ae_id: moyenne_par_eleve_annuelle(ae_id, annee_scolaire))


def moyennes_tous_eleves(annee_scolaire=None):
    """
    Moyenne de tous les anciens élèves
    """
    eleves = AncienEleve.objects.all()
    return [{"eleve": e, "moyenne": moyenne_par_eleve(e.id, annee_scolaire)} for e in eleves]


def classement_global_trimestre(trimestre_id):
    """
    Classement global tous élèves pour un trimestre
    """
    return _calcul_classement(AncienEleve.objects.all(), lambda ae_id: moyenne_par_eleve_trimestre(ae_id, trimestre_id))


def classement_global_annuelle(annee_scolaire):
    """
    Classement global tous élèves pour l'année scolaire
    """
    return _calcul_classement(AncienEleve.objects.all(), lambda ae_id: moyenne_par_eleve_annuelle(ae_id, annee_scolaire))
