class SouscriptionEtablissement {
  final int? id;
  final DateTime dateSouscription;
  final int chef; // Foreign key to ChefEtablissement
  final int etablissement; // Foreign key to Etablissement

  SouscriptionEtablissement({
    this.id,
    required this.dateSouscription,
    required this.chef,
    required this.etablissement,
  });

  factory SouscriptionEtablissement.fromJson(Map<String, dynamic> json) {
    return SouscriptionEtablissement(
      id: json['id'],
      dateSouscription: DateTime.parse(json['date_souscription']),
      chef: json['chef'],
      etablissement: json['etablissement'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_souscription': dateSouscription.toIso8601String().split('T')[0],
      'chef': chef,
      'etablissement': etablissement,
    };
  }
}
