from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import CoursViewSet, CoefficientViewSet, DemandeViewSet, InscriptionViewSet, TrancheViewSet, ClasseViewSet ,EnseignantViewSet , SeanceViewSet ,EleveCreateViewSet , ELeveListView
router = DefaultRouter()
router.register(r'classes', ClasseViewSet)
router.register(r'cours', CoursViewSet)
router.register(r'coefficients', CoefficientViewSet)
router.register(r'demandes', DemandeViewSet)
router.register(r'inscriptions', InscriptionViewSet)
router.register(r'enseignants', EnseignantViewSet)
router.register(r'seances', SeanceViewSet)
router.register(r'eleves', EleveCreateViewSet,basename='eleve')
router.register(r'eleve-list', ELeveListView,basename='eleve_list')
# Removed EleveViewSet registration from scolarite/urls.py
router.register(r'tranches', TrancheViewSet)

from .views import StatsView # Import StatsView

urlpatterns = [
    path('', include(router.urls)),
    path('stats/', StatsView.as_view(), name='stats'),
    path('tranches/generate_quittance/', TrancheViewSet.as_view({'post': 'generate_quittance'}), name='tranche-generate-quittance'),
]
