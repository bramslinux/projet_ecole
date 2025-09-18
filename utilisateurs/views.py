from rest_framework import viewsets, status
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework.parsers import MultiPartParser, FormParser ,JSONParser

from .models import Eleve, Utilisateur, ChefEtablissement, Caissier, Censeur, Enseignant, AncienEleve, Parent
from .serializers import (
    EleveSerializer, UtilisateurSerializer, ChefEtablissementSerializer,
    CaissierSerializer, CenseurSerializer, EnseignantSerializer, AncienEleveSerializer,
    ParentSerializer, MyTokenObtainPairSerializer
)


# ----------------- ViewSets -----------------
class UtilisateurViewSet(viewsets.ModelViewSet):
    queryset = Utilisateur.objects.all()
    serializer_class = UtilisateurSerializer
    permission_classes = [IsAuthenticated]
    #authentication_classes = [JWTAuthentication]


class EleveViewSet(viewsets.ModelViewSet):
    queryset = Eleve.objects.all()
    serializer_class = EleveSerializer
    permission_classes = [AllowAny]
    parser_classes = [MultiPartParser, FormParser ,JSONParser] 
    #authentication_classes = [JWTAuthentication]


class AncienEleveViewSet(viewsets.ModelViewSet):
    queryset = AncienEleve.objects.all()
    serializer_class = AncienEleveSerializer
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]


class ChefEtablissementViewSet(viewsets.ModelViewSet):
    queryset = ChefEtablissement.objects.all()
    serializer_class = ChefEtablissementSerializer
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]


class CaissierViewSet(viewsets.ModelViewSet):
    queryset = Caissier.objects.all()
    serializer_class = CaissierSerializer
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]


class CenseurViewSet(viewsets.ModelViewSet):
    queryset = Censeur.objects.all()
    serializer_class = CenseurSerializer
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]


class EnseignantViewSet(viewsets.ModelViewSet):
    queryset = Enseignant.objects.all()
    serializer_class = EnseignantSerializer
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]


class ParentViewSet(viewsets.ModelViewSet):
    queryset = Parent.objects.all()
    serializer_class = ParentSerializer
    permission_classes = [AllowAny]
    authentication_classes = [JWTAuthentication]


# ----------------- JWT Auth -----------------
class LoginJWTView(APIView):
    permission_classes = [AllowAny]       # tout le monde peut accéder
    authentication_classes = []           # désactive CSRF et auth par session

    def post(self, request):
        serializer = MyTokenObtainPairSerializer(data=request.data)
        if serializer.is_valid():
            return Response(serializer.validated_data, status=status.HTTP_200_OK)
        return Response(
            {'detail': serializer.errors.get('non_field_errors', ['Identifiants incorrects'])[0]},
            status=status.HTTP_400_BAD_REQUEST
        )

class ProfileView(APIView):
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        return Response({
            "email": user.email,
            "nom": user.nom,
            "prenom": user.prenom,
            "role": user.role
        })
