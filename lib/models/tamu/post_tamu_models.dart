class PostTamu <T> {
  int? id;
  String? nama;
  String? nip;
  String? nik;
  String? noHp;
  String? alamat;
  String? provincesId;
  String? provinces;
  String? regenciesId;
  String? regencies;
  String? jenisKelamin;
  String? unitKerja;
  String? jabatan;
  String? foto;
  String? categoryId;
  String? category;
  String? tujuanBertamu;
  String? createdAt;
  String? updatedAt;

  PostTamu(
      {required this.id,
      required this.nama,
      required this.nip,
      required this.nik,
      required this.noHp,
      required this.alamat,
      required this.provincesId,
      required this.provinces,
      required this.regenciesId,
      required this.regencies,
      required this.jenisKelamin,
      required this.unitKerja,
      required this.jabatan,
      this.foto,
      required this.categoryId,
      required this.category,
      required this.tujuanBertamu,
      required this.createdAt,
      required this.updatedAt});

  factory PostTamu.fromJson(Map<String, dynamic> json) {
    return PostTamu(
        id: json['id'],
        nama: json['nama'],
        nip: json['nip'],
        nik: json['nik'],
        noHp: json['no_hp'],
        alamat: json['alamat'],
        provincesId: json['provinces_id'],
        provinces: json['provinces'],
        regenciesId: json['regencies_id'],
        regencies: json['regencies'],
        jenisKelamin: json['jenis_kelamin'],
        unitKerja: json['unit_kerja'],
        jabatan: json['jabatan'],
        foto: json['foto'],
        categoryId: json['category_id'],
        category: json['category'],
        tujuanBertamu: json['tujuan_bertamu'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }
}
