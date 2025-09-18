from django.db import models

# Create your models here.
# parents/models.py
from django.db import models
from utilisateurs.models import Parent, AncienEleve

class SouscriptionParent(models.Model):
    parent = models.ForeignKey(Parent, on_delete=models.CASCADE, related_name='souscriptions_parent')
    ancien_eleve = models.ForeignKey(AncienEleve, on_delete=models.CASCADE, related_name='souscriptions_parent')
    date_souscription = models.DateField()
    matricule = models.CharField(max_length=50, blank=True)

    class Meta:
        unique_together = (('parent', 'ancien_eleve'),)

    def __str__(self):
        return f"{self.parent} ↔ {self.ancien_eleve} ({self.date_souscription})"
