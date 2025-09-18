from rest_framework import serializers
from .models import Cours, Coefficient, Demande, Inscription, Tranche 
from administration.models import Classe, Etablissement, Periode,Salle
from utilisateurs.models import Eleve, AncienEleve ,Enseignant# Import Eleve model
from administration.models import Etablissement, Periode # Import Etablissement and Periode
from utilisateurs.serializers import EleveSerializer, AncienEleveSerializer # Import from utilisateurs app
from pedagogie.models import Seance

class EtablissementSerializer(serializers.ModelSerializer):
    class Meta:
        model = Etablissement
        fields = '__all__'

class PeriodeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Periode
        fields = '__all__'

class ClasseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Classe
        fields = '__all__'

class CoursSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cours
        fields = '__all__'

class CoefficientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Coefficient
        fields = '__all__'


class DemandeSerializer(serializers.ModelSerializer):
    eleve_nom = serializers.StringRelatedField(source="eleve", read_only=True)
    etablissement_nom = serializers.StringRelatedField(source="etablissement", read_only=True)
    classe_nom = serializers.StringRelatedField(source="classe", read_only=True)

    classes_disponibles = serializers.SerializerMethodField()

    bulletin = serializers.FileField(required=False, allow_null=True)
    dernier_diplome = serializers.FileField(required=False, allow_null=True)
    photo = serializers.ImageField(required=False, allow_null=True)
    
    salle_nom = serializers.StringRelatedField(source="salle", read_only=True)

    class Meta:
        model = Demande
        fields = '__all__'
        read_only_fields = ('status', 'salle')

    def get_classes_disponibles(self, obj):
        salles = Salle.objects.filter(batiment__etablissement=obj.etablissement)
        classes = Classe.objects.filter(salles__in=salles).distinct()
        return [{"id": c.id, "nom": str(c)} for c in classes]



    
class InscriptionSerializer(serializers.ModelSerializer):
    ancien_eleve = AncienEleveSerializer(read_only=True)
    periode = PeriodeSerializer(read_only=True)
    ancien_eleve_id = serializers.PrimaryKeyRelatedField(queryset=AncienEleve.objects.all(), source='ancien_eleve', write_only=True)
    periode_id = serializers.PrimaryKeyRelatedField(queryset=Periode.objects.all(), source='periode', write_only=True)
    photo = serializers.ImageField(required=False, allow_null=True)  # <-- Ajouté

    class Meta:
        model = Inscription
        fields = '__all__'

class TrancheSerializer(serializers.ModelSerializer):
    inscription = InscriptionSerializer(read_only=True)
    inscription_id = serializers.PrimaryKeyRelatedField(queryset=Inscription.objects.all(), source='inscription', write_only=True)

    class Meta:
        model = Tranche
        fields = '__all__'


class EnseignantSerializer(serializers.ModelSerializer):
    class Meta:
        model = Enseignant
        fields = '__all__'


class SeanceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Seance
        fields = '__all__'


