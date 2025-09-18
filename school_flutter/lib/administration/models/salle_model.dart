class Salle {
  final int? id;
  final String nom;
  final int capacite;
  final String? typeSalle;
  final int batiment; // Foreign key to Batiment
  final int classe; // Foreign key to Classe

  Salle({
    this.id,
    required this.nom,
    required this.capacite,
    this.typeSalle,
    required this.batiment,
    required this.classe,
  });

  factory Salle.fromJson(Map<String, dynamic> json) {
    return Salle(
      id: json['id'],
      nom: json['nom'],
      capacite: json['capacite'],
      typeSalle: json['type_salle'],
      batiment: json['batiment'],
      classe: json['classe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'capacite': capacite,
      'type_salle': typeSalle,
      'batiment': batiment,
      'classe': classe,
    };
  }
}
