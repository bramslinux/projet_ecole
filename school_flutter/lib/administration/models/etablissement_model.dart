class Etablissement {
  final int? id;
  final String codeEtablissement;
  final String adresse;
  final String? telephone;
  final String type;
  final String? logo; // Assuming logo will be a URL or base64 string
  final String ville;

  Etablissement({
    this.id,
    required this.codeEtablissement,
    required this.adresse,
    this.telephone,
    required this.type,
    this.logo,
    required this.ville,
  });

  factory Etablissement.fromJson(Map<String, dynamic> json) {
    return Etablissement(
      id: json['id'],
      codeEtablissement: json['code_etablissement'],
      adresse: json['adresse'],
      telephone: json['telephone'],
      type: json['type'],
      logo: json['logo'],
      ville: json['ville'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code_etablissement': codeEtablissement,
      'adresse': adresse,
      'telephone': telephone,
      'type': type,
      'logo': logo,
      'ville': ville,
    };
  }
}
