from django.shortcuts import render

# Create your views here.
# communication/views.py
from rest_framework import viewsets
from .models import Notification
from .serializers import NotificationSerializer
from rest_framework.permissions import IsAuthenticated,AllowAny

class NotificationViewSet(viewsets.ModelViewSet):
    queryset = Notification.objects.all().order_by('-date_envoie')
    serializer_class = NotificationSerializer
    permission_classes = [AllowAny]

    def perform_create(self, serializer):
        # Assigner automatiquement l'utilisateur connecté comme destinataire
        serializer.save()
