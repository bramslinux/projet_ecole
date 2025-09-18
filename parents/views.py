from django.shortcuts import render

# Create your views here.
from rest_framework import viewsets, permissions
from .models import SouscriptionParent
from .serializers import SouscriptionParentSerializer

class SouscriptionParentViewSet(viewsets.ModelViewSet):
    queryset = SouscriptionParent.objects.all()
    serializer_class = SouscriptionParentSerializer
    permission_classes = [permissions.AllowAny]

    def get_queryset(self):
        user = self.request.user
        if user.role == 'parent':
            return self.queryset.filter(parent=user)
        return self.queryset
