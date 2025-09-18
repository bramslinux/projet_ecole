from rest_framework.routers import DefaultRouter
from django.urls import path, include
from .views import (
    NoteViewSet, DevoirViewSet, AbsenceViewSet, TrimestreViewSet,
    #EmploiDuTempsViewSet, 
    PourcentageViewSet,SeanceViewSet,
    get_moyennes_tous_eleves, get_classement_global_trimestre, get_classement_global_annuelle,emploi_salle_pdf,bulletin_pdf
)

# ---------------------------
# Router pour les ViewSets
# ---------------------------
router = DefaultRouter()
router.register(r'notes', NoteViewSet)
router.register(r'devoirs', DevoirViewSet)
router.register(r'absences', AbsenceViewSet, basename='absence')
router.register(r'trimestres', TrimestreViewSet, basename='trimestre')

router.register(r'pourcentages', PourcentageViewSet, basename="pourcentages")
router.register(r'seances',SeanceViewSet,basename="seances")

urlpatterns = [
    # Endpoints supplémentaires
    path('moyenne/tous_eleves/', get_moyennes_tous_eleves, name='moyennes_tous_eleves'),
    path('moyenne/tous_eleves/<str:annee_scolaire>/', get_moyennes_tous_eleves, name='moyennes_tous_eleves_annee'),
    path('classement/global/trimestre/<int:trimestre_id>/', get_classement_global_trimestre, name='classement_global_trimestre'),
    path('classement/global/annuelle/<str:annee_scolaire>/', get_classement_global_annuelle, name='classement_global_annuelle'),
    path('emplois-temps/salle/<int:salle_id>/pdf/', emploi_salle_pdf, name='emploi_salle_pdf'),
    path("bulletin/<int:ancien_eleve_id>/<int:trimestre_id>/", bulletin_pdf, name="bulletin_pdf"),


    # Ajout des routes du router
    path('', include(router.urls)),
]
