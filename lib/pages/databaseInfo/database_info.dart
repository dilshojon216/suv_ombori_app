import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/controllers.dart';
import '../../constants/style.dart';
import '../../helpers/reponsiveness.dart';
import '../../models/average_week.dart';
import '../../models/data_model.dart';
import '../../models/data_model2.dart';
import '../../models/lade_model.dart';
import '../../routing/routes.dart';
import '../../services/NetworkHandler.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/message_print.dart';
import '../../widgets/scrollable_widget.dart';

class DatabaseInfoPage extends StatefulWidget {
  const DatabaseInfoPage({Key? key}) : super(key: key);

  @override
  _DatabaseInfoPageState createState() => _DatabaseInfoPageState();
}

class _DatabaseInfoPageState extends State<DatabaseInfoPage> {
  bool cicle = true;
  bool cicle1 = true;
  bool cicle2 = true;
  bool cicle3 = true;
  int? sortColumnIndex;
  bool isAscending = false;
  NetworkHandler networkHandler = NetworkHandler();
  List<LadeModel> sensorNameList = [];
  List<bool> sesnorInt = [];
  List<DataModel>? dayDataModel;
  List<DataModel2>? dayDataModel2;
  List<AverageWeek>? averageWeekList;
  int lastIndex = 0;
  List<String> typeList = [
    "Kunlik",
    "10 kunlik",
    "Oylik",
  ];
  String? queryType;
  String? todayString;
  String sensorId = "TSO00001";
  num allVolue = 0.0;
  List<bool> typebool = [
    true,
    false,
    false,
  ];
  int lasttype = 0;
  @override
  void initState() {
    super.initState();
    getLadeList();
    getToyda();
    queryType = typeList[0];
    getDayData("TSO00001", todayString!);
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void getLadeList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token")!;
      var respons =
          await networkHandler.getAllSensor("/api/sensor/getAllSensor", token);
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
          Obx(() => Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(
                          top:
                              ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                      child: CustomText(
                        text: menuController.activeItem.value,
                        size: 24,
                        weight: FontWeight.bold,
                      )),
                ],
              )),
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  height: 50,
                  child: cicle
                      ? Center(
                          child: Container(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator()))
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
                                  sensorId = sensorNameList[index].sensorId;
                                  getDayData(sensorNameList[index].sensorId,
                                      todayString!);
                                  typebool = [true, false, false, false, false];
                                  lasttype = 0;
                                  queryType = typeList[0];
                                });
                              },
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(
                                    left: 40, right: 40, top: 10, bottom: 10),
                                margin: EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color:
                                      sesnorInt[index] ? active : Colors.white,
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
                Container(
                  margin: EdgeInsets.all(20),
                  height: 50,
                  child: cicle
                      ? Center(
                          child: Container(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator()))
                      : ListView.builder(
                          itemCount: typeList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  typebool[index] = true;
                                  typebool[lasttype] = false;
                                  lasttype = index;
                                  queryType = typeList[index];

                                  if (index == 1) {
                                    getTenDataById(sensorId);
                                  } else if (index == 2) {
                                    getMothById(sensorId);
                                  }
                                });
                              },
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    left: 40, right: 40, top: 10, bottom: 10),
                                margin: EdgeInsets.only(right: 20),
                                decoration: new BoxDecoration(
                                  color:
                                      typebool[index] ? active : Colors.white,
                                  border: Border.all(
                                      color: !typebool[index]
                                          ? active
                                          : Colors.white,
                                      width: 0.0),
                                ),
                                child: CustomText(
                                  text: typeList[index],
                                  color:
                                      !typebool[index] ? active : Colors.white,
                                  size: 20,
                                  weight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                ),
                Container(
                  height: 50,
                  color: active,
                  margin: EdgeInsets.only(
                      left: ResponsiveWidget.isSmallScreen(context) ? 5 : 30,
                      right: ResponsiveWidget.isSmallScreen(context) ? 5 : 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomText(
                          text: "Bugungi sana: " + todayString!,
                          color: Colors.white,
                          weight: FontWeight.bold,
                          size:
                              ResponsiveWidget.isSmallScreen(context) ? 14 : 20,
                        ),
                      ),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1991),
                                          lastDate: DateTime(2030))
                                      .then((value) {
                                    setState(() {
                                      todayString = DateFormat('yyyy/MM/dd')
                                          .format(value!);
                                      getDayData(sensorId, todayString!);
                                    });
                                  });
                                },
                                child: Icon(
                                  Icons.calendar_today_sharp,
                                  color: Colors.white,
                                  size: ResponsiveWidget.isSmallScreen(context)
                                      ? 20
                                      : 40,
                                )),
                          ),
                          Visibility(
                            visible: !ResponsiveWidget.isSmallScreen(context),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.save,
                                    color: Colors.white,
                                    size: 40,
                                  )),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
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
                    padding: const EdgeInsets.all(16),
                    margin: EdgeInsets.only(
                        bottom: 30,
                        left: ResponsiveWidget.isSmallScreen(context) ? 5 : 30,
                        right:
                            ResponsiveWidget.isSmallScreen(context) ? 5 : 30),
                    child: cicle1
                        ? Center(
                            child: Container(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator()))
                        : ScrollableWidget(child: buildDataTable())),
                Container(
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
                  padding: const EdgeInsets.all(16),
                  margin: EdgeInsets.only(
                      bottom: 30,
                      left: ResponsiveWidget.isSmallScreen(context) ? 5 : 30,
                      right: ResponsiveWidget.isSmallScreen(context) ? 5 : 30),
                  child: Center(
                    child: CustomText(
                      color: active,
                      weight: FontWeight.bold,
                      text: "Jami suv hajm: ${allVolue.toStringAsFixed(3)} m3",
                      size: ResponsiveWidget.isSmallScreen(context) ? 14 : 20,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  getToyda() {
    DateTime now = DateTime.now();
    String todayString1 = DateFormat('yyyy/MM/dd').format(now);
    setState(() {
      todayString = todayString1;
    });
  }

  void getMothById(String id) async {
    try {
      setState(() {
        cicle1 = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token")!;
      var respons = await networkHandler
          .getDataTodayID("/api/data/getMothData", token, {"sensorName": id});

      if (respons.statusCode == 200 || respons.statusCode == 201) {
        var resjson = json.decode(respons.body);

        if (resjson is List) {
          setState(() {
            if (resjson.length > 0) {
              var onlinedata1 =
                  resjson.map((json) => AverageWeek.fromJson(json)).toList();
              averageWeekList = onlinedata1;
              allVolue = 0.0;
              for (var item in averageWeekList!) {
                allVolue += item.avgValuing / 1000;
              }
              print(resjson.toString());
            } else {
              averageWeekList = [];
            }
            cicle1 = false;
          });
        }
      } else {
        String output = json.decode(respons.body)["msg"];
        if (output == "Authentication not  valid.") {
          Get.offAllNamed(authenticationPageRoute);
        }

        pintMessage(output, context, Colors.red);
      }
    } catch (e) {
      print("sss" + e.toString());
    }
  }

  void getTenDataById(String id) async {
    try {
      setState(() {
        cicle1 = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      var respons = await networkHandler.getDataTodayID(
          "/api/data/getTenDayData", token!, {"sensorName": id});

      if (respons.statusCode == 200 || respons.statusCode == 201) {
        var resjson = json.decode(respons.body);

        if (resjson is List) {
          setState(() {
            if (resjson.length > 0) {
              var onlinedata1 =
                  resjson.map((json) => AverageWeek.fromJson(json)).toList();
              averageWeekList = onlinedata1;
              allVolue = 0.0;
              for (var item in averageWeekList!) {
                allVolue += item.avgValuing / 1000;
              }

              print(resjson.toString());
            } else {
              averageWeekList = [];
            }
            cicle1 = false;
          });
        }
      } else {
        String output = json.decode(respons.body)["msg"];
        if (output == "Authentication not  valid.") {
          Get.offAllNamed(authenticationPageRoute);
        }

        pintMessage(output, context, Colors.red);
      }
    } catch (e) {
      print("sss" + e.toString());
    }
  }

  void getDayData(String sennsor, String day) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      var respons = await networkHandler.ddd(
          "/api/data/getDataByDayAndSensorName",
          token!,
          {"day": day, "sensorName": sennsor});
      if (respons.statusCode == 200 || respons.statusCode == 201) {
        var resjson = json.decode(respons.body);
        if (resjson is List) {
          setState(() {
            var onlinedata1;

            onlinedata1 =
                resjson.map((json) => DataModel.fromJson(json)).toList();

            dayDataModel = onlinedata1;
            dayDataModel2 = [];
            allVolue = 0.0;
            for (var item in dayDataModel!) {
              allVolue += item.sensorVolume / 1000;
              dayDataModel2!.add(DataModel2(
                  sensorVolume: item.sensorVolume,
                  sensorDistance: item.sensorDistance,
                  sensorName: item.sensorName,
                  sensorSpending: item.sensorSpending,
                  sensorTime: item.sensorTime));
            }

            List<DataModel2> as = dayDataModel2!.reversed.toList();
            dayDataModel2 = [];
            dayDataModel2 = as;
            cicle1 = false;
          });
        }
      } else {
        String output = json.decode(respons.body)["msg"];
        if (output == "Authentication not  valid.") {
          Get.offAllNamed(authenticationPageRoute);
        }

        pintMessage(output, context, Colors.red);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget buildDataTable() {
    final columns = [
      'Vaqt:',
      'Suv o`rtacha suv sathi(mm):',
      'Suv  o`rtacha suv sarfi(l/s):',
      'Bir soatdagi suv hajmi(m3):',
    ];

    final columns1 = [
      "Kun:",
      "Suv sarfi(l/s):",
      "Suv hajmi (m3):",
      "Eng katta hajmi(m3):",
      "Eng kichik hajmi(m3):"
    ];

    return DataTable(
      showBottomBorder: true,
      dividerThickness: 2.0,
      sortAscending: isAscending,
      columns:
          queryType == typeList[0] ? getColumns(columns) : getColumns(columns1),
      rows: queryType == typeList[0]
          ? getRows(dayDataModel2!)
          : getRows1(averageWeekList!),
      headingTextStyle: const TextStyle(fontSize: 22),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: CustomText(
              text: column,
              size: 16,
              color: active,
            ),
          ))
      .toList();

  List<DataRow> getRows(List<DataModel2> users) => users.map((DataModel2 user) {
        final cells = [
          user.sensorTime,
          user.sensorDistance,
          user.sensorSpending.toStringAsFixed(3),
          (user.sensorVolume / 1000).toStringAsFixed(3)
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) => cells
      .map((data) => DataCell(Container(
          width: queryType == typeList[0] ? 200 : 100,
          child: CustomText(
            text: '$data',
            size: 18,
          ))))
      .toList();

  List<DataRow> getRows1(List<AverageWeek> users) =>
      users.map((AverageWeek averageWeek) {
        final cells = [
          averageWeek.id.sensorTimeDay.toString(),
          averageWeek.avgSpeding.toStringAsFixed(2),
          (averageWeek.avgValuing / 1000).toStringAsFixed(2),
          (averageWeek.maxValuing / 1000).toStringAsFixed(2),
          (averageWeek.minValuing / 1000).toStringAsFixed(2)
        ];

        return DataRow(cells: getCells(cells));
      }).toList();
}
