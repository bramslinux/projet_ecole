from django.db import models
from smart_selects.db_fields import ChainedForeignKey

# Create your models here.
# scolarite/models.py
from django.db import models
from administration.models import Classe, Etablissement,Salle, Periode # Ensure Periode is imported from administration
from utilisateurs.models import Eleve
from utilisateurs.models import AncienEleve # Corrected import for AncienEleve

class Cours(models.Model):
    libelle = models.CharField(max_length=100)
    volume_horaire = models.PositiveIntegerField(default=0)
    classes = models.ManyToManyField(Classe, through='Coefficient', related_name='cours')

    def __str__(self):
        return self.libelle

class Coefficient(models.Model):
    classe = models.ForeignKey(Classe, on_delete=models.CASCADE)
    cours = models.ForeignKey(Cours, on_delete=models.CASCADE)
    valeur = models.FloatField()

    class Meta:
        unique_together = (('classe', 'cours'),)

    def __str__(self):
        return f"{self.classe} - {self.cours} : {self.valeur}"

class Demande(models.Model):
    eleve = models.ForeignKey(Eleve, on_delete=models.CASCADE)
    etablissement = models.ForeignKey(Etablissement, on_delete=models.CASCADE)

    # Salle optionnelle au départ
    salle = ChainedForeignKey(
        Salle,
        chained_field="etablissement",                 # champ de Demande qui fait la liaison
        chained_model_field="batiment__etablissement", # relation dans Salle
        show_all=False,
        auto_choose=True,
        sort=True,
        on_delete=models.SET_NULL,  # <= très important : si la salle est supprimée
        null=True,                  # <= autoriser NULL
        blank=True                  # <= autoriser vide dans les formulaires
    )

    # Pièces jointes
    bulletin = models.FileField(upload_to="demandes/bulletins/", null=True, blank=True)
    dernier_diplome = models.FileField(upload_to="demandes/diplomes/", null=True, blank=True)
    photo = models.ImageField(upload_to="demandes/photos/", null=True, blank=True)

    date_demande = models.DateField(auto_now_add=True)
    statut = models.CharField(
        max_length=20,
        choices=[
            ("en_attente", "En attente"),
            ("acceptee", "Acceptée"),
            ("refusee", "Refusée"),
        ],
        default="en_attente"
    )

    def __str__(self):
        return f"Demande de {self.eleve} pour {self.etablissement} - {self.salle if self.salle else 'Pas encore attribuée'} [{self.statut}]"


class Inscription(models.Model):
    ancien_eleve = models.ForeignKey(AncienEleve, on_delete=models.CASCADE, related_name="inscriptions") # Changed to AncienEleve
    periode = models.ForeignKey(Periode, on_delete=models.CASCADE, related_name="inscriptions")
    date_inscription = models.DateField(auto_now_add=True)
    statut = models.CharField(
        max_length=20,
        choices=[('en_attente', 'En attente'), ('validee', 'Validée'), ('refusee', 'Refusée')],
        default='en_attente'
    )
    photo = models.ImageField(upload_to='inscriptions_photos/', null=True, blank=True)

    def __str__(self):
        return f"Inscription de {self.ancien_eleve} pour {self.periode}"

class Tranche(models.Model):
    date_paiement = models.DateField()
    mode_paiement = models.CharField(max_length=50)
    status = models.CharField(max_length=50)
    inscription = models.ForeignKey(Inscription, on_delete=models.CASCADE, related_name='tranches')

    def __str__(self):
        return f"Tranche {self.mode_paiement} - {self.inscription}"
