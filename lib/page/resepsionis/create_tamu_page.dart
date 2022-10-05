import 'dart:async';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:siptadik/models/tamu/response_tamu_models.dart';
import 'package:siptadik/services.dart/pejabat_service.dart';
import 'package:siptadik/services.dart/regional_service.dart';
import 'package:siptadik/services.dart/tamu_services.dart';
import 'package:siptadik/theme/colors.dart';
import 'package:siptadik/theme/padding.dart';
import 'package:siptadik/utils/constants.dart';
import '../../models/tamu/post_tamu_models.dart';

class CreateTamuPage extends StatefulWidget {
  final String id;
  const CreateTamuPage({Key? key, required this.id}) : super(key: key);

  @override
  State<CreateTamuPage> createState() => _CreateTamuPageState();
}

class _CreateTamuPageState extends State<CreateTamuPage> {
  final _formKey = GlobalKey<FormState>();
  var _photoFile;
  var _photoName;
  String _jekel = "";
  ResponseTamu? responseTamu;
  PostTamu? tamu;
  List listProvinsi = [];
  List listKota = [];
  List listTamu = [];
  Timer? timer;

  final List<Map> _listKategori = [
    {'id': 1, 'kategori': 'Tamu Pusat'},
    {'id': 2, 'kategori': 'Tamu Provinsi'},
    {'id': 3, 'kategori': 'Tamu Umum'}
  ];

  final List<Map> _listPejabat = [
    {'id': 1, 'pejabat': 'Pejabat 1'},
    {'id': 2, 'pejabat': 'Pejabat 2'},
    {'id': 3, 'pejabat': 'Pejabat 3'},
    {'id': 4, 'pejabat': 'Pejabat 4'},
    {'id': 5, 'pejabat': 'Pejabat 5'},
    {'id': 6, 'pejabat': 'Pejabat 6'}
  ];

  List _list = [];

  getListPejabat() async {
    var response = await PejabatService().getDataPejabat();
    if (!mounted) return;
    setState(() {
      _list = response;
    });
  }

  String? _selectedKategoriId;
  String? _selectedProvinsiId;
  String? _selectedKotaId;
  String? _selectedPejabatId;

  final TextEditingController _controllerNama = TextEditingController();
  final TextEditingController _controllerNip = TextEditingController();
  final TextEditingController _controllerNik = TextEditingController();
  final TextEditingController _controllerNoHp = TextEditingController();
  final TextEditingController _controllerAlamat = TextEditingController();
  final TextEditingController _controllerJabatan = TextEditingController();
  final TextEditingController _controllerUnitKerja = TextEditingController();
  final TextEditingController _controllerTujuanBertamu =
      TextEditingController();

  pickPhoto() async {
    final XFile? photo =
        await ImagePicker().pickImage(source: ImageSource.camera);
    var filePath = File(photo!.path);
    var fileName = filePath.path.split('/').last;
    setState(() {
      _photoFile = filePath;
      _photoName = fileName;
    });
  }

  getProvinsi() async {
    final response = await RegionalServices().getDataProvinsi();
    if (!mounted) return;
    setState(() {
      listProvinsi = response;
    });
  }

  getKota(String idProvinsi) async {
    final response = await RegionalServices().getDataKota(idProvinsi);
    if (!mounted) return;
    setState(() {
      listKota = response;
    });
  }

  getListTamu() async {
    final response = await TamuServices().getDataTamu();
    if (!mounted) return;
    setState(() {
      listTamu = response;
    });
  }

  Future refreshInputTamu() async {
    getListTamu();
  }

  showAlertDialogLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: padding),
              child: Text(
                "Loading...",
                style: TextStyle(fontSize: 12),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertSubmitSuccess() {
    showDialog(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AlertDialog(
                content: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/submit_done.svg",
                      width: 90,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Berhasil Menambahkan Data',
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                actions: [
                  Center(
                      child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Tutup")))
                ],
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    getProvinsi();
    getListPejabat();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFormTamu(size),
            ],
          ),
        ),
      )),
    );
  }

  Widget buildIconBack() {
    return IconButton(
        padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back,
          color: kGreen2,
        ));
  }

  Widget buildTextPage() {
    return const Padding(
      padding: EdgeInsets.only(top: padding, bottom: 24, left: padding),
      child: Text(
        titleInputTamu,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildFormTamu(Size size) {
    return RefreshIndicator(
      onRefresh: refreshInputTamu,
      color: kGreen2,
      child: Form(
          key: _formKey,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildIconBack(),
                buildTextPage(),
                const Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Text(
                    "Kategori Tamu",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: padding),
                  child: DropdownButton(
                    items: _listKategori
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value['kategori'],
                                style: TextStyle(fontSize: 12),
                              ),
                              value: value['id'].toString(),
                            ))
                        .toList(),
                    onChanged: (selected) {
                      setState(() {
                        _selectedKategoriId = selected as String;
                      });
                    },
                    value: _selectedKategoriId,
                    isExpanded: true,
                    hint: const Text(
                      'Pilih Kategori Tamu',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: padding,
                  ),
                  child: Text(
                    "Nama",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: padding, vertical: 8),
                  padding: const EdgeInsets.symmetric(
                      vertical: 4, horizontal: padding),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kGreen2.withOpacity(0.1)),
                  child: TextFormField(
                    controller: _controllerNama,
                    cursorColor: kGreen2,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                        hintText: 'Masukkan Nama', border: InputBorder.none),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lengkapi!';
                      }
                      return null;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Text(
                    "NIP",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: padding, vertical: 8),
                  padding: const EdgeInsets.symmetric(
                      vertical: 4, horizontal: padding),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kGreen2.withOpacity(0.1)),
                  child: TextFormField(
                    controller: _controllerNip,
                    cursorColor: kGreen2,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                        hintText: 'Masukkan NIP', border: InputBorder.none),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lengkapi!';
                      }
                      return null;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Text(
                    "NIK",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: padding, vertical: 8),
                  padding: const EdgeInsets.symmetric(
                      vertical: 4, horizontal: padding),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kGreen2.withOpacity(0.1)),
                  child: TextFormField(
                    controller: _controllerNik,
                    cursorColor: kGreen2,
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                        hintText: 'Masukkan NIK', border: InputBorder.none),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lengkapi!';
                      } else if (value.length < 16) {
                        return 'NIK Salah!';
                      }
                      return null;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Text(
                    "No.Handphone",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: padding, vertical: 8),
                  padding: const EdgeInsets.symmetric(
                      vertical: 4, horizontal: padding),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kGreen2.withOpacity(0.1)),
                  child: TextFormField(
                    controller: _controllerNoHp,
                    cursorColor: kGreen2,
                    keyboardType: TextInputType.number,
                    maxLength: 13,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                        hintText: 'Masukkan No.Handphone',
                        border: InputBorder.none),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lengkapi!';
                      } else if (value.length < 12) {
                        return 'No.Handphone Salah!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Text(
                    "Provinsi",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                /*Container(
                    margin: const EdgeInsets.symmetric(horizontal: padding),
                    child: DropdownButtonFormField(
                      key: UniqueKey(),
                        value: listProvinsi[0],
                        items: listProvinsi.map((provinsi) {
                          return DropdownMenuItem(
                              value: provinsi['id'].toString(),
                              child: Text(provinsi['name']));
                        }).toList(),
                        onChanged: (selected) {
                          setState(() {
                            _selectedProvinsiId = selected as String;
                            getKota(_selectedProvinsiId.toString());
                          });
                        })),*/
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: padding),
                  child: DropdownButton(
                    items: listProvinsi
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value.name,
                                style: TextStyle(fontSize: 12),
                              ),
                              value: value.id.toString(),
                            ))
                        .toList(),
                    onChanged: (selected) {
                      setState(() {
                        _selectedProvinsiId = selected as String;
                        getKota(_selectedProvinsiId.toString());
                      });
                    },
                    value: _selectedProvinsiId,
                    isExpanded: true,
                    hint: const Text(
                      'Pilih Provinsi',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Text(
                    "Kabupaten/Kota",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: padding),
                  child: DropdownButton(
                    items: listKota
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value.name,
                                style: TextStyle(fontSize: 12),
                              ),
                              value: value.id.toString(),
                            ))
                        .toList(),
                    onChanged: (selected) {
                      setState(() {
                        _selectedKotaId = selected as String;
                      });
                    },
                    value: _selectedKotaId,
                    isExpanded: true,
                    hint: const Text(
                      'Pilih Kota',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Text(
                    "Alamat",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: padding, vertical: 8),
                  padding: const EdgeInsets.symmetric(
                      vertical: 4, horizontal: padding),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kGreen2.withOpacity(0.1)),
                  child: TextFormField(
                    controller: _controllerAlamat,
                    cursorColor: kGreen2,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                        hintText: 'Masukkan Alamat', border: InputBorder.none),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lengkapi!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Text(
                    "Jenis Kelamin",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Row(
                  children: [
                    Radio(
                        activeColor: kGreen2,
                        value: "Pria",
                        groupValue: _jekel,
                        onChanged: (String? value) {
                          setState(() {
                            _jekel = value!;
                          });
                        }),
                    const Text(
                      "Pria",
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Radio(
                        activeColor: kGreen2,
                        value: "Wanita",
                        groupValue: _jekel,
                        onChanged: (String? value) {
                          setState(() {
                            _jekel = value!;
                          });
                        }),
                    const Text(
                      "Wanita",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Text(
                    "Jabatan",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: padding, vertical: 8),
                  padding: const EdgeInsets.symmetric(
                      vertical: 4, horizontal: padding),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kGreen2.withOpacity(0.1)),
                  child: TextFormField(
                    controller: _controllerJabatan,
                    cursorColor: kGreen2,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                        hintText: 'Masukkan Jabatan', border: InputBorder.none),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lengkapi!';
                      }
                      return null;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Text(
                    "Unit Kerja",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: padding, vertical: 8),
                  padding: const EdgeInsets.symmetric(
                      vertical: 4, horizontal: padding),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kGreen2.withOpacity(0.1)),
                  child: TextFormField(
                    controller: _controllerUnitKerja,
                    cursorColor: kGreen2,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                        hintText: 'Masukkan Unit Kerja',
                        border: InputBorder.none),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lengkapi!';
                      }
                      return null;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Text(
                    "Tujuan Bertamu",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: padding, vertical: 8),
                  padding: const EdgeInsets.symmetric(
                      vertical: 4, horizontal: padding),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kGreen2.withOpacity(0.1)),
                  child: TextFormField(
                    controller: _controllerTujuanBertamu,
                    cursorColor: kGreen2,
                    textInputAction: TextInputAction.next,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                        hintText: 'Keterangan', border: InputBorder.none),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lengkapi!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.only(left: padding),
                  child: Text(
                    "Pejabat yang ingin ditemui",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: padding),
                  child: DropdownButton(
                    items: _list
                        .map((value) => DropdownMenuItem(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    value.nama,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  value.readyAtOffice == 1
                                      ? Row(children: [
                                          Icon(
                                            Icons.circle,
                                            color: kGreen,
                                            size: 8,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Di Kantor",
                                            style: TextStyle(
                                                color: kGreen, fontSize: 10),
                                          )
                                        ])
                                      : Row(children: [
                                          Icon(
                                            Icons.circle,
                                            color: kGrey,
                                            size: 8,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Tidak Di Kantor",
                                            style: TextStyle(
                                                color: kBlack6, fontSize: 10),
                                          )
                                        ])
                                ],
                              ),
                              value: value.id.toString(),
                            ))
                        .toList(),
                    onChanged: (selected) {
                      setState(() {
                        _selectedPejabatId = selected as String;
                      });
                    },
                    value: _selectedPejabatId,
                    isExpanded: true,
                    hint: const Text(
                      'Pilih Pejabat',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                _photoFile != null ? viewPhoto() : buildAddPhoto(),
                buildButtonSubmit()
              ],
            ),
          )),
    );
  }

  Widget viewPhoto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: double.infinity,
            height: 200,
            padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: padding),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                _photoFile,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_not_supported_rounded,
                      color: kGrey,
                    ),
                  );
                },
              ),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: padding),
          child: Text(
            "$_photoName",
            style: TextStyle(fontSize: 12),
          ),
        ),
        buildAddPhoto()
      ],
    );
  }

  Widget buildAddPhoto() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: padding),
      child: DottedBorder(
        borderType: BorderType.RRect,
        dashPattern: const [10, 4],
        radius: const Radius.circular(8),
        strokeCap: StrokeCap.round,
        color: Colors.grey.shade300,
        child: GestureDetector(
          onTap: pickPhoto,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
                color: kGrey.withOpacity(.3),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add_a_photo,
                  color: kGreen2,
                  size: 40,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Upload Foto',
                  style: TextStyle(fontWeight: FontWeight.w500, color: kGrey5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButtonSubmit() {
    return Container(
      alignment: Alignment.bottomCenter,
      margin:
          const EdgeInsets.symmetric(vertical: padding, horizontal: padding),
      child: ElevatedButton(
          onPressed: () {
            setState(() {
              submitData();
            });
          },
          style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 12)),
              backgroundColor: MaterialStateProperty.all(kGreen2),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)))),
          child: const Center(
            child: Text(
              "Submit",
              style: TextStyle(color: kWhite),
            ),
          )),
    );
  }

  submitData() async {
    if (_formKey.currentState!.validate()) {
      if (_photoFile != null) {
        showAlertDialogLoading(context);
        timer = Timer.periodic(const Duration(seconds: 10), (_) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Maaf, Terjadi Kesalahan, Server Tidak Merespon")));
        });
        var response = await TamuServices().createDataTamu(
            _controllerNama.text,
            _controllerNip.text,
            _controllerNik.text,
            _controllerNoHp.text,
            _controllerAlamat.text,
            _selectedProvinsiId.toString(),
            _selectedKotaId.toString(),
            _jekel,
            _controllerJabatan.text,
            _controllerUnitKerja.text,
            _selectedKategoriId.toString(),
            widget.id,
            _controllerTujuanBertamu.text,
            _selectedPejabatId.toString(),
            _photoFile);

        if (response != null) {
          setState(() {
            tamu = response.data;
          });

          if (response.data != null) {
            _controllerNama.clear();
            _controllerNip.clear();
            _controllerNik.clear();
            _controllerNoHp.clear();
            _controllerAlamat.clear();
            _selectedProvinsiId = null;
            _selectedKotaId = null;
            _jekel = "";
            _controllerJabatan.clear();
            _controllerUnitKerja.clear();
            _selectedKategoriId = null;
            //widget.id
            _controllerTujuanBertamu.clear();
            _selectedPejabatId = null;
            _photoFile = null;

            Navigator.pop(context);
            refreshInputTamu();
            showAlertSubmitSuccess();
          } else {
            Navigator.pop(context);
            showScaffoldMessage();
          }
        }
      } else {
        showToastAlert();
      }
    }
  }

  showScaffoldMessage() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Maaf, Terjadi Kesalahan, Server Tidak Merespon")));
  }

  showToastAlert() {
    Fluttertoast.showToast(
        msg: "Lengkapi dengan Upload Foto!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: kRed,
        textColor: kWhite,
        fontSize: 14.0);
  }
}
