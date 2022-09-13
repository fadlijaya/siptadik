import 'dart:io';

import 'package:flutter/material.dart';
import 'package:siptadik/helpers/helpers.dart';
import 'package:siptadik/page/login_page.dart';
import 'package:siptadik/page/resepsionis/resepsionis_page.dart';
import 'package:siptadik/theme/colors.dart';
import 'package:siptadik/theme/material_colors.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

String? token;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  token = await Helpers().getToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Siptadik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: colorTheme, fontFamily: 'Poppins'),
      initialRoute: '/',
      routes: {'/resepsionis': (_) => ResepsionisPage()},
      home: const SplashScreens(),
    );
  }
}

class SplashScreens extends StatelessWidget {
  const SplashScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
        backgroundColor: kGreen2,
        text: 'Siptadik',
        textType: TextType.TyperAnimatedText,
        textStyle: const TextStyle(
            fontSize: 40, color: kWhite, fontWeight: FontWeight.bold),
        duration: 3000,
        navigateRoute:
            token == null ? const LoginPage() : const ResepsionisPage());
  }
}
