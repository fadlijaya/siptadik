import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siptadik/page/pejabat/pejabat_page.dart';
import 'package:siptadik/page/resepsionis/resepsionis_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:siptadik/utils/constants.dart';
import 'package:http/http.dart' as http;

import '../theme/colors.dart';
import '../theme/padding.dart';
import '../utils/config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  late bool _showPassword = true;
  int? code;
  String? level;

  void togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  login() async {
    final response = await http.post(Uri.parse("$API/auth/login"), body: {
      'username': _controllerUsername.text,
      'password': _controllerPassword.text
    });

    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      int code = responseJson['code'];
      String message = responseJson['message'];

      if (code == 200) {
        Map<String, dynamic> data = responseJson['data'];
        Map<String, dynamic> auth = responseJson['authorization'];

        savePref(data['level'], data['id'], data['nama'], data['username'],
            data['nip'], auth['token_type'], auth['access_token']);

        displaySnackBar(message);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString('level', data['level']);
        await preferences.setInt('id', data['id']);
        await preferences.setString('nama', data['nama']);
        await preferences.setString('username', data['username'] ?? "");
        await preferences.setString('nip', data['nip']);
        await preferences.setInt('ready_at_office', 1);
        // ignore: use_build_context_synchronously
        if (data['level'] == 'receptionist') {
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const ResepsionisPage(),
            ),
            (route) => false,
          );
        } else if (data['level'] == 'pejabat') {
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const PejabatPage(),
            ),
            (route) => false,
          );
        }
      } else {
        displaySnackBar(message);
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      return displaySnackBar('Username atau Password Anda Salah!');
    }
  }

  savePref(String level, int id, String nama, String? username, String nip,
      String typeToken, String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('level', level);
    await preferences.setInt('id', id);
    await preferences.setString('nama', nama);
    await preferences.setString('username', username ?? "");
    await preferences.setString('nip', nip);
    await preferences.setString('token_type', typeToken);
    await preferences.setString('access_token', token);
    // ignore: deprecated_member_use
    await preferences.commit();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      code = preferences.getInt("code");
      level = preferences.getString("level");

      if (level == 'receptionist') {
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const ResepsionisPage(),
          ),
          (route) => false,
        );
      } else if (level == 'pejabat') {
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const PejabatPage(),
          ),
          (route) => false,
        );
      }
    });
  }

  displaySnackBar(text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  showAlertDialogLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: padding),
              child: const Text(
                "Loading...",
                style: TextStyle(fontSize: 12),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [buildHeader(size), buildTextLogin(), buildFormLogin()],
          ),
        ),
      )),
    );
  }

  Widget buildHeader(Size size) {
    return SizedBox(
      width: double.infinity,
      height: size.height / 4,
      child: Center(child: SvgPicture.asset('assets/ilustrasi_login.svg')),
    );
  }

  Widget buildTextLogin() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(textWelcomeBack,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 30,
            ),
            Text(
              titleLogin,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              textInformasi,
              style: TextStyle(fontSize: 12, color: kBlack6),
            ),
          ],
        ));
  }

  Widget buildFormLogin() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Username",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: kGreen2.withOpacity(0.1)),
              child: TextFormField(
                controller: _controllerUsername,
                cursorColor: kGreen,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontSize: 12),
                decoration: const InputDecoration(
                  hintText: 'Username / NIP',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 16),
                  prefixIcon: Icon(
                    Icons.account_circle_rounded,
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lengkapi!";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Password",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: kGreen2.withOpacity(0.1)),
              child: TextFormField(
                controller: _controllerPassword,
                obscureText: _showPassword,
                cursorColor: kGreen,
                textInputAction: TextInputAction.done,
                style: const TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'Password',
                  contentPadding: const EdgeInsets.only(top: 16),
                  prefixIcon: const Icon(Icons.key),
                  border: InputBorder.none,
                  suffixIcon: GestureDetector(
                    onTap: togglePasswordVisibility,
                    child: _showPassword
                        ? const Icon(
                            Icons.visibility_off,
                            color: kGrey5,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: kGrey5,
                          ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Lengkapi!";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            buildButtonLogin(),
          ],
        ));
  }

  Widget buildButtonLogin() {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(kGreen2),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          showAlertDialogLoading(context);
          login();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 24, right: 24),
        width: double.infinity,
        height: 48,
        child: const Center(
          child: Text(
            'Login',
            style: TextStyle(color: kWhite, fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
