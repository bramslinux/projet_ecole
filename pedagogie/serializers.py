# pedagogie/serializers.py
from rest_framework import serializers
from .models import Note, Devoir, Absence, Trimestre, Seance, Pourcentage


# ---------------------------
# Note
# ---------------------------
class NoteSerializer(serializers.ModelSerializer):
    trimestre = serializers.PrimaryKeyRelatedField(queryset=Trimestre.objects.all())
    class Meta:
        model = Note
        fields = '__all__'


# ---------------------------
# Devoir
# ---------------------------
class DevoirSerializer(serializers.ModelSerializer):
    # On inclut aussi le pourcentage (relation ForeignKey)
    pourcentage = serializers.PrimaryKeyRelatedField(queryset=Pourcentage.objects.all())
    class Meta:
        model = Devoir
        fields = '__all__'


# ---------------------------
# Absence
# ---------------------------
class AbsenceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Absence
        fields = '__all__'


# ---------------------------
# Trimestre
# ---------------------------
class TrimestreSerializer(serializers.ModelSerializer):
    class Meta:
        model = Trimestre
        fields = ['id', 'nom', 'date_debut', 'date_fin', 'periode']

    def validate(self, data):
        """
        Validation pour s'assurer que la date de début < date de fin
        """
        if data['date_debut'] > data['date_fin']:
            raise serializers.ValidationError("La date de début doit être avant la date de fin.")
        return data


# ---------------------------
# Seance
# ---------------------------
class SeanceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Seance
        fields = '__all__'


# ---------------------------
# Pourcentage
# ---------------------------
class PourcentageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pourcentage
        fields = '__all__'
