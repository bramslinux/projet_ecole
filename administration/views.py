from rest_framework import viewsets
from .models import Etablissement, Periode , Classe, Batiment, Salle
from .serializers import EtablissementSerializer, PeriodeSerializer, ClasseSerializer, BatimentSerializer, SalleSerializer , SouscriptionEtablissement , SouscriptionEtablissementSerializer
from .permissions import EstChefEtablissement
from rest_framework.permissions import AllowAny
from utilisateurs.serializers import UtilisateurSerializer
from utilisateurs.models import Utilisateur


class EtablissementViewSet(viewsets.ModelViewSet):
    queryset = Etablissement.objects.all()
    serializer_class = EtablissementSerializer
    permission_classes = [AllowAny]

class PeriodeViewSet(viewsets.ModelViewSet):
    queryset = Periode.objects.all()
    serializer_class = PeriodeSerializer

class ClasseViewSet(viewsets.ModelViewSet):
    queryset = Classe.objects.all()
    serializer_class = ClasseSerializer
    permission_classes = [AllowAny]

class BatimentViewSet(viewsets.ModelViewSet):
    queryset = Batiment.objects.all()
    serializer_class = BatimentSerializer
    permission_classes = [AllowAny]

class SalleViewSet(viewsets.ModelViewSet):
    queryset = Salle.objects.all()
    serializer_class = SalleSerializer
    permission_classes = [AllowAny]

class UtilisateurViewSet(viewsets.ModelViewSet):
    queryset = Utilisateur.objects.all()
    serializer_class = UtilisateurSerializer
    permission_classes = [AllowAny]  # accès basé sur rôle

    def get_queryset(self):
        user = self.request.user
        # Un chef ne peut voir que les utilisateurs de son établissement
        if user.role == 'chef':
            return Utilisateur.objects.filter(souscription__etablissement__souscriptions__chef=user)
        # Administrateur voit tous
        if user.is_superuser:
            return Utilisateur.objects.all()
        # Les autres n'ont pas accès
        return Utilisateur.objects.none()
    
class SouscriptionEtablissementViewSet(viewsets.ModelViewSet):
    queryset = SouscriptionEtablissement.objects.all()
    serializer_class = SouscriptionEtablissementSerializer
    permission_classes = [AllowAny]