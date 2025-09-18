from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, Group, Permission
from django.utils import timezone



# ================= Manager personnalisé =================
class UtilisateurManager(BaseUserManager):
    use_in_migrations = True

    def _create_user(self, email, password, **extra_fields):
        if not email:
            raise ValueError("L'email doit être fourni")
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)  # Hash le mot de passe
        user.save(using=self._db)
        return user

    def create_user(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', False)
        extra_fields.setdefault('is_superuser', False)
        return self._create_user(email, password, **extra_fields)

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self._create_user(email, password, **extra_fields)


# ================= Utilisateur de base =================
class Utilisateur(AbstractBaseUser):
    GENRE_CHOICES = [('M', 'Masculin'), ('F', 'Féminin')]
    ROLE_CHOICES = [
        ('parent', 'Parent'),
        ('eleve', 'Élève'),
        ('enseignant', 'Enseignant'),
        ('chef', 'Chef d’établissement'),
        ('censeur', 'Censeur'),
        ('caissier', 'Caissier'),
    ]

    nom = models.CharField(max_length=100)
    prenom = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    telephone = models.CharField(max_length=20, blank=True)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES)
    date_creation = models.DateTimeField(default=timezone.now)
    statut = models.BooleanField(default=True)
    date_naissance = models.DateField(null=True, blank=True)
    genre = models.CharField(max_length=1, choices=GENRE_CHOICES, blank=True, null=True)

    # Override groups et permissions
    groups = models.ManyToManyField(
        Group,
        related_name='customuser_set',
        blank=True
    )
    user_permissions = models.ManyToManyField(
        Permission,
        related_name='customuser_set',
        blank=True
    )
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)

    objects = UtilisateurManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['nom', 'prenom']

    def __str__(self):
        return f"{self.prenom} {self.nom}"


# ================= Rôles hérités =================
class ChefEtablissement(Utilisateur):
    date_embauche = models.DateField()


class Caissier(Utilisateur):
    date_embauche = models.DateField()


class Censeur(Utilisateur):
    date_embauche = models.DateField()


class Enseignant(Utilisateur):
    matricule = models.CharField(max_length=50, unique=True)
    grade = models.CharField(max_length=50, blank=True)
    SPECIALITE_CHOICES = [
        ('math', 'Mathématiques'),
        ('physique', 'Physique'),
        ('chimie', 'Chimie'),
        ('francais', 'Français'),
        ('anglais', 'Anglais'),
    ]
    specialite = models.CharField(max_length=50, choices=SPECIALITE_CHOICES, blank=True)
    date_embauche = models.DateField()

    def __str__(self):
        return f"{self.prenom} {self.nom} ({self.matricule}) - {self.specialite}"


class Eleve(Utilisateur):
    date_inscription = models.DateField()
    photo = models.ImageField(upload_to="eleves_photos/", null=True, blank=True)



class AncienEleve(models.Model):
    eleve = models.ForeignKey(
        "Eleve",
        on_delete=models.SET_NULL,
        null=True,
        blank=True
    )
    matricule = models.CharField(max_length=50)
    niveau = models.CharField(max_length=50, blank=True)
    salle = models.ForeignKey("administration.Salle", on_delete=models.SET_NULL, null=True, blank=True)

class Parent(Utilisateur):
    lien_parent = models.CharField(max_length=50, blank=True)
