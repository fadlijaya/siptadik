import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../themes/colors.dart';
import '../../themes/padding.dart';
import '../../utils/constants.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  String? receptionist;
  String? nama;
  String? nip;
  String? nik;
  String? provinsi;
  String? kota;
  String? noHp;
  String? alamat;
  String? kategori;
  String? jekel;
  String? jabatan;
  String? unitKerja;
  String? tujuanBertamu;
  String? pejabat;
  String? foto;
  String? createdAt;
  DetailPage(
      {Key? key,
      this.receptionist,
      this.nama,
      this.nip,
      this.nik,
      this.provinsi,
      this.kota,
      this.noHp,
      this.alamat,
      this.kategori,
      this.jekel,
      this.jabatan,
      this.unitKerja,
      this.tujuanBertamu,
      this.pejabat,
      this.foto,
      this.createdAt})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.symmetric(horizontal: padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [buildIconBack(), buildTextReceptionist(), buildTitlePage(), buildDetail(size)],
          ),
        ),
      ),
    ));
  }

  Widget buildIconBack() {
    return IconButton(
        padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back,
          color: kGreen2,
        ));
  }

  Widget buildTextReceptionist() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text("Receptionist : ")),
        Text("${widget.receptionist}", style: const TextStyle(fontWeight: FontWeight.w600),)
      ],
    );
  }

  Widget buildTitlePage() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 16, 16),
      child: Text(
        titleDetailTamu,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildDetail(Size size) {
    String day = DateFormat.EEEE("id_ID").format(DateTime.parse(widget.createdAt.toString()));
    String date = DateFormat.d("id_ID").format(DateTime.parse(widget.createdAt.toString()));
    String monthYears = DateFormat.yMMM("id_ID").format(DateTime.parse(widget.createdAt.toString()));
    //String times = DateFormat.Hm("id_ID").format(DateTime.parse(widget.createdAt.toString()));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: kGreen2.withOpacity(0.3)),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                "${widget.kategori}",
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Text("$day, $date $monthYears", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Nama",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              "${widget.nama}",
              style: const TextStyle(fontSize: 12),
            )
          ],
        ),
        const Divider(thickness: 1),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "NIP",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              "${widget.nip}",
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        const Divider(thickness: 1),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "NIK",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              "${widget.nik}",
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        const Divider(thickness: 1),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Provinsi",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              "${widget.provinsi}",
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        const Divider(thickness: 1),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Kota/Kabupaten",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              "${widget.kota}",
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        const Divider(thickness: 1),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "No.Handphone",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              "${widget.noHp}",
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        const Divider(thickness: 1),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Alamat",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              "${widget.alamat}",
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        const Divider(thickness: 1),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Jenis Kelamin",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              "${widget.jekel}",
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        const Divider(thickness: 1),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Jabatan",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              "${widget.jabatan}",
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        const Divider(thickness: 1),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Unit Kerja",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Text(
              "${widget.unitKerja}",
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        const Divider(thickness: 1),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Tujuan Bertamu",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Flexible(
              child: Text(
                "${widget.tujuanBertamu}",
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.end,
              ),
            )
          ],
        ),
        const Divider(thickness: 1),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Pejabat yang ingin ditemui",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            Flexible(
              child: Text(
                "${widget.pejabat}",
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.end,
              ),
            )
          ],
        ),
        const Divider(
          thickness: 1,
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Foto",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            TextButton(
                onPressed: showPhoto,
                child: const Text(
                  "Lihat",
                  style: TextStyle(fontSize: 12),
                ))
          ],
        ),
      ],
    );
  }

  showPhoto() {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AlertDialog(
                backgroundColor: kTransparant,
                content: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.close,
                              color: kWhite,
                            )),
                      ],
                    ),
                    Image.network(
                      "${widget.foto}",
                      errorBuilder: (context, error, stackTrace) {
                        return Column(
                          children: const [
                            Icon(
                              Icons.broken_image,
                              color: kGrey,
                              size: 120,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Upps, Gagal Memuat Foto!",
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
