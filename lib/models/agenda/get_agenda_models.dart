class GetAgenda {
  int? id;
  String? pejabatId;
  String? namaPejabat;
  String? jabatan;
  String? agenda;
  String? waktu;

  GetAgenda({required this.id,
      required this.pejabatId,
      required this.namaPejabat,
      required this.jabatan,
      required this.agenda,
      required this.waktu,});

  factory GetAgenda.fromJson(Map<String, dynamic> json){
    return GetAgenda(
      id: json['id'], 
      pejabatId: json['pejabat_id'], 
      namaPejabat: json['nama_pejabat'], 
      jabatan: json['jabatan'], 
      agenda: json['agenda'],
      waktu: json['waktu'],);
  }
}
