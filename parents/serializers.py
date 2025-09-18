from rest_framework import serializers
from .models import SouscriptionParent
from django.utils import timezone

class SouscriptionParentSerializer(serializers.ModelSerializer):
    date_souscription = serializers.DateField(default=timezone.now().date)
    class Meta:
        model = SouscriptionParent
        fields = ['id', 'parent', 'ancien_eleve', 'date_souscription', 'matricule']
