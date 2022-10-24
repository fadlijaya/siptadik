class Agenda {
  String? pejabatId;
  String? agenda;
  String? waktu;
  String? tempat;
  String? keterangan;
  int? id;

  Agenda({required this.pejabatId,
      required this.agenda,
      required this.waktu,
      required this.tempat,
      required this.keterangan,
      required this.id});

  factory Agenda.fromJson(Map<String, dynamic> json){
    return Agenda(
      pejabatId: json['pejabat_id'], 
      agenda: json['agenda'], 
      waktu: json['waktu'], 
      tempat: json['tempat'], 
      keterangan: json['keterangan'],
      id: json['id']
      );
  }
}
