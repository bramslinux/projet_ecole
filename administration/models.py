from django.db import models


from utilisateurs.models import Utilisateur, ChefEtablissement, Caissier, Censeur, Enseignant

class Etablissement(models.Model):
    nom = models.CharField(max_length=100)
    code_etablissement = models.CharField(max_length=20, unique=True)
    adresse = models.CharField(max_length=255)
    telephone = models.CharField(max_length=20, blank=True, null=True)
    type = models.CharField(max_length=50, choices=[('public', 'Public'), ('prive', 'Privé')])
    logo = models.ImageField(upload_to="logos/", blank=True, null=True)
    ville = models.CharField(max_length=100)

    def __str__(self):
        return f"{self.code_etablissement} - {self.ville}"

class Batiment(models.Model):
    nom = models.CharField(max_length=100)
    type = models.CharField(max_length=50, blank=True)
    etablissement = models.ForeignKey(Etablissement, on_delete=models.CASCADE, related_name='batiments')

    def __str__(self):
        return self.nom

class Classe(models.Model):
    nom = models.CharField(max_length=100)
    niveau = models.CharField(max_length=50)

    def __str__(self):
        return f"Classe {self.niveau}"

class Salle(models.Model):
    nom = models.CharField(max_length=50)
    capacite = models.PositiveIntegerField(default=0)
    type_salle = models.CharField(max_length=50, blank=True)
    batiment = models.ForeignKey(Batiment, on_delete=models.CASCADE, related_name="salles")
    classe = models.ForeignKey(Classe, on_delete=models.CASCADE, related_name="salles")

    def __str__(self):
        return f"{self.nom} ({self.batiment}) - {self.classe.niveau}"

class Periode(models.Model):
    annee_scolaire = models.CharField(max_length=20)
    etablissement = models.ForeignKey(Etablissement, on_delete=models.CASCADE, related_name='periodes')

    def __str__(self):
        return f"{self.annee_scolaire} - {self.etablissement}"

class SouscriptionEtablissement(models.Model):
    date_souscription = models.DateField()
    chef = models.ForeignKey(ChefEtablissement, on_delete=models.CASCADE, related_name='souscriptions')
    etablissement = models.ForeignKey(Etablissement, on_delete=models.CASCADE, related_name='souscriptions')

    def __str__(self):
        return f"Souscription {self.etablissement} par {self.chef} ({self.date_souscription})"
