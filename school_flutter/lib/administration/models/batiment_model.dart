class Batiment {
  final int? id;
  final String nom;
  final String? type;
  final int etablissement; // Foreign key to Etablissement

  Batiment({
    this.id,
    required this.nom,
    this.type,
    required this.etablissement,
  });

  factory Batiment.fromJson(Map<String, dynamic> json) {
    return Batiment(
      id: json['id'],
      nom: json['nom'],
      type: json['type'],
      etablissement: json['etablissement'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'type': type,
      'etablissement': etablissement,
    };
  }
}
