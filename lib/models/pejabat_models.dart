class Pejabat {
  int? id;
  String? nama;
  String? nip;
  String? email;
  String? jabatanId;
  String? jabatan;
  String? jenisKelaminId;
  String? jenisKelamin;
  String? anjabId;
  String? anjab;
  String? agamaId;
  String? agama;
  String? status;
  String? readyAtOffice;
  String? diKantor;
  String? foto;
  String? createdAt;
  String? updatedAt;

  Pejabat(
      {required this.id,
      required this.nama,
      required this.nip,
      required this.email,
      required this.jabatanId,
      required this.jabatan,
      required this.jenisKelaminId,
      required this.jenisKelamin,
      required this.anjabId,
      required this.anjab,
      required this.agamaId,
      required this.agama,
      required this.status,
      required this.readyAtOffice,
      required this.diKantor,
      required this.foto,
      required this.createdAt,
      required this.updatedAt});

  factory Pejabat.fromJson(Map<String, dynamic> json) {
    return Pejabat(
        id: json['id'],
        nama: json['nama'],
        nip: json['nip'],
        email: json['email'],
        jabatanId: json['jabatan_id'],
        jabatan: json['jabatan'],
        jenisKelaminId: json['jenis_kelamin_id'],
        jenisKelamin: json['jenis_kelamin'],
        anjabId: json['anjab_id'],
        anjab: json['anjab'],
        agamaId: json['agama_id'],
        agama: json['agama'],
        status: json['status'],
        readyAtOffice: json['ready_at_office'],
        diKantor: json['di_kantor'],
        foto: json['foto'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }
}
