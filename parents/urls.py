from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import SouscriptionParentViewSet

router = DefaultRouter()
router.register(r'souscriptions', SouscriptionParentViewSet, basename='souscription')

urlpatterns = [
    path('api/', include(router.urls)),
]
