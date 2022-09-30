import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:horizontalcalender/horizontalcalendar.dart';
import 'package:intl/intl.dart';
import 'package:siptadik/helpers/helpers.dart';
import 'package:siptadik/models/agenda/post_agenda_models.dart';
import 'package:siptadik/services.dart/agenda_service.dart';
import 'package:siptadik/utils/constants.dart';

import '../../models/agenda_models.dart';
import '../../theme/colors.dart';
import '../../theme/padding.dart';

class AgendaPage extends StatefulWidget {
 const AgendaPage({Key? key}) : super(key: key);

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerAgenda = TextEditingController();
  final TextEditingController _controllerTempat = TextEditingController();
  final TextEditingController _controllerKeterangan = TextEditingController();

  String? dateTime;
  String? saveDt;
  PostAgenda? _postAgenda;
  List _listAgenda = [];

  getDataAgenda() async {
    var response = await AgendaService().getAgenda();
    if (!mounted) return;
    setState(() {
      _listAgenda = response;
    });
  }

  @override
  void initState() {
    super.initState();
    getDataAgenda();
  }

  createAgenda() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AlertDialog(
                  content: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _controllerAgenda,
                          style: TextStyle(fontSize: 14),
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              labelText: 'Nama Agenda',
                              labelStyle: TextStyle(fontSize: 14)),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Mohon Lengkapi';
                            }
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: TextButton.icon(
                            onPressed: () {
                              DatePicker.showDateTimePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime.now(),
                                  maxTime: DateTime(2030, 6, 7, 05, 09),
                                  onChanged: (date) {
                                print('change $date in time zone ' +
                                    date.timeZoneOffset.inHours.toString());
                              }, onConfirm: (date) {
                                print('confirm $date');
                                String dtFormat =
                                    DateFormat('yyyy-MM-dd hh:mm:ss')
                                        .format(date);
                                print(saveDt);
                                String dt = DateFormat('dd MMMM yyyy hh:mm')
                                    .format(date);
                                setState(() {
                                  saveDt = dtFormat;
                                  dateTime = dt;
                                });
                              }, locale: LocaleType.id);
                            },
                            icon: Icon(
                              Icons.timer,
                              color: kGreen2,
                            ),
                            label: Text(
                              "Waktu Agenda",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        dateTime == null
                            ? Text("")
                            : Text(
                                '$dateTime',
                                style: TextStyle(fontSize: 14),
                              ),
                        TextFormField(
                          controller: _controllerTempat,
                          style: TextStyle(fontSize: 14),
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              labelText: 'Tempat',
                              labelStyle: TextStyle(fontSize: 14)),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Mohon Lengkapi';
                            }
                          },
                        ),
                        TextFormField(
                          controller: _controllerKeterangan,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            labelText: 'Keterangan',
                            labelStyle: TextStyle(fontSize: 14),
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Mohon Lengkapi';
                            }
                          },
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 16, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Batal")),
                          ElevatedButton(
                              onPressed: () async {
                                int idPejabat = await Helpers().getIdPejabat() as int;
                                if (_formKey.currentState!.validate()) {
                                  showAlertDialogLoading(context);
                                  var response = await AgendaService()
                                      .fetchAgenda(
                                          idPejabat.toString(),
                                          _controllerAgenda.text,
                                          saveDt.toString(),
                                          _controllerTempat.text,
                                          _controllerKeterangan.text);

                                  if (response != null) {
                                    setState(() {
                                      _postAgenda = response.data;
                                    });

                                    _controllerAgenda.clear();
                                    saveDt = null;
                                    _controllerTempat.clear();
                                    _controllerKeterangan.clear();
                                    Navigator.pushNamed(context, '/agenda');
                                     ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Berhasil Ditambahkan!")));
                                  } else {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Maaf, Terjadi Kesalahan, Server Tidak Merespon")));
                                  }
                                }
                              },
                              child: Text(
                                "Tambah",
                                style: TextStyle(
                                  color: kWhite,
                                ),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(kGreen2),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))))),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            );
          }));
        });
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
          children: [buildIconBack(), buildTextPage(), buildCalender(), buildListAgenda()],
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
          child: Text(
            titleAgenda,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: padding, vertical: 8),
            child: TextButton.icon(
              onPressed: createAgenda,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text(
                textTambah,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
      ],
    );
  }

  Widget buildCalender() {
    final FixedExtentScrollController itemController =
        FixedExtentScrollController();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: HorizontalCalendar(DateTime.now(),
          width: MediaQuery.of(context).size.width * .25,
          height: 100,
          selectionColor: kGreen2.withOpacity(0.3),
          dayTextStyle: TextStyle(fontSize: 12),
          dateTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          selectedDateStyle:
              TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          selectedDayStyle: TextStyle(fontSize: 12),
          selectedTextColor: kWhite,
          itemController: itemController),
    );
  }

  Widget buildListAgenda() {
    return Expanded(
      child: ListView.builder(
        itemCount: _listAgenda.length,
        itemBuilder: (context, i){
          String? formatDay = DateFormat.EEEE().format(DateTime.parse(_listAgenda[i].waktu));
          String? formatDate = DateFormat.d().format(DateTime.parse(_listAgenda[i].waktu));  
          String? formatMonthYears = DateFormat.yMMMM().format(DateTime.parse(_listAgenda[i].waktu));
          String? formatTime = DateFormat.Hm().format(DateTime.parse(_listAgenda[i].waktu));
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text("$formatDay", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
             SizedBox(height: 8), 
             Row(
               children: [
                Text("$formatDate ", style: TextStyle(color: kBlack6, fontSize: 12),),
                Text("$formatMonthYears", style: TextStyle(color: kBlack6, fontSize: 12),),
               ],
             ),
              ListTile(
                leading: Text("$formatTime"),
                title: Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: kGrey 
                  ),
                  child: Text("${_listAgenda[i].agenda}", style: TextStyle(fontSize: 14),)),
              ),
            ],
          ),
        );
    }));
  }
}
