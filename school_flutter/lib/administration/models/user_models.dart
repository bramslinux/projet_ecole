class Utilisateur {
  final int? id;
  final String nom;
  final String prenom;
  final String email;
  final String? telephone;
  final String role;
  final DateTime? dateCreation;
  final bool statut;
  final DateTime? dateNaissance;
  final String? genre;

  Utilisateur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.telephone,
    required this.role,
    this.dateCreation,
    this.statut = true,
    this.dateNaissance,
    this.genre,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      telephone: json['telephone'],
      role: json['role'],
      dateCreation: json['date_creation'] != null 
          ? DateTime.parse(json['date_creation']) 
          : null,
      statut: json['statut'] ?? true,
      dateNaissance: json['date_naissance'] != null 
          ? DateTime.parse(json['date_naissance']) 
          : null,
      genre: json['genre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'role': role,
      'date_creation': dateCreation?.toIso8601String(),
      'statut': statut,
      'date_naissance': dateNaissance?.toIso8601String(),
      'genre': genre,
    };
  }

  String get fullName => '$prenom $nom';
}

class ChefEtablissement extends Utilisateur {
  final DateTime? dateEmbauche;

  ChefEtablissement({
    super.id,
    required super.nom,
    required super.prenom,
    required super.email,
    super.telephone,
    super.dateCreation,
    super.statut = true,
    super.dateNaissance,
    super.genre,
    this.dateEmbauche,
  }) : super(role: 'chef');

  factory ChefEtablissement.fromJson(Map<String, dynamic> json) {
    return ChefEtablissement(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      telephone: json['telephone'],
      dateCreation: json['date_creation'] != null 
          ? DateTime.parse(json['date_creation']) 
          : null,
      statut: json['statut'] ?? true,
      dateNaissance: json['date_naissance'] != null 
          ? DateTime.parse(json['date_naissance']) 
          : null,
      genre: json['genre'],
      dateEmbauche: json['date_embauche'] != null 
          ? DateTime.parse(json['date_embauche']) 
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['date_embauche'] = dateEmbauche?.toIso8601String();
    return data;
  }
}

class Enseignant extends Utilisateur {
  final String? matricule;
  final String? grade;
  final String? specialite;
  final DateTime? dateEmbauche;

  Enseignant({
    super.id,
    required super.nom,
    required super.prenom,
    required super.email,
    super.telephone,
    super.dateCreation,
    super.statut = true,
    super.dateNaissance,
    super.genre,
    this.matricule,
    this.grade,
    this.specialite,
    this.dateEmbauche,
  }) : super(role: 'enseignant');

  factory Enseignant.fromJson(Map<String, dynamic> json) {
    return Enseignant(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      telephone: json['telephone'],
      dateCreation: json['date_creation'] != null 
          ? DateTime.parse(json['date_creation']) 
          : null,
      statut: json['statut'] ?? true,
      dateNaissance: json['date_naissance'] != null 
          ? DateTime.parse(json['date_naissance']) 
          : null,
      genre: json['genre'],
      matricule: json['matricule'],
      grade: json['grade'],
      specialite: json['specialite'],
      dateEmbauche: json['date_embauche'] != null 
          ? DateTime.parse(json['date_embauche']) 
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      'matricule': matricule,
      'grade': grade,
      'specialite': specialite,
      'date_embauche': dateEmbauche?.toIso8601String(),
    });
    return data;
  }
}

class Caissier extends Utilisateur {
  final DateTime? dateEmbauche;

  Caissier({
    super.id,
    required super.nom,
    required super.prenom,
    required super.email,
    super.telephone,
    super.dateCreation,
    super.statut = true,
    super.dateNaissance,
    super.genre,
    this.dateEmbauche,
  }) : super(role: 'caissier');

  factory Caissier.fromJson(Map<String, dynamic> json) {
    return Caissier(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      telephone: json['telephone'],
      dateCreation: json['date_creation'] != null 
          ? DateTime.parse(json['date_creation']) 
          : null,
      statut: json['statut'] ?? true,
      dateNaissance: json['date_naissance'] != null 
          ? DateTime.parse(json['date_naissance']) 
          : null,
      genre: json['genre'],
      dateEmbauche: json['date_embauche'] != null 
          ? DateTime.parse(json['date_embauche']) 
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['date_embauche'] = dateEmbauche?.toIso8601String();
    return data;
  }
}

class Censeur extends Utilisateur {
  final DateTime? dateEmbauche;

  Censeur({
    super.id,
    required super.nom,
    required super.prenom,
    required super.email,
    super.telephone,
    super.dateCreation,
    super.statut = true,
    super.dateNaissance,
    super.genre,
    this.dateEmbauche,
  }) : super(role: 'censeur');

  factory Censeur.fromJson(Map<String, dynamic> json) {
    return Censeur(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      telephone: json['telephone'],
      dateCreation: json['date_creation'] != null 
          ? DateTime.parse(json['date_creation']) 
          : null,
      statut: json['statut'] ?? true,
      dateNaissance: json['date_naissance'] != null 
          ? DateTime.parse(json['date_naissance']) 
          : null,
      genre: json['genre'],
      dateEmbauche: json['date_embauche'] != null 
          ? DateTime.parse(json['date_embauche']) 
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['date_embauche'] = dateEmbauche?.toIso8601String();
    return data;
  }
}
