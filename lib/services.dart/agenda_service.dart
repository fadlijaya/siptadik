import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:siptadik/models/agenda/get_agenda_models.dart';

import '../helpers/helpers.dart';
import '../models/agenda/post_agenda_models.dart';
import '../models/agenda/response_agenda_models.dart';
import '../models/agenda_models.dart';
import '../utils/config.dart';

class AgendaService {
  getAgenda() async {
    String token = await Helpers().getToken() ?? "";
    int idPejabat = await Helpers().getIdPejabat() as int;
    final response = await http.get(Uri.parse("$API/pejabat/agenda/$idPejabat"),
        headers: {'Authorization': 'Bearer $token'});

    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = responseJson['data'];
      return data.map((p) => GetAgenda.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load');
    }
  }

  fetchAgenda(
      String pejabatId, String agenda, String waktu,  String tempat, String keterangan) async {
    String token = await Helpers().getToken() ?? "";
    var baseResponse;
    var url = Uri.parse("$API/pejabat/agenda/store");
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({'Authorization': 'Bearer $token'});
      request.fields['pejabat_id'] = pejabatId;
      request.fields['agenda'] = agenda;
      request.fields['waktu'] = waktu;
      request.fields['tempat'] = tempat;
      request.fields['keterangan'] = keterangan;

      var response = await request.send();
      final responseStream = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        if (responseStream.body == 'null') {
          return throw Exception('No result');
        } else {
          baseResponse = ResponseAgenda<PostAgenda>.fromJson(
              json.decode(responseStream.body),
              (data) => PostAgenda.fromJson(data));
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