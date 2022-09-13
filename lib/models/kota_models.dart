class Kota {
  int? id;
  String? name;

  Kota({required this.id, required this.name});

  factory Kota.fromJson(Map<String, dynamic> json) {
    return Kota(id: json['id'], name: json['name']);
  }
}
