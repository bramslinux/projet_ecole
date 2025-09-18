from .models import Notification
from rest_framework import serializers
from utilisateurs.models import Utilisateur
from utilisateurs.serializers import UtilisateurChoiceSerializer

class NotificationSerializer(serializers.ModelSerializer):
    destinataires = UtilisateurChoiceSerializer(many=True, read_only=True)
    destinataires_ids = serializers.ListField(
        child=serializers.IntegerField(),
        write_only=True,
        required=False
    )
    envoyer_a_tous = serializers.BooleanField(write_only=True, default=False)
    role_destinataires = serializers.ChoiceField(
        choices=Utilisateur.ROLE_CHOICES,
        write_only=True,
        required=False,
        allow_blank=True
    )

    class Meta:
        model = Notification
        fields = ['id', 'titre', 'message', 'type', 'date_envoie',
                  'destinataires', 'destinataires_ids', 'envoyer_a_tous', 'role_destinataires']
        
        read_only_fields = ['destinataires', 'date_envoie']

    def create(self, validated_data):
        destinataires_ids = validated_data.pop('destinataires_ids', [])
        envoyer_a_tous = validated_data.pop('envoyer_a_tous', False)
        role_destinataires = validated_data.pop('role_destinataires', '')

        notification = Notification.objects.create(**validated_data)

        if envoyer_a_tous:
            notification.destinataires.set(Utilisateur.objects.all())
        elif role_destinataires:
            notification.destinataires.set(Utilisateur.objects.filter(role=role_destinataires))
        elif destinataires_ids:
            notification.destinataires.set(Utilisateur.objects.filter(id__in=destinataires_ids))

        return notification