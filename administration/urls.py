from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import EtablissementViewSet, PeriodeViewSet , ClasseViewSet, BatimentViewSet, SalleViewSet , UtilisateurViewSet , SouscriptionEtablissementViewSet 

router = DefaultRouter()
router.register(r'etablissements', EtablissementViewSet,basename='etablissement')
router.register(r'periodes', PeriodeViewSet)
router.register(r'classes', ClasseViewSet, basename='classe')
router.register(r'batiments', BatimentViewSet, basename='batiment')
router.register(r'salles', SalleViewSet, basename='salle')
router.register(r'utilisateurs', UtilisateurViewSet, basename='utilisateur')
router.register(r'souscriptions',SouscriptionEtablissementViewSet , basename='souscription')

urlpatterns = [
    path('', include(router.urls)),
]
