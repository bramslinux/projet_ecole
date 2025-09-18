from rest_framework import serializers
from .models import Etablissement, Periode ,  Batiment, Salle, Classe ,SouscriptionEtablissement

class EtablissementSerializer(serializers.ModelSerializer):
    class Meta:
        model = Etablissement
        fields = '__all__'

class PeriodeSerializer(serializers.ModelSerializer):
    etablissement = EtablissementSerializer(read_only=True)
    etablissement_id = serializers.PrimaryKeyRelatedField(queryset=Etablissement.objects.all(), source='etablissement', write_only=True)

    class Meta:
        model = Periode
        fields = '__all__'

class ClasseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Classe
        fields = '__all__'

class BatimentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Batiment
        fields = '__all__'

class SalleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Salle
        fields = '__all__'

class SouscriptionEtablissementSerializer(serializers.ModelSerializer):
    class Meta:
        model = SouscriptionEtablissement
        fields = ['id', 'date_souscription', 'chef', 'etablissement']