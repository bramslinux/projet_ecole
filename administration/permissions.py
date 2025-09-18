# administration/permissions.py
from rest_framework.permissions import BasePermission

class EstChefEtablissement(BasePermission):
    """
    Seul le chef d’établissement peut créer/modifier/supprimer le patrimoine.
    """
    def has_permission(self, request, view):
        return request.user.is_authenticated and request.user.role == 'chef'
