import 'package:flutter/material.dart';
import 'package:siptadik/utils/constants.dart';

import '../../themes/colors.dart';
import '../../themes/padding.dart';

class AkunPage extends StatefulWidget {
  final String nama;
  final String nip;
  const AkunPage(
      {Key? key, required this.nama, required this.nip})
      : super(key: key);

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  final TextEditingController _controllerNama = TextEditingController();
  final TextEditingController _controllerNip = TextEditingController();

  @override
  void initState() {
    setState(() {
      _controllerNama.text = widget.nama;
      _controllerNip.text = widget.nip;
    });
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
          children: [buildIconBack(), buildTextPage(), buildFormProfil()],
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

  Widget buildTextPage() {
    return Row(
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
          child: Text(
            titleAkun,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFormProfil() {
    return Container(
      padding: const EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: kGrey.withOpacity(0.5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nama",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                TextFormField(
                  readOnly: true,
                  controller: _controllerNama,
                  cursorColor: kGreen2,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: kBlack6),
                  decoration: const InputDecoration(
                      hintText: '', border: InputBorder.none),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: kGrey.withOpacity(0.5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "NIP",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                TextFormField(
                  readOnly: true,
                  controller: _controllerNip,
                  cursorColor: kGreen2,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: kBlack6),
                  decoration: const InputDecoration(
                      hintText: '', border: InputBorder.none),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}