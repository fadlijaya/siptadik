import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services.dart/tamu_services.dart';
import '../../theme/colors.dart';
import '../../theme/padding.dart';
import '../../utils/constants.dart';
import 'detail_tamu_page.dart';

class RiwayatTamuPage extends StatefulWidget {
  const RiwayatTamuPage({Key? key}) : super(key: key);

  @override
  State<RiwayatTamuPage> createState() => _RiwayatTamuPageState();
}

class _RiwayatTamuPageState extends State<RiwayatTamuPage> {
  List _listTamu = [];

  getListTamu() async {
    final response = await TamuServices().getDataTamu();
    if (!mounted) return;
    setState(() {
      _listTamu = response;
    });
  }

  @override
  void initState() {
    getListTamu();
    super.initState();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [buildIconBack(), buildTitlePage(), buildListTamu()],
          )),
    ));
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
        titleRiwayatTamu,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildListTamu() {
    return Expanded(
      child: ListView.builder(
          itemCount: _listTamu.length,
          itemBuilder: (context, i) {
            String dt = _listTamu[i].createdAt;
            String day = DateFormat.EEEE("id_ID").format(DateTime.parse(dt));
            String date = DateFormat.d("id_ID").format(DateTime.parse(dt));
            String monthYears = DateFormat.yMMM("id_ID").format(DateTime.parse(dt));

            return Container(
              color: kWhite,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$day",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "$date $monthYears",
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
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Nama Tamu : ${_listTamu[i].nama}",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
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
                                    tujuanBertamu: _listTamu[i].tujuanBertamu,
                                    pejabat: _listTamu[i].pejabat,
                                    foto: _listTamu[i].foto,
                                    createdAt: _listTamu[i].createdAt,
                                  )));
                    }
                  },
                ),
              ),
            );
          }),
    );
  }
}
