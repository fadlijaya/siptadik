import 'package:shared_preferences/shared_preferences.dart';

class Helpers {
  Future<String?> getToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('access_token');
  }

  Future<String?> getLevel() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('level');
  }

  Future<int?> getIdPejabat() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt('id') ;
  }
}
