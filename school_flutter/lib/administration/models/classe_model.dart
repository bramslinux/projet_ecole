class Classe {
  final int? id;
  final String niveau;

  Classe({
    this.id,
    required this.niveau,
  });

  factory Classe.fromJson(Map<String, dynamic> json) {
    return Classe(
      id: json['id'],
      niveau: json['niveau'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'niveau': niveau,
    };
  }
}
