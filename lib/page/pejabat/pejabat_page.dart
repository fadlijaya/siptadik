import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siptadik/page/pejabat/akun_page.dart';
import 'package:siptadik/services.dart/pejabat_service.dart';
import 'package:siptadik/theme/padding.dart';
import 'package:siptadik/utils/constants.dart';

import '../../theme/colors.dart';
import '../login_page.dart';
import '../resepsionis/akun/tentang_page.dart';

class PejabatPage extends StatefulWidget {
  const PejabatPage({Key? key}) : super(key: key);

  @override
  State<PejabatPage> createState() => _PejabatPageState();
}

class _PejabatPageState extends State<PejabatPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int? id;
  String? nama;
  String? username;
  String? nip;
  List listTamuPejabat = [];

  Future getPejabat() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getInt('id');
      nama = preferences.getString('nama');
      username = preferences.getString('username');
      nip = preferences.getString('nip');
    });
  }

  getListPejabat() async {
    final response = await PejabatService().getDataPejabat();
    if (!mounted) return;
    setState(() {
      listTamuPejabat = response;
    });
  }

  @override
  void initState() {
    getPejabat();
    getListPejabat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        width: size.width / 1.5,
        child: buildDrawer(),
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            icon: const Icon(
              Icons.menu,
              color: kWhite,
            )),
        title: const Text(
          titleApp,
          style: TextStyle(color: kWhite),
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(8),
        child: buildListTamuPejabat(),
      ),
    );
  }

  Widget buildListTamuPejabat() {
    return ListView.builder(
        itemCount: listTamuPejabat.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: Icon(Icons.account_circle_rounded),
            title: Text(listTamuPejabat[i].nama),
          );
        });
  }

  Widget buildDrawer() {
    return Column(
      children: [
        buildHeader(),
        const Divider(
          thickness: 1,
        ),
        buildBody(context),
        const Spacer(),
        const Divider(
          thickness: 1,
        ),
        buildFooter(context)
      ],
    );
  }

  Widget buildHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 60, bottom: 20),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: kWhite,
            backgroundImage: NetworkImage(
                "https://icons.veryicon.com/png/o/business/multi-color-financial-and-business-icons/user-139.png"),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "$nama",
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget buildBody(context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 200),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.home,
                color: kGreen2,
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                "Beranda",
                style: TextStyle(
                  color: kGreen2,
                ),
              )
            ],
          ),
          SizedBox(
            height: 24,
          ),
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AkunPage(
                          nama: nama.toString(),
                          username: username.toString(),
                          nip: nip.toString(),
                        ))),
            child: Row(
              children: [
                Icon(
                  Icons.account_circle,
                  color: kGreen2,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "Akun",
                  style: TextStyle(
                    color: kGreen2,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => TentangPage())),
            child: Row(
              children: [
                Icon(
                  Icons.info,
                  color: kGreen2,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "Tentang",
                  style: TextStyle(
                    color: kGreen2,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFooter(context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
      child: GestureDetector(
        onTap: () => alertDialogLogout(context),
        child: Row(
          children: [
            Icon(
              Icons.exit_to_app,
              color: kRed,
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              "Log out",
              style: TextStyle(
                color: kRed,
              ),
            )
          ],
        ),
      ),
    );
  }

  alertDialogLogout(context) {
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
                  TextButton(
                      onPressed: () => signOut(context),
                      child: const Text("Ya")),
                ],
              ),
            ],
          );
        });
  }

  signOut(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("code", 0);
    preferences.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
  }
}
