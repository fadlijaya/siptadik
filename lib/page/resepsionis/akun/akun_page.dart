import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siptadik/page/resepsionis/akun/data_pribadi_page.dart';
import 'package:siptadik/page/resepsionis/akun/tentang_page.dart';
import 'package:siptadik/page/login_page.dart';
import 'package:siptadik/page/resepsionis/myqr_page.dart';
import 'package:siptadik/theme/colors.dart';
import 'package:siptadik/utils/constants.dart';

import '../../../theme/padding.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({Key? key}) : super(key: key);

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  String? nama;
  String? username;
  String? nip;

  Future getReceptionist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nama = preferences.getString('nama');
      username = preferences.getString('username');
      nip = preferences.getString('nip');
    });
  }

  @override
  void initState() {
    getReceptionist();
    super.initState();
  }

  alertDialogLogout() {
    showDialog(
        context: context,
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AlertDialog(
                title: const Text("Konfirmasi"),
                content: const Text("Keluar dari Aplikasi?"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Batal")),
                  TextButton(onPressed: signOut, child: const Text("Ya")),
                ],
              ),
            ],
          );
        });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("code", 0);
      preferences.clear();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            buildHeader(size),
            buildButtonProfil(),
            buildButtonTentang(),
            buildButtonLogout()
          ],
        ),
      )),
    );
  }

  Widget buildIconBack() {
    return IconButton(
        padding: const EdgeInsets.all(padding),
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back,
          color: kGreen2,
        ));
  }

  Widget buildTitlePage() {
    return const Padding(
      padding: EdgeInsets.all(padding),
      child: Text(
        titleProfil,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildProfil() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(padding),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
                "https://raw.githubusercontent.com/ArjunAtlast/Profile-Card/master/assets/john-doe.png"),
            backgroundColor: kGreen2,
          ),
          Padding(
            padding: const EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$nama",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$username",
                  style: const TextStyle(fontSize: 12, color: kBlack6),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildHeader(Size size) {
    return SizedBox(
      width: size.width,
      height: size.height / 3.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [buildIconBack(), buildTitlePage(), buildProfil()],
      ),
    );
  }

  Widget buildButtonProfil() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kGrey.withOpacity(0.5)),
      child: ListTile(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DataPribadiPage(
          nama: nama.toString(), 
          username: username.toString(), 
          nip: nip.toString()))),
        leading: const Icon(
          Icons.account_circle_rounded,
          color: kGreen2,
        ),
        title: const Text(
          titleDataPribadi,
          style: TextStyle(fontSize: 14),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 12,
        ),
      ),
    );
  }

  Widget buildButtonTentang() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kGrey.withOpacity(0.5)),
      child: ListTile(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TentangPage())),
        leading: const Icon(
          Icons.info,
          color: kGreen2,
        ),
        title: const Text(
          titleInfo,
          style: TextStyle(fontSize: 14),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 12,
        ),
      ),
    );
  }

  Widget buildButtonLogout() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kGrey.withOpacity(0.5)),
      child: ListTile(
        onTap: alertDialogLogout,
        leading: const Icon(
          Icons.exit_to_app,
          color: kRed,
        ),
        title: const Text(
          titleLogout,
          style: TextStyle(fontSize: 14),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 12,
        ),
      ),
    );
  }
}
