from django.db import models

# Create your models here.
# communication/models.py
from django.db import models
from utilisateurs.models import Utilisateur

class Notification(models.Model):
    TYPE_CHOICES = [
        ('devoir', 'Devoir'),
        ('absence', 'Absence'),
        ('paiement', 'Paiement'),
        ('general', 'Général'),
        ('inscription', 'Inscription'),
    ]
    
    titre = models.CharField(max_length=100, default="Notification")
    message = models.TextField()
    date_envoie = models.DateTimeField(auto_now_add=True)
    lu = models.BooleanField(default=False)
    type = models.CharField(max_length=20, choices=TYPE_CHOICES, default='general')
    destinataires = models.ManyToManyField(Utilisateur, related_name='notifications')

    def __str__(self):
        return f"{self.titre} -> {self.date_envoie.strftime('%d/%m/%Y')}"