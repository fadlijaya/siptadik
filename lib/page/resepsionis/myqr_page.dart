import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siptadik/utils/constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../theme/colors.dart';
import '../../theme/padding.dart';

class MyQRPage extends StatefulWidget {
  const MyQRPage({Key? key}) : super(key: key);

  @override
  State<MyQRPage> createState() => _MyQRPageState();
}

class _MyQRPageState extends State<MyQRPage> {
  String? nama;
  String? username;

  Future getReceptionist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nama = preferences.getString('nama');
      username = preferences.getString('username');
    });
  }

  @override
  void initState() {
    getReceptionist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kOrange,
      body: SafeArea(
          child: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [buildIconBack(), buildMyQr(size)],
        ),
      )),
    );
  }

  Widget buildIconBack() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: kWhite,
          )),
    );
  }

  Widget buildTitlePage() {
    return Row(
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 24),
          child: Text(
            titleMyQR,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: kWhite),
          ),
        ),
      ],
    );
  }

  Widget buildProfil() {
    return Column(
      children: [
        Image.asset("assets/receptionist.png", width: 60,),
        const SizedBox(
          height: 8,
        ),
        Text(
          "$nama",
          style: const TextStyle(fontWeight: FontWeight.bold, color: kWhite),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          "$username",
          style: const TextStyle(fontSize: 12, color: kWhite),
        )
      ],
    );
  }

  Widget buildMyQr(Size size) {
    return Column(
      children: [
        buildTitlePage(),
        buildProfil(),
        Container(
          width: size.width / 1.25,
          height: size.height / 2.5,
          margin: const EdgeInsets.only(top: 24),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: kGrey.withOpacity(0.5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImage(
                data: username.toString(),
                version: QrVersions.auto,
                size: 200,
                backgroundColor: kWhite,
              ),
            ],
          ),
        )
      ],
    );
  }
}
