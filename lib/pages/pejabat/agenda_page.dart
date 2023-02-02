import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horizontalcalender/horizontalcalendar.dart';
import 'package:intl/intl.dart';
import 'package:siptadik/helpers/helpers.dart';
import 'package:siptadik/models/agenda/post_agenda_models.dart';
import 'package:siptadik/services/agenda_service.dart';
import 'package:siptadik/utils/constants.dart';

import '../../models/agenda/response_agenda_models.dart';
import '../../models/agenda_models.dart';
import '../../themes/colors.dart';
import '../../themes/padding.dart';

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
  Future<ResponseAgenda>? _futureAgenda;

  getDataAgenda() async {
    var response = await AgendaService().getAgenda();
    if (!mounted) return;
    setState(() {
      _listAgenda = response;
    });
  }

  Future onRefresh() async {
    await getDataAgenda();
  }

  @override
  void initState() {
    super.initState();
    getDataAgenda();
    onRefresh();
  }

  createAgenda() {
    showDialog(
        barrierDismissible: false,
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: _controllerAgenda,
                            style: const TextStyle(fontSize: 14),
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                labelText: 'Nama Agenda',
                                labelStyle: TextStyle(fontSize: 14)),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Mohon Lengkapi';
                              }
                              return null;
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
                                      DateFormat('yyyy-MM-dd HH:mm:ss')
                                          .format(date);
                                  print(saveDt);
                                  String dt = DateFormat('dd MMMM yyyy HH:mm')
                                      .format(date);
                                  setState(() {
                                    saveDt = dtFormat;
                                    dateTime = dt;
                                  });
                                }, locale: LocaleType.id);
                              },
                              icon: const Icon(
                                Icons.timer,
                                color: kGreen2,
                              ),
                              label: const Text(
                                "Waktu Agenda",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          dateTime == null
                              ? const Text("")
                              : Text(
                                  '$dateTime',
                                  style: const TextStyle(fontSize: 14),
                                ),
                          TextFormField(
                            controller: _controllerTempat,
                            style: const TextStyle(fontSize: 14),
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
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
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              labelText: 'Keterangan',
                              labelStyle: TextStyle(fontSize: 14),
                            ),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Mohon Lengkapi';
                              }
                              return null;
                            },
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 16, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                _controllerAgenda.clear();
                                dateTime = null;
                                _controllerTempat.clear();
                                _controllerKeterangan.clear();
                                Navigator.pop(context);
                              },
                              child: const Text("Batal")),
                          ElevatedButton(
                              onPressed: () async {
                                int idPejabat =
                                    await Helpers().getIdPejabat() as int;
                                if (_formKey.currentState!.validate()) {
                                  if (dateTime == null) {
                                    Fluttertoast.showToast(
                                        msg: "Mohon Lengkapi Waktu Agenda",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 14.0);
                                  } else {
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
                                        onRefresh();
                                      });

                                      Navigator.pop(context);
                                      _controllerAgenda.clear();
                                      dateTime = null;
                                      _controllerTempat.clear();
                                      _controllerKeterangan.clear();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Row(
                                        children: const [
                                          Icon(
                                            Icons.check_circle,
                                            color: kGreen,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(textSuccess),
                                        ],
                                      )));
                                    } else {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Row(
                                        children: const [
                                          Icon(
                                            Icons.info,
                                            color: kRed,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(textDisconnect),
                                        ],
                                      )));
                                    }
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
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: padding),
              child: const Text(
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
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildIconBack(),
              buildTextPage(),
              buildCalender(),
              buildListAgenda()
            ],
          ),
        ),
      )),
    );
  }

  Widget buildIconBack() {
    return IconButton(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
          locale: "id_ID",
          width: MediaQuery.of(context).size.width * .25,
          height: 100,
          selectionColor: kGreen2.withOpacity(0.3),
          dayTextStyle: const TextStyle(fontSize: 12),
          dateTextStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          selectedDateStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          selectedDayStyle: const TextStyle(fontSize: 12),
          selectedTextColor: kWhite,
          itemController: itemController),
    );
  }

  Widget buildListAgenda() {
    return Expanded(
        child: ListView.builder(
            itemCount: _listAgenda.length,
            itemBuilder: (context, i) {
              String? formatDay = DateFormat.EEEE("id_ID")
                  .format(DateTime.parse(_listAgenda[i].waktu));
              String? formatDate = DateFormat.d("id_ID")
                  .format(DateTime.parse(_listAgenda[i].waktu));
              String? formatMonthYears = DateFormat.yMMM("id_ID")
                  .format(DateTime.parse(_listAgenda[i].waktu));
              String? formatTime = DateFormat("HH:mm","id_ID")
                  .format(DateTime.parse(_listAgenda[i].waktu));
              return Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$formatDay ",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$formatDate $formatMonthYears",
                      style: const TextStyle(color: kBlack6, fontSize: 12),
                    ),
                    ListTile(
                      leading: Text("$formatTime "),
                      title: Container(
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: kGrey),
                          child: Text(
                            "${_listAgenda[i].agenda}",
                            style: const TextStyle(fontSize: 14),
                          )),
                      trailing: PopupMenuButton(
                        itemBuilder: (_) {
                          return <PopupMenuEntry<String>>[]
                            ..add(PopupMenuItem<String>(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: kRed,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Hapus",
                                    style: TextStyle(color: kRed, fontSize: 12),
                                  )
                                ],
                              ),
                              value: 'hapus',
                            ));
                        },
                        onSelected: (String value) async {
                          if (value == 'hapus') {
                            setState(() {
                              _futureAgenda = deleteAgenda(_listAgenda[i].id);
                              onRefresh();
                            });

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: kRed,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(textDelete),
                                ],
                              ),
                            ));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
