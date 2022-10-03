class DeleteAgenda <T> {
  int? pejabatId;
  String? agenda;
  String? waktu;
  String? tempat;
  String? keterangan;
  String? updatedAt;
  String? createdAt;
  int? id;

  DeleteAgenda({required this.pejabatId,
      required this.agenda,
      required this.waktu,
      required this.tempat,
      required this.keterangan,
      required this.updatedAt,
      required this.createdAt,
      required this.id});

  factory DeleteAgenda.fromJson(Map<String, dynamic> json){
    return DeleteAgenda(
      pejabatId: json['pejabat_id'], 
      agenda: json['agenda'], 
      waktu: json['waktu'], 
      tempat: json['tempat'], 
      keterangan: json['keterangan'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id']);
  }
}
