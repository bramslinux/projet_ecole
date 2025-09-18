from django.db import models
from scolarite.models import Cours, Coefficient
from administration.models import Salle, Classe, Periode
from utilisateurs.models import Enseignant, Eleve, AncienEleve

# ---------------------------
# Trimestre
# ---------------------------
class Trimestre(models.Model):
    nom = models.CharField(max_length=50)
    date_debut = models.DateField()
    date_fin = models.DateField()
    periode = models.ForeignKey(
        Periode, on_delete=models.CASCADE, related_name='trimestres'
    )

    def __str__(self):
        return f"{self.nom} - {self.periode}"



# ---------------------------
# Seance
# ---------------------------
class Seance(models.Model):
    TYPE_CHOICES = [('Cours','Cours'),('TD','TD'),('TP','TP')]
    STATUS_CHOICES = [('Planifie','Planifiée'),('Effectue','Effectuée'),('Annule','Annulée')]

    enseignant = models.ForeignKey(
        Enseignant, on_delete=models.CASCADE, related_name="seances"
    )
    cours = models.ForeignKey(
        Cours, on_delete=models.CASCADE, related_name="seances"
    )
    salle = models.ForeignKey(
        Salle, on_delete=models.CASCADE, related_name="seances"
    )
    annee_scolaire = models.CharField(max_length=20,default="2024-2025")
    heures_par_semaine = models.PositiveIntegerField(default=0)
    statut = models.CharField(
        max_length=20,
        choices=[('actif', 'Actif'), ('annule', 'Annulé')],
        default='actif'
    )

    jours = models.CharField(
        max_length=10,
        choices=[
            ('Lundi', 'Lundi'), ('Mardi', 'Mardi'), ('Mercredi', 'Mercredi'),
            ('Jeudi', 'Jeudi'), ('Vendredi', 'Vendredi'),
            ('Samedi', 'Samedi'), ('Dimanche', 'Dimanche')
        ]
    )
    date = models.DateField(null=True, blank=True)
    heure_debut = models.TimeField()
    duree = models.PositiveIntegerField(default=60)

    type = models.CharField(max_length=50, choices=TYPE_CHOICES)
    status = models.CharField(max_length=50, choices=STATUS_CHOICES)

    class Meta:
        unique_together = ('enseignant', 'cours', 'salle', 'annee_scolaire', 'jours', 'heure_debut')

    def __str__(self):
        return f"Seance {self.cours.nom} - {self.jours} {self.heure_debut}"


# ---------------------------
# Absence
# ---------------------------
class Absence(models.Model):
    motif = models.CharField(max_length=200)
    justifier = models.BooleanField(default=False)
    seance = models.ForeignKey(Seance, on_delete=models.CASCADE, related_name='absences')
    ancien_eleve = models.ForeignKey(AncienEleve, on_delete=models.CASCADE, related_name='absences')

    def __str__(self):
        return f"Absence {self.ancien_eleve} @ {self.seance}"


# ---------------------------
# Pourcentage
# ---------------------------
class Pourcentage(models.Model):
    valeur = models.FloatField(help_text="Valeur du pourcentage (ex: 30 pour 30%)")

    def __str__(self):
        return f"{self.valeur} %"


# ---------------------------
# Devoir
# ---------------------------
class Devoir(models.Model):
    titre = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    cours = models.ForeignKey(Cours, on_delete=models.CASCADE, related_name='devoirs')
    seance = models.ForeignKey(Seance, on_delete=models.CASCADE, related_name='devoirs', null=True, blank=True)
    pourcentage = models.ForeignKey(Pourcentage, on_delete=models.CASCADE, related_name='devoirs')

    date_publication = models.DateField()
    date_devoir = models.DateField()
    type = models.CharField(max_length=50)  # "Exercice", "Contrôle", "DM", ...
    note_max = models.FloatField(default=20)

    def __str__(self):
        return f"{self.titre} ({self.cours.nom}) - {self.pourcentage.valeur}%"


# ---------------------------
# Note
# ---------------------------
class Note(models.Model):
    devoir = models.ForeignKey(Devoir, on_delete=models.CASCADE, related_name='notes')
    ancien_eleve = models.ForeignKey(AncienEleve, on_delete=models.CASCADE, related_name='notes')
    trimestre = models.ForeignKey(Trimestre, on_delete=models.CASCADE, related_name='notes')  # 🔥 ajout ici
    valeur = models.FloatField(null=True, blank=True)
    remarque = models.TextField(blank=True)
    bareme = models.FloatField(default=20)

    class Meta:
        unique_together = (('devoir', 'ancien_eleve', 'trimestre'),)  # 🔥 unique par devoir + élève + trimestre

    def __str__(self):
        return f"{self.ancien_eleve} - {self.devoir} ({self.trimestre.nom}) : {self.valeur}/{self.bareme}"
