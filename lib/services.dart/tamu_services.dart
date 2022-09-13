import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:siptadik/helpers/helpers.dart';
import '../models/tamu/post_tamu_models.dart';
import '../models/tamu/response_tamu_models.dart';
import '../models/tamu/get_tamu_models.dart';
import '../utils/config.dart';

class TamuServices {
  getDataTamu() async {
    String token = await Helpers().getToken() ?? "";
    final response = await http.get(Uri.parse("$API/tamu"),
        headers: {'Authorization': 'Bearer $token'});

    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = responseJson['data'];
      return data.map((p) => GetTamu.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load');
    }
  }

  createDataTamu(
      String nama,
      String nip,
      String nik,
      String noHp,
      String alamat,
      String provinsiId,
      String kotaId,
      String jekel,
      String jabatan,
      String unitKerja,
      String kategoriId,
      String receptionistId,
      String tujuanBertamu,
      String pejabatId,
      File photo) async {
    String token = await Helpers().getToken() ?? "";
    var baseResponse;
    var url = Uri.parse("$API/tamu/store");
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({'Authorization': 'Bearer $token'});
      request.fields['nama'] = nama;
      request.fields['nip'] = nip;
      request.fields['nik'] = nik;
      request.fields['no_hp'] = noHp;
      request.fields['alamat'] = alamat;
      request.fields['provinces_id'] = provinsiId;
      request.fields['regencies_id'] = kotaId;
      request.fields['jenis_kelamin'] = jekel;
      request.fields['jabatan'] = jabatan;
      request.fields['unit_kerja'] = unitKerja;
      request.fields['category_id'] = kategoriId;
      request.fields['receptionist_id'] = receptionistId;
      request.fields['tujuan_bertamu'] = tujuanBertamu;
      request.fields['pejabat_id'] = pejabatId;
      request.files.add(await http.MultipartFile.fromPath('foto', photo.path));

      var response = await request.send();
      final responseStream = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        if (responseStream.body == 'null') {
          return throw Exception('No result');
        } else {
          baseResponse = ResponseTamu<PostTamu>.fromJson(
              json.decode(responseStream.body),
              (data) => PostTamu.fromJson(data));
          return baseResponse;
        }
      } else {
        baseResponse;
      }
    } on Exception catch (_) {
      return baseResponse;
    }
  }
}

/*Future<Tamu> createTamu(
    String nama,
    String nip,
    String nik,
    String noHp,
    String alamat,
    String provinsiId,
    String kotaId,
    String jekel,
    String unitKerja,
    String kategoriId,
    String receptionistId,
    String tujuanBertamu,
    File photo) async {
  String token = await Helpers().getToken() ?? "";
  final response = await http.post(
    Uri.parse('$API/tamu/store'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode({
      'nama': nama,
      'nip': nip,
      'nik': nik,
      'no_hp': noHp,
      'alamat': alamat,
      'provinces_id': provinsiId,
      'regencies_id': kotaId,
      'jenis_kelamin': jekel,
      'unit_kerja': unitKerja,
      'category_id': kategoriId,
      'receptionist_id': receptionistId,
      'tujuan_bertamu': tujuanBertamu,
      'foto': http.MultipartFile.fromPath('foto', photo.path)
    }),
  );

  if (response.statusCode == 200) {
    var responseJson = jsonDecode(response.body);
    var message = responseJson['message'];
    print(message);
    return Tamu.fromJson(responseJson);
  } else {
    throw Exception('Failed to create tamu.');
  }
}*/
