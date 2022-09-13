import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/kota_models.dart';
import '../models/provinsi_models.dart';
import '../utils/config.dart';

class RegionalServices {
  getDataProvinsi() async {
    final response = await http.get(Uri.parse("$API/province"));
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data = responseJson['data'];
      return data.map((p) => Provinsi.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load');
    }
  }

  getDataKota(String idProvinsi) async {
    final response = await http.get(Uri.parse("$API/regency/$idProvinsi"));
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data = responseJson['data'];
      return data.map((p) => Kota.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load');
    }
  }
}
