import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siptadik/page/resepsionis/detail_tamu_page.dart';
import 'package:siptadik/page/resepsionis/riwayat_tamu_page.dart';
import 'package:siptadik/page/resepsionis/myqr_page.dart';
import 'package:siptadik/page/resepsionis/search_page.dart';
import 'package:siptadik/services.dart/tamu_services.dart';
import 'package:siptadik/theme/colors.dart';
import 'package:siptadik/theme/padding.dart';
import 'package:siptadik/utils/constants.dart';

import 'akun/akun_page.dart';
import 'create_tamu_page.dart';
import '../login_page.dart';

class ResepsionisPage extends StatefulWidget {
  const ResepsionisPage({Key? key}) : super(key: key);

  @override
  State<ResepsionisPage> createState() => _ResepsionisPageState();
}

class _ResepsionisPageState extends State<ResepsionisPage> {
  String? level;
  int? id;
  String? nama;
  String? username;
  String? nip;

  // ignore: unused_field
  List _listTamu = [];

  Future getReceptionist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      level = preferences.getString('level');
      id = preferences.getInt('id');
      nama = preferences.getString('nama');
      username = preferences.getString('username');
      nip = preferences.getString('nip');
    });
  }

  getListTamu() async {
    final response = await TamuServices().getDataTamu();
    if (!mounted) return;
    setState(() {
      _listTamu = response;
    });
  }

  checkPermissions() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    }
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

  Future onRefreshListTamu() async {
    getListTamu();
  }

  @override
  void initState() {
    if (level != "receptionist") {
      signOut();
    }
    checkPermissions();
    getReceptionist();
    getListTamu();
    onRefreshListTamu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(size),
              buildSearch(),
              buildItem(size),
              buildDateTime(),
              buildText(),
              buildListTamu(size)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(Size size) {
    return Container(
      width: size.width,
      height: 120,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        titleHomePage,
                      ),
                      Text(
                        "$nama",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    "$username",
                    style: const TextStyle(fontSize: 12, color: kBlack6),
                  )
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AkunPage())),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      "https://raw.githubusercontent.com/ArjunAtlast/Profile-Card/master/assets/john-doe.png"),
                  backgroundColor: kGreen2,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildSearch() {
    return GestureDetector(
      onTap: () {
        showSearch(context: context, delegate: SearchPage(listTamu: _listTamu));
      },
      child: Container(
        width: double.infinity,
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: kGreen2.withOpacity(0.1)),
        child: Row(
          children: const [
            Icon(Icons.search),
            SizedBox(
              width: 12,
            ),
            Text("Search")
          ],
        ),
      ),
    );
  }

  Widget buildItem(Size size) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyQRPage())),
          child: Container(
            width: size.width / 2.3,
            height: 90,
            margin: const EdgeInsets.fromLTRB(16, 16, 8, 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: kOrange),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.qr_code_2,
                  color: kWhite,
                  size: 48,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  titleMyQR,
                  style: TextStyle(fontSize: 12, color: kWhite),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateTamuPage(id: id.toString()))),
            child: Container(
              width: size.width / 2.3,
              height: 90,
              margin: const EdgeInsets.fromLTRB(8, 16, 16, 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: kGreen),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add_task,
                    color: kWhite,
                    size: 48,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    titleInputTamu,
                    style: TextStyle(fontSize: 12, color: kWhite),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildDateTime() {
    final dt = DateTime.now();
    String dtNow = DateFormat.yMMMMEEEEd().format(dt);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: padding),
          child: Text(
            dtNow,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: padding),
          child: Icon(
            Icons.calendar_month,
            color: kGreen2.withOpacity(0.5),
          ),
        )
      ],
    );
  }

  Widget buildText() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            textTamuTerbaru,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RiwayatTamuPage())),
              child: const Text(
                "Lihat Semua",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ))
        ],
      ),
    );
  }

  Widget buildListTamu(Size size) {
    return RefreshIndicator(
      onRefresh: onRefreshListTamu,
      child: SizedBox(
        width: size.width,
        height: size.height / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: _listTamu.length < 3 ? _listTamu.length : 2,
                  itemBuilder: (context, i) {
                    String date = _listTamu[i].createdAt;
                    String hari =
                        DateFormat('EEEE').format(DateTime.parse(date));
                    String tgl =
                        DateFormat('d/MM/yyyy').format(DateTime.parse(date));

                    return Container(
                      color: kWhite,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                hari,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                tgl,
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: kGreen2.withOpacity(0.3)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                child: Text(
                                  "${_listTamu[i].category}",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "Nama Tamu : ${_listTamu[i].nama}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Tujuan Bertamu : ${_listTamu[i].tujuanBertamu}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (_) {
                              return <PopupMenuEntry<String>>[]
                                ..add(PopupMenuItem<String>(
                                  child: Text(
                                    "Detail",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  value: 'detail',
                                ));
                            },
                            onSelected: (String value) {
                              if (value == "detail") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailTamuPage(
                                              nama: _listTamu[i].nama,
                                              nip: _listTamu[i].nip,
                                              nik: _listTamu[i].nik,
                                              provinsi: _listTamu[i].provinces,
                                              kota: _listTamu[i].regencies,
                                              noHp: _listTamu[i].noHp,
                                              alamat: _listTamu[i].alamat,
                                              kategori: _listTamu[i].category,
                                              jekel: _listTamu[i].jenisKelamin,
                                              jabatan: _listTamu[i].jabatan,
                                              unitKerja: _listTamu[i].unitKerja,
                                              tujuanBertamu:
                                                  _listTamu[i].tujuanBertamu,
                                              pejabat: _listTamu[i].pejabat,
                                              foto: _listTamu[i].foto,
                                              createdAt: _listTamu[i].createdAt,
                                            )));
                              }
                            },
                          )),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}