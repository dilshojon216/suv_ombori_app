import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/controllers.dart';
import '../../constants/style.dart';
import '../../helpers/reponsiveness.dart';
import '../../models/lade_model.dart';
import '../../models/tabelTen_model.dart';
import '../../models/tabel_model.dart';
import '../../services/NetworkHandler.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/message_print.dart';
import '../../widgets/scrollable_widget.dart';
import '../../widgets/text_dialog_widget.dart';

class TabelPage extends StatefulWidget {
  const TabelPage({Key? key}) : super(key: key);

  @override
  _TabelPageState createState() => _TabelPageState();
}

class _TabelPageState extends State<TabelPage> {
  bool cicle = true;
  NetworkHandler networkHandler = NetworkHandler();
  List<LadeModel> sensorNameList = [];
  List<bool> sesnorInt = [];
  List<Tabel>? tabeList;
  List<Tabel>? lasttabeList;
  List<TabelTen>? tabelTen;
  TextEditingController lenthtable = TextEditingController();
  int lastIndex = 0;
  bool tebelBool = true;
  int? sortColumnIndex;
  bool isAscending = false;
  String? sensorname;
  int? tabelLange;
  int cratebtnCount = 0;
  bool editTabel = false;
  bool editBtn = false;
  bool crateBtn = false;
  bool tileString = false;
  bool newTabel = false;
  bool crateClose = false;
  bool newSavebtn = false;

  String? sensorId;
  @override
  void initState() {
    super.initState();
    getLadeList();
  }

  void getLadeList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      var respons =
          await networkHandler.getAllSensor("/api/sensor/getAllSensor", token!);
      setState(() {
        if (respons.statusCode == 200 || respons.statusCode == 201) {
          var resjson = json.decode(respons.body);
          if (resjson is List) {
            var sensor =
                resjson.map((json) => LadeModel.fromJson(json)).toList();
            sensorNameList = sensor;
            for (var i = 0; i < sensor.length; i++) {
              if (i == 0) {
                sesnorInt.add(true);
              } else {
                sesnorInt.add(false);
              }
            }
            sensorname = sensorNameList[0].sensorName;
            sensorId = sensorNameList[0].sensorId;
            getTabel(0);
            cicle = false;
          }
        } else {
          String output = json.decode(respons.body)["msg"];
          pintMessage(output, context, Colors.red);
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Obx(
            () => Row(
              children: [
                Container(
                    margin: EdgeInsets.only(
                        top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                    child: CustomText(
                      text: menuController.activeItem.value + "wew",
                      size: 24,
                      weight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                height: 50,
                child: cicle
                    ? CircularProgressIndicator()
                    : ListView.builder(
                        itemCount: sensorNameList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                sesnorInt[index] = true;
                                sesnorInt[lastIndex] = false;
                                lastIndex = index;
                                sensorname = sensorNameList[index].sensorName;
                                sensorId = sensorNameList[index].sensorId;
                                getTabel(index);
                              });
                            },
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                  left: 40, right: 40, top: 10, bottom: 10),
                              margin: EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: sesnorInt[index] ? active : Colors.white,
                                border: Border.all(
                                    color: !sesnorInt[index]
                                        ? active
                                        : Colors.white,
                                    width: 0.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: CustomText(
                                text: sensorNameList[index].sensorName,
                                color:
                                    !sesnorInt[index] ? active : Colors.white,
                                size: 20,
                                weight: FontWeight.bold,
                              ),
                            ),
                          );
                        }),
              ),
              cicle
                  ? CustomText(text: "Ma'lumot yo'q")
                  : Container(
                      margin: EdgeInsets.only(
                          right:
                              ResponsiveWidget.isSmallScreen(context) ? 10 : 30,
                          top: 10,
                          bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Visibility(
                              visible: !tileString,
                              child: CustomText(
                                text: ResponsiveWidget.isLargeScreen(context)
                                    ? "Kuzatuv nuqta nomi:  " +
                                        sensorname! +
                                        ";   Reka uzunligi: $tabelLange sm"
                                    : "Kuzatuv nuqta nomi:  " +
                                        sensorname! +
                                        ";   \nReka uzunligi: $tabelLange sm",
                                size: 22,
                                weight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Visibility(
                                visible: !editBtn,
                                child: TextButton(
                                  child: Icon(
                                    editTabel ? Icons.close : Icons.create,
                                    color: editTabel ? Colors.red : active,
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      editTabel = !editTabel;
                                      crateBtn = !crateBtn;
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible: !crateBtn,
                                child: TextButton(
                                  child: Icon(
                                    crateClose
                                        ? Icons.close
                                        : Icons.create_new_folder,
                                    color: crateClose ? Colors.red : active,
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (cratebtnCount == 0) {
                                        editBtn = !editBtn;
                                        crateClose = !crateClose;
                                        cratebtnCount = 1;
                                        newTabel = !newTabel;
                                        tileString = !tileString;
                                      } else if (cratebtnCount == 1) {
                                        editBtn = !editBtn;
                                        crateClose = !crateClose;
                                        cratebtnCount = 0;
                                        newTabel = !newTabel;
                                        tileString = !tileString;
                                      } else if (cratebtnCount == 2) {
                                        tabeList = lasttabeList;
                                        printTabelList();
                                        cratebtnCount = 1;
                                        newTabel = !newTabel;
                                        newSavebtn = !newSavebtn;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              Visibility(
                visible: !newTabel,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: active.withOpacity(.4), width: .5),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 6),
                            color: lightGrey.withOpacity(.1),
                            blurRadius: 12)
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.only(bottom: 30),
                    child: tebelBool
                        ? CircularProgressIndicator()
                        : ScrollableWidget(child: buildDataTable())),
              ),
              Visibility(
                  visible: newTabel,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: active.withOpacity(.4), width: .5),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 6),
                            color: lightGrey.withOpacity(.1),
                            blurRadius: 12)
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.only(bottom: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: CustomText(
                                    text: "Yangi kordinata jadvali yasash",
                                    size:
                                        ResponsiveWidget.isLargeScreen(context)
                                            ? 28
                                            : 20,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (ResponsiveWidget.isLargeScreen(context))
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0,
                                      left: 20,
                                      right: 20,
                                      bottom: 20),
                                  child: CustomText(
                                    text: "Jadval uzunligni kiriting (sm):",
                                    size: 24,
                                    color: Colors.black,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.all(10.0),
                                    margin: EdgeInsets.only(
                                        right: 20, top: 5, bottom: 5, left: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: active, width: .5),
                                    ),
                                    child: Container(
                                        height: 35,
                                        width: 200,
                                        child: TextField(
                                          controller: lenthtable,
                                          style: TextStyle(fontSize: 28),
                                        ))),
                                Container(
                                  margin: EdgeInsets.only(left: 30, right: 30),
                                  padding: EdgeInsets.only(
                                      left: 50, right: 50, top: 30, bottom: 30),
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: active,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: active, width: .5),
                                    ),
                                    child: TextButton(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: CustomText(
                                          text: "Jadval yasash",
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          tebelBool = true;
                                          makeTabel();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: CustomText(
                                    text: "Jadval uzunligni kiriting (sm):",
                                    size: 20,
                                    color: Colors.black,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                    padding: EdgeInsets.all(10.0),
                                    margin: EdgeInsets.only(
                                        right: 20, top: 5, bottom: 5, left: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: active, width: .5),
                                    ),
                                    child: Container(
                                        height: 35,
                                        width: 200,
                                        child: TextField(
                                          controller: lenthtable,
                                          style: TextStyle(fontSize: 20),
                                        ))),
                                Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: active,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: active, width: .5),
                                    ),
                                    child: TextButton(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: CustomText(
                                          text: "Jadval yasash",
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          tebelBool = true;
                                          makeTabel();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  )),
              Visibility(
                  visible: newSavebtn,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 30, right: 30),
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 30, bottom: 30),
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              color: active,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: active, width: .5),
                            ),
                            child: TextButton(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: CustomText(
                                  text: "Jadvalni saqlash",
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  saveData();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ))
        ],
      ),
    );
  }

  void getTabel(int index) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      var respons = await networkHandler.getTabelBySensor(
          "/api/tabel/getTabelByname",
          token!,
          {"username": sensorNameList[index].sensorId});

      print(sensorNameList[index].sensorId);

      if (respons.statusCode == 200) {
        var resjson = json.decode(respons.body);
        if (resjson is List) {
          var tabelss = resjson.map((json) => Tabel.fromJson(json)).toList();
          setState(() {
            tabeList = tabelss;
            printTabelList();
            tebelBool = false;
          });
        }
      } else {
        String output = json.decode(respons.body)["msg"];
        pintMessage(output, context, Colors.red);
      }

      print(respons.statusCode);
    } catch (e) {
      print(e.toString());
    }
  }

  void printTabelList() {
    try {
      int tenTabel = tabeList!.length ~/ 10;
      int qoldiqTabel = tabeList!.length % 10;
      List<TabelTen> tabelTen1 = [];
      tabelLange = tabeList!.length > 0 ? tabeList!.length - 1 : 0;
      int cout = 0;
      for (var i = 0; i < tenTabel; i++) {
        TabelTen sdsd = TabelTen(
            zero: null,
            two: null,
            three: null,
            six: null,
            seven: null,
            eight: null,
            first: null,
            five: null,
            four: null,
            nine: null,
            number: '');
        sdsd.number = (i * 10).toString();
        sdsd.zero = tabeList![cout];
        cout++;
        sdsd.first = tabeList![cout];
        cout++;
        sdsd.two = tabeList![cout];
        cout++;
        sdsd.three = tabeList![cout];
        cout++;
        sdsd.four = tabeList![cout];
        cout++;
        sdsd.five = tabeList![cout];
        cout++;
        sdsd.six = tabeList![cout];
        cout++;
        sdsd.seven = tabeList![cout];
        cout++;
        sdsd.eight = tabeList![cout];
        cout++;
        sdsd.nine = tabeList![cout];
        cout++;
        tabelTen1.add(sdsd);
      }

      if (qoldiqTabel != 0) {
        TabelTen sdsd = TabelTen(
            first: null,
            zero: null,
            two: null,
            three: null,
            six: null,
            five: null,
            eight: null,
            four: null,
            nine: null,
            number: '',
            seven: null);
        switch (qoldiqTabel) {
          case 1:
            sdsd.number = (cout).toString();
            sdsd.zero = tabeList![cout];
            sdsd.first = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 1,
                tabelValue: "");
            sdsd.two = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 2,
                tabelValue: "");
            sdsd.three = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 3,
                tabelValue: "");
            sdsd.four = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 4,
                tabelValue: "");
            sdsd.five = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 5,
                tabelValue: "");
            sdsd.six = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 6,
                tabelValue: "");
            sdsd.seven = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 7,
                tabelValue: "");
            sdsd.eight = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 8,
                tabelValue: "");
            sdsd.nine = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 9,
                tabelValue: "");
            break;
          case 2:
            sdsd.number = (cout).toString();
            sdsd.zero = tabeList![cout];
            cout++;
            sdsd.first = tabeList![cout];
            sdsd.two = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 1,
                tabelValue: "");
            sdsd.three = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 2,
                tabelValue: "");
            sdsd.four = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 3,
                tabelValue: "");
            sdsd.five = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 4,
                tabelValue: "");
            sdsd.six = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 5,
                tabelValue: "");
            sdsd.seven = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 6,
                tabelValue: "");
            sdsd.eight = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 7,
                tabelValue: "");
            sdsd.nine = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 8,
                tabelValue: "");
            break;
          case 3:
            sdsd.number = (cout).toString();
            sdsd.zero = tabeList![cout];
            cout++;
            sdsd.first = tabeList![cout];
            cout++;
            sdsd.two = tabeList![cout];
            sdsd.three = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 1,
                tabelValue: "");
            sdsd.four = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 2,
                tabelValue: "");
            sdsd.five = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 3,
                tabelValue: "");
            sdsd.six = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 4,
                tabelValue: "");
            sdsd.seven = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 5,
                tabelValue: "");
            sdsd.eight = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 6,
                tabelValue: "");
            sdsd.nine = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 7,
                tabelValue: "");
            break;

          case 4:
            sdsd.number = (cout).toString();
            sdsd.zero = tabeList![cout];
            cout++;
            sdsd.first = tabeList![cout];
            cout++;
            sdsd.two = tabeList![cout];
            cout++;
            sdsd.three = tabeList![cout];

            sdsd.four = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 1,
                tabelValue: "");
            sdsd.five = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 2,
                tabelValue: "");
            sdsd.six = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 3,
                tabelValue: "");
            sdsd.seven = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 4,
                tabelValue: "");
            sdsd.eight = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 5,
                tabelValue: "");
            sdsd.nine = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 6,
                tabelValue: "");
            break;
          case 5:
            sdsd.number = (cout).toString();
            sdsd.zero = tabeList![cout];
            cout++;
            sdsd.first = tabeList![cout];
            cout++;
            sdsd.two = tabeList![cout];
            cout++;
            sdsd.three = tabeList![cout];
            cout++;
            sdsd.four = tabeList![cout];
            sdsd.five = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 1,
                tabelValue: "");
            sdsd.six = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 2,
                tabelValue: "");
            sdsd.seven = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 3,
                tabelValue: "");
            sdsd.eight = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 4,
                tabelValue: "");
            sdsd.nine = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 5,
                tabelValue: "");
            break;
          case 6:
            sdsd.number = (cout).toString();
            sdsd.zero = tabeList![cout];
            cout++;
            sdsd.first = tabeList![cout];
            cout++;
            sdsd.two = tabeList![cout];
            cout++;
            sdsd.three = tabeList![cout];
            cout++;
            sdsd.four = tabeList![cout];
            cout++;
            sdsd.five = tabeList![cout];
            sdsd.six = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 1,
                tabelValue: "");
            sdsd.seven = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 2,
                tabelValue: "");
            sdsd.eight = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 3,
                tabelValue: "");
            sdsd.nine = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 4,
                tabelValue: "");

            break;
          case 7:
            sdsd.number = (cout).toString();
            sdsd.zero = tabeList![cout];
            cout++;
            sdsd.first = tabeList![cout];
            cout++;
            sdsd.two = tabeList![cout];
            cout++;
            sdsd.three = tabeList![cout];
            cout++;
            sdsd.four = tabeList![cout];
            cout++;
            sdsd.five = tabeList![cout];
            cout++;
            sdsd.six = tabeList![cout];
            sdsd.seven = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 1,
                tabelValue: "");
            sdsd.eight = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 2,
                tabelValue: "");
            sdsd.nine = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 3,
                tabelValue: "");
            break;
          case 8:
            sdsd.number = (cout).toString();
            sdsd.zero = tabeList![cout];
            cout++;
            sdsd.first = tabeList![cout];
            cout++;
            sdsd.two = tabeList![cout];
            cout++;
            sdsd.three = tabeList![cout];
            cout++;
            sdsd.four = tabeList![cout];
            cout++;
            sdsd.five = tabeList![cout];
            cout++;
            sdsd.six = tabeList![cout];
            cout++;
            sdsd.seven = tabeList![cout];
            sdsd.eight = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 1,
                tabelValue: "");
            sdsd.nine = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 2,
                tabelValue: "");
            break;
          case 9:
            sdsd.number = (cout).toString();
            sdsd.zero = tabeList![cout];
            cout++;
            sdsd.first = tabeList![cout];
            cout++;
            sdsd.two = tabeList![cout];
            cout++;
            sdsd.three = tabeList![cout];
            cout++;
            sdsd.four = tabeList![cout];
            cout++;
            sdsd.five = tabeList![cout];
            cout++;
            sdsd.six = tabeList![cout];
            cout++;
            sdsd.seven = tabeList![cout];
            cout++;
            sdsd.eight = tabeList![cout];
            sdsd.nine = Tabel(
                sensorName: tabeList![cout].sensorName,
                tabelNumber: tabeList![cout].tabelNumber + 1,
                tabelValue: "");
            break;
        }
        tabelTen1.add(sdsd);
      }
      tabelTen = tabelTen1;
    } catch (e) {
      print("sdsd" + e.toString());
    }
  }

  Widget buildDataTable() {
    final columns = ['Q/N', '0', '1', '2', '3', '4', "5", "6", "7", "8", "9"];

    return DataTable(
      showBottomBorder: true,
      dividerThickness: 2.0,
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(tabelTen!),
      headingRowColor: MaterialStateColor.resolveWith((states) => active),
      headingTextStyle: TextStyle(fontSize: 22),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            numeric: false,
            label: Center(
              child: Text(
                column,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ))
      .toList();

  List<DataRow> getRows(List<TabelTen> tabelten) =>
      tabelten.map((TabelTen tabelten) {
        final cells = [
          tabelten.number,
          tabelten.zero,
          tabelten.first,
          tabelten.two,
          tabelten.three,
          tabelten.four,
          tabelten.five,
          tabelten.six,
          tabelten.seven,
          tabelten.eight,
          tabelten.nine,
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) => cells
      .map((data) => DataCell(
              Container(
                width: editTabel ? 65 : 90,
                child: newSavebtn && (data is Tabel)
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              data.tabelValue = value;
                            });
                          },
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : CustomText(
                        text: (data is Tabel) ? data.tabelValue : data,
                        size: 20,
                        weight: FontWeight.bold,
                      ),
              ),
              showEditIcon: editTabel, onTap: () {
            if (data is Tabel && editTabel) {
              chanageData(data);
            }
          }))
      .toList();

  void chanageData(Tabel data) async {
    try {
      final data1 = await showTextDialog(context, tabel: data);
      if (data1 != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString("token");
        var respons = await networkHandler
            .updateTabelById("/api/tabel/updateTabel", token!, {
          "sensorName": data.sensorName,
          "tabelNumber": data.tabelNumber.toString(),
          "tabelValue": data1
        });

        setState(() {
          for (var item in tabeList!) {
            if (item == data) {
              item.tabelValue = data1;
            }
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void makeTabel() {
    if (lenthtable.text != "") {
      int a = int.parse(lenthtable.text.toString());
      List<Tabel> newtabel = [];
      for (var i = 0; i <= a; i++) {
        Tabel df = Tabel(sensorName: sensorId!, tabelNumber: i, tabelValue: "");
        newtabel.add(df);
      }

      setState(() {
        newTabel = false;
        lasttabeList = tabeList;
        tabeList = newtabel;
        cratebtnCount = 2;
        newSavebtn = !newSavebtn;

        printTabelList();
        tebelBool = false;
      });
    }
  }

  void saveData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      var respons = await networkHandler
          .deleteTabelById("/api/tabel/deleteAllTabelBySensorName", token!, {
        "sensorName": sensorId!,
      });

      if (respons.statusCode == 200) {
        print(respons.body);
        bool asd = false;
        for (int i = 0; i < tabeList!.length; i++) {
          var respons1 = await networkHandler
              .saveTabelById("/api/tabel/createTabel", token, {
            "sensorName": tabeList![i].sensorName,
            "tabelNumber": (tabeList![i].tabelNumber).toString(),
            "tabelValue": tabeList![i].tabelValue
          });
          print(respons1.body);
          asd = true;
        }
        if (asd) {
          setState(() {
            printTabelList();
            editBtn = !editBtn;
            crateClose = !crateClose;
            cratebtnCount = 0;
            tileString = !tileString;
            newSavebtn = !newSavebtn;
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
