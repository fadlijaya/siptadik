import 'dart:convert';

import 'package:siptadik/helpers/helpers.dart';
import 'package:siptadik/models/tamu/get_tamu_models.dart';
import 'package:siptadik/utils/config.dart';
import 'package:http/http.dart' as http;

import '../models/pejabat_models.dart';

class PejabatService {
  getDataPejabat() async {
    String token = await Helpers().getToken() ?? "";
    final response = await http.get(Uri.parse("$API/pejabat"),
        headers: {'Authorization': 'Bearer $token'});
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data = responseJson['data'];
      return data.map((p) => Pejabat.fromJson(p)).toList();
    }
  }

  getDataTamuPejabat() async {
    String token = await Helpers().getToken() ?? "";
    final response = await http.get(Uri.parse("$API/pejabat/tamu"),
        headers: {'Authorization': 'Bearer $token'});
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var data = responseJson['data'];
      return data.map((p) => GetTamu.fromJson(p)).toList();
    }
  }
}
