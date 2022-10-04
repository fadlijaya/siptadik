import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:siptadik/helpers/helpers.dart';
import 'package:siptadik/page/login_page.dart';
import 'package:siptadik/page/pejabat/agenda_page.dart';
import 'package:siptadik/page/pejabat/pejabat_page.dart';
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

String? level;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  level = await Helpers().getLevel();
  await initializeDateFormatting('id_ID', null).then((_) => runApp(MyApp()));
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
      routes: {
        '/resepsionis': (_) => ResepsionisPage(),
        '/pejabat': (_) => PejabatPage(),
        '/agenda': (_) => AgendaPage()
        },
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
        textStyle: const TextStyle(fontSize: 40, color: kWhite, fontWeight: FontWeight.bold),
        duration: 3000,
        navigateRoute: LoginPage());
  }
}
