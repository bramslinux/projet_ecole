# pedagogie/pdf_utils.py
from io import BytesIO
from django.shortcuts import get_object_or_404
from django.template.loader import render_to_string
from weasyprint import HTML
import tempfile

from .models import Trimestre, AncienEleve, Note, Seance, Salle
from .utils import (
    moyenne_par_eleve, moyenne_par_matiere,
    moyenne_par_eleve_trimestre, classement_salle_trimestre,
    classement_salle_annuelle
)

# ---------------------------
# Bulletin PDF
# ---------------------------
def generer_bulletin_pdf(ancien_eleve_id, annee_scolaire=None, trimestre_id=None):
    from .models import Note, Trimestre, AncienEleve

    ancien_eleve = get_object_or_404(AncienEleve, id=ancien_eleve_id)

    # Récupérer le trimestre si fourni
    trimestre = None
    if trimestre_id:
        trimestre = get_object_or_404(Trimestre, id=trimestre_id)

    # Moyenne générale pondérée
    moyenne_generale = moyenne_par_eleve(ancien_eleve.id, annee_scolaire)

    # Notes de l'élève filtrées par trimestre
    if trimestre:
        notes = Note.objects.filter(ancien_eleve=ancien_eleve, trimestre=trimestre)
    else:
        notes = Note.objects.filter(ancien_eleve=ancien_eleve)

    # Classement
    if trimestre_id:
        classement = classement_salle_trimestre(ancien_eleve.salle_id, trimestre_id)
    else:
        classement = classement_salle_annuelle(ancien_eleve.salle_id, annee_scolaire)

    rang = next((c['rang'] for c in classement if c['eleve'].id == ancien_eleve.id), "N/A")

    # Générer le HTML
    html_string = render_to_string("pedagogie/bulletin_template.html", {
        "eleve": ancien_eleve.eleve,
        "ancien_eleve": ancien_eleve,
        "notes": notes,
        "moyenne": moyenne_generale,
        "rang": rang,
        "trimestre": trimestre,
        "trimestre_id": trimestre_id,
        "annee_scolaire": annee_scolaire
    })

    # Générer le PDF en mémoire
    pdf_io = BytesIO()
    HTML(string=html_string).write_pdf(pdf_io)
    pdf_data = pdf_io.getvalue()
    pdf_io.close()
    
    return pdf_data


# ---------------------------
# Emploi du temps PDF
# ---------------------------
def generer_emploi_salle_pdf(salle_id):
    """
    Génère le PDF de l'emploi du temps d'une salle.
    """
    try:
        salle = Salle.objects.get(id=salle_id)
    except Salle.DoesNotExist:
        return None, "Salle introuvable"

    seances = Seance.objects.filter(salle=salle).order_by("jours", "heure_debut")

    # Générer HTML
    html_string = render_to_string("pedagogie/emploi_salle_template.html", {
        "salle": salle,
        "seances": seances
    })

    # Générer PDF
    with tempfile.NamedTemporaryFile(delete=True, suffix=".pdf") as output:
        HTML(string=html_string).write_pdf(output.name)
        output.seek(0)
        pdf_data = output.read()

    return pdf_data, None
