from django import template

register = template.Library()

@register.filter
def get_seance(seances, args):
    """
    Récupère la séance correspondant au jour et horaire.
    args : "Jour,Horaire" (ex: "Lundi,8-10")
    """
    jour, horaire = args.split(",")
    debut = int(horaire.split("-")[0])  # ex: 8

    jours_fr = {
        "Monday": "Lundi", "Tuesday": "Mardi", "Wednesday": "Mercredi",
        "Thursday": "Jeudi", "Friday": "Vendredi", "Saturday": "Samedi"
    }

    for seance in seances:
        seance_jour = seance.date.strftime("%A")
        if jours_fr.get(seance_jour) == jour and seance.heure_debut.hour == debut:
            return seance
    return None
