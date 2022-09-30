import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siptadik/page/pejabat/agenda_page.dart';
import 'package:siptadik/page/pejabat/akun_page.dart';
import 'package:siptadik/services.dart/pejabat_service.dart';
import 'package:siptadik/theme/padding.dart';
import 'package:siptadik/utils/constants.dart';

import '../../theme/colors.dart';
import '../login_page.dart';
import '../resepsionis/akun/tentang_page.dart';
import 'detail_page.dart';

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
  bool status = false;

  Future getPejabat() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getInt('id');
      nama = preferences.getString('nama');
      username = preferences.getString('username');
      nip = preferences.getString('nip');
    });
  }

  getListTamuPejabat() async {
    final response = await PejabatService().getDataTamuPejabat();
    if (!mounted) return;
    setState(() {
      listTamuPejabat = response;
    });
  }

  Future onRefresh() async {
    await getListTamuPejabat();
  }

  @override
  void initState() {
    getPejabat();
    getListTamuPejabat();
    onRefresh();
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
        child: listTamuPejabat.isEmpty
        ? buildNoData()
        : buildListTamuPejabat()
      ),
    );
  }

  Widget buildNoData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/no_data.svg', width: 60,),
        const SizedBox(height: 4,),
        const Text("Belum Ada Tamu")
      ],
    );
  }

  Widget buildListTamuPejabat() {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: listTamuPejabat.length,
                itemBuilder: (context, i) {
                  String date = listTamuPejabat[i].createdAt;
                  String day = DateFormat('d').format(DateTime.parse(date));
                  String month = DateFormat('MMMM').format(DateTime.parse(date));
            
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(
                                  receptionist: listTamuPejabat[i].receptionist,
                                  nama: listTamuPejabat[i].nama,
                                  nip: listTamuPejabat[i].nip,
                                  nik: listTamuPejabat[i].nik,
                                  provinsi: listTamuPejabat[i].provinces,
                                  kota: listTamuPejabat[i].regencies,
                                  noHp: listTamuPejabat[i].noHp,
                                  alamat: listTamuPejabat[i].alamat,
                                  kategori: listTamuPejabat[i].category,
                                  jekel: listTamuPejabat[i].jenisKelamin,
                                  jabatan: listTamuPejabat[i].jabatan,
                                  unitKerja: listTamuPejabat[i].unitKerja,
                                  tujuanBertamu: listTamuPejabat[i].tujuanBertamu,
                                  pejabat: listTamuPejabat[i].pejabat,
                                  foto: listTamuPejabat[i].foto,
                                  createdAt: listTamuPejabat[i].createdAt,
                                ))),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: Image.network(
                              "${listTamuPejabat[i].foto}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Column(
                                  children: const [
                                    Icon(
                                      Icons.broken_image,
                                      color: kGrey,
                                      size: 60,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: kGreen2.withOpacity(0.3)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Text(
                                "${listTamuPejabat[i].category}",
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                            Text(
                              "$day ${month.substring(0, 3)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12),
                            )
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${listTamuPejabat[i].nama}",
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "${listTamuPejabat[i].jabatan}",
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "${listTamuPejabat[i].tujuanBertamu}",
                              style: const TextStyle(fontSize: 12),
                            ),
                            const Divider(thickness: 1,)
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget buildDrawer() {
    return Column(
      children: [
        buildHeader(),
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
      width: double.infinity,
      color: kGreen2,
      padding: const EdgeInsets.only(top: 60, bottom: 20),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: kTransparant,
            backgroundImage: NetworkImage(
                "https://icons.veryicon.com/png/o/business/multi-color-financial-and-business-icons/user-139.png"),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "$nama",
            style: const TextStyle(fontSize: 14, color: kWhite),
          ),
          const SizedBox(height: 12,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(textDiKantor, style: TextStyle(color: kWhite),),
                Switch(
                  
                  activeColor: kWhite,
                  value: status, 
                  onChanged: (value){
                  setState(() {
                    status = value;
                  });
                })
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildBody(context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 24, 8, 200),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(
                Icons.home,
                color: kGreen2,
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                "Beranda",
              )
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AgendaPage())),
            child: Row(
              children: const [
                Icon(
                  Icons.task,
                  color: kGreen2,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  "Agenda",
                )
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AkunPage(
                          nama: nama.toString(),
                          nip: nip.toString(),
                        ))),
            child: Row(
              children: const [
                Icon(
                  Icons.account_circle,
                  color: kGreen2,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  "Akun",
                  style: TextStyle(),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => TentangPage())),
            child: Row(
              children: const [
                Icon(
                  Icons.info,
                  color: kGreen2,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  "Tentang",
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
          children: const [
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
