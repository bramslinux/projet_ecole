from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    UtilisateurViewSet, EleveViewSet, AncienEleveViewSet,
    ChefEtablissementViewSet, CaissierViewSet, CenseurViewSet,
    EnseignantViewSet, ParentViewSet, LoginJWTView
)

router = DefaultRouter()
router.register(r'utilisateurs', UtilisateurViewSet)
router.register(r'eleves', EleveViewSet)
router.register(r'anciens-eleves', AncienEleveViewSet)
router.register(r'chefs-etablissement', ChefEtablissementViewSet)
router.register(r'caissiers', CaissierViewSet)
router.register(r'censeurs', CenseurViewSet)
router.register(r'enseignants', EnseignantViewSet)
router.register(r'parents', ParentViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('login/', LoginJWTView.as_view(), name='login-jwt'),  # JWT login
]
