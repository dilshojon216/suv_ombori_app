import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constants/style.dart';
import '../../../models/data_model.dart';
import '../../../models/online_model.dart';
import '../../../routing/routes.dart';
import '../../../services/NetworkHandler.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/message_print.dart';

class OverviewCardsLargeScreen extends StatefulWidget {
  @override
  _OverviewCardsLargeScreenState createState() =>
      _OverviewCardsLargeScreenState();
}

class _OverviewCardsLargeScreenState extends State<OverviewCardsLargeScreen> {
  NetworkHandler networkHandler = NetworkHandler();
  List<OnlineModel>? onlineData;
  List<DataModel>? todayDataModel;
  List<ChartSampleData>? todayValueChart;

  List<ChartSampleData> sensorToday1 = [];
  List<ChartSampleData> sensorToday2 = [];
  List<ChartSampleData> sensorToday3 = [];
  List<ChartSampleData> sensorToday4 = [];
  List<ChartSampleData> sensorToday5 = [];
  List<ChartSampleData> sensorToday6 = [];
  double? maxSpedingToday = 0;
  double? minSpedingToday = 0;
  bool isCardView = false;
  bool sss = true;
  bool sss1 = true;
  bool noDataBool = false;

  Timer? timer;
  Timer? timer1;

  @override
  void initState() {
    super.initState();
    getOnlineData();
    getTodayData();
    timer = Timer.periodic(
        const Duration(seconds: 20), (Timer t) => getOnlineData());
    timer1 = Timer.periodic(
        const Duration(seconds: 600), (Timer t) => getTodayData());
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void getTodayData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      var respons =
          await networkHandler.gatOnline("/api/data/getAllDataToday", token!);

      if (respons.statusCode == 200 || respons.statusCode == 201) {
        var resjson = json.decode(respons.body);
        if (resjson is List) {
          setState(() {
            var onlinedata1 =
                resjson.map((json) => DataModel.fromJson(json)).toList();
            todayDataModel = onlinedata1;
            sss1 = false;
          });
          for (var item in todayDataModel!) {
            var sd =
                double.parse((item.sensorVolume / 1000).toStringAsFixed(2));
            if (sd > maxSpedingToday!) {
              maxSpedingToday = sd;
            }
          }
          minSpedingToday = maxSpedingToday;

          for (var item in todayDataModel!) {
            var sd =
                double.parse((item.sensorVolume / 1000).toStringAsFixed(2));
            if (sd < minSpedingToday!) {
              minSpedingToday = sd;
            }
          }

          sensorToday1 = [];
          sensorToday2 = [];
          sensorToday3 = [];
          sensorToday4 = [];
          sensorToday5 = [];
          sensorToday6 = [];

          for (var item in todayDataModel!) {
            switch (item.sensorName) {
              case "TSO00001":
                sensorToday1.add(ChartSampleData(
                    x: item.sensorTime,
                    value: double.parse(
                        (item.sensorVolume / 1000).toStringAsFixed(2))));
                break;
              case "TSO00002":
                sensorToday2.add(ChartSampleData(
                    x: item.sensorTime,
                    value: double.parse(
                        (item.sensorVolume / 1000).toStringAsFixed(2))));

                break;
              case "TSO00003":
                sensorToday3.add(ChartSampleData(
                    x: item.sensorTime,
                    value: double.parse(
                        (item.sensorVolume / 1000).toStringAsFixed(2))));
                break;
              case "TSO00004":
                sensorToday4.add(ChartSampleData(
                    x: item.sensorTime,
                    value: double.parse(
                        (item.sensorVolume / 1000).toStringAsFixed(2))));
                break;

              case "TSO00005":
                sensorToday5.add(ChartSampleData(
                    x: item.sensorTime,
                    value: double.parse(
                        (item.sensorVolume / 1000).toStringAsFixed(2))));
                break;

              case "TSO00006":
                sensorToday6.add(ChartSampleData(
                    x: item.sensorTime,
                    value: double.parse(
                        (item.sensorVolume / 1000).toStringAsFixed(2))));
                break;
            }
          }
          sensorToday1.sort((a, b) => a.x!.compareTo(b.x!));
          sensorToday2.sort((a, b) => a.x!.compareTo(b.x!));
          sensorToday3.sort((a, b) => a.x!.compareTo(b.x!));
          sensorToday4.sort((a, b) => a.x!.compareTo(b.x!));
          sensorToday5.sort((a, b) => a.x!.compareTo(b.x!));
          sensorToday6.sort((a, b) => a.x!.compareTo(b.x!));
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void getOnlineData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      var respons =
          await networkHandler.gatOnline("/api/online/getonline", token!);

      setState(() {
        if (respons.statusCode == 200 || respons.statusCode == 201) {
          var resjson = json.decode(respons.body);

          if (resjson is List) {
            var onlinedata1 =
                resjson.map((json) => OnlineModel.fromJson(json)).toList();
            onlineData = onlinedata1;
            sss = false;
          }
        } else {
          String output = json.decode(respons.body)["msg"];
          if (output == "Authentication not  valid.") {
            Get.offAllNamed(authenticationPageRoute);
          }

          pintMessage(output, context, Colors.red);
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    Widget sensorInfo(int index) {
      return Expanded(
          child: Container(
        height: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 6),
                color: lightGrey.withOpacity(.1),
                blurRadius: 12)
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Container(
                  color: !getCompData(index) ? active : noData,
                  height: 5,
                ))
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomText(
                  text: onlineData![index].sensorName,
                  size: 20,
                  weight: FontWeight.bold,
                  color: active,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CustomText(
                        text: "Suv sathi:",
                        size: 16,
                        weight: FontWeight.bold,
                        color: active,
                      ),
                      CustomText(
                        text: onlineData![index].sensorDistance + " mm",
                        size: 24,
                        weight: FontWeight.bold,
                        color: active,
                      ),
                    ],
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Column(
                    children: [
                      const CustomText(
                        text: "Suv sarfi:",
                        size: 16,
                        weight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      CustomText(
                        text: onlineData![index].sensorSpending.toString() +
                            " l/s",
                        size: 24,
                        weight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  flex: 1,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                          text: "O'lchash vaqti:",
                          size: 14,
                          weight: FontWeight.bold,
                          color: active,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                          text: timeS(onlineData![index].sensorTime),
                          size: 12,
                          weight: FontWeight.bold,
                          color: active,
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            )
          ],
        ),
      ));
    }

    return Column(
      children: [
        sss
            ? Center(
                child: Container(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              ))
            : Container(
                child: Row(
                  children: [
                    sensorInfo(0),
                    SizedBox(
                      width: _width / 64,
                    ),
                    sensorInfo(1),
                    SizedBox(
                      width: _width / 64,
                    ),
                    sensorInfo(2),
                    SizedBox(
                      width: _width / 64,
                    ),
                    sensorInfo(3),
                  ],
                ),
              ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            sss ? CircularProgressIndicator() : sensorInfo(4),
            SizedBox(
              width: _width / 64,
            ),
            sss ? CircularProgressIndicator() : sensorInfo(5),
            SizedBox(
              width: _width / 64,
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomText(
              text: "Kunlik ma'lumotlar ",
              color: Colors.black,
              weight: FontWeight.bold,
              size: 25,
            ),
          ),
        ),
        Container(
          height: 500,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 6),
                  color: lightGrey.withOpacity(.1),
                  blurRadius: 12)
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: sss1
              ? Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomText(
                          text: "Kun davomidagi oqib chiqan suv hajmi:",
                          color: Colors.black,
                          weight: FontWeight.bold,
                          size: 25,
                        ),
                      ),
                    ),
                    titleInfo(),
                    senInfo(0, "TSO00001"),
                    senInfo(1, "TSO00002"),
                    senInfo(2, "TSO00003"),
                    senInfo(3, "TSO00004"),
                    senInfo(4, "TSO00005"),
                    senInfo(5, "TSO00006"),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomText(
                          text: "Jami suv hajmi: " + getAllSensor() + " m3",
                          color: active,
                          weight: FontWeight.bold,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          height: 500,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 6),
                  color: lightGrey.withOpacity(.1),
                  blurRadius: 12)
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: sss1
                    ? Container(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator())
                    : Container(
                        padding: EdgeInsets.all(5),
                        child: SfCartesianChart(
                          plotAreaBorderWidth: 0,
                          title: ChartTitle(
                              text: isCardView
                                  ? ''
                                  : 'Bugungi har soatdagi o`rtacha suv hajmi:'),
                          legend: Legend(isVisible: !isCardView),
                          primaryXAxis: CategoryAxis(
                              majorGridLines: const MajorGridLines(width: 0),
                              labelPlacement: LabelPlacement.onTicks),
                          primaryYAxis: NumericAxis(
                              minimum: minSpedingToday,
                              maximum: maxSpedingToday! + 5,
                              axisLine: const AxisLine(width: 0),
                              edgeLabelPlacement: EdgeLabelPlacement.shift,
                              labelFormat: '{value} m3',
                              majorTickLines: const MajorTickLines(size: 0)),
                          series: _getDefaultSplineSeriesToday(),
                          tooltipBehavior: TooltipBehavior(enable: true),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<SplineSeries<ChartSampleData, String>> _getDefaultSplineSeriesToday() {
    return <SplineSeries<ChartSampleData, String>>[
      SplineSeries<ChartSampleData, String>(
        dataSource: sensorToday1,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.value,
        markerSettings: const MarkerSettings(isVisible: true),
        name: onlineData![0].sensorName,
      ),
      SplineSeries<ChartSampleData, String>(
        dataSource: sensorToday2,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.value,
        markerSettings: const MarkerSettings(isVisible: true),
        name: onlineData![1].sensorName,
      ),
      SplineSeries<ChartSampleData, String>(
        dataSource: sensorToday3,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.value,
        markerSettings: const MarkerSettings(isVisible: true),
        name: onlineData![2].sensorName,
      ),
      SplineSeries<ChartSampleData, String>(
        dataSource: sensorToday4,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.value,
        markerSettings: const MarkerSettings(isVisible: true),
        name: onlineData![3].sensorName,
      ),
      SplineSeries<ChartSampleData, String>(
        dataSource: sensorToday5,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.value,
        markerSettings: const MarkerSettings(isVisible: true),
        name: onlineData![4].sensorName,
      ),
      SplineSeries<ChartSampleData, String>(
        dataSource: sensorToday6,
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.value,
        markerSettings: const MarkerSettings(isVisible: true),
        name: onlineData![5].sensorName,
      ),
    ];
  }

  Widget titleInfo() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                child: CustomText(
                  text: "Qurilma Nomi:",
                  size: 20,
                  weight: FontWeight.bold,
                  color: active,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                child: CustomText(
                  text: "O'rtacha suv hajmi (m3):",
                  size: 20,
                  weight: FontWeight.bold,
                  color: active,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                child: CustomText(
                  text: "Eng katta suv hajmi (m3):",
                  size: 20,
                  weight: FontWeight.bold,
                  color: active,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 10, top: 10),
                child: CustomText(
                  text: "Eng kichik suv hajmi (m3):",
                  size: 20,
                  weight: FontWeight.bold,
                  color: active,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget senInfo(int index, String sensorID) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                child: CustomText(
                  text: onlineData![index].sensorName,
                  size: 20,
                  weight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                child: CustomText(
                  text: getAllVolue(sensorID),
                  size: 20,
                  weight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                child: CustomText(
                  text: getMaxVolue(sensorID),
                  size: 20,
                  weight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 10, top: 10),
                child: CustomText(
                  text: getMinVolue(sensorID),
                  size: 20,
                  weight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getAllVolue(String sensorId) {
    double value = 0;
    for (var item in todayDataModel!) {
      if (sensorId == item.sensorName) {
        value += item.sensorVolume;
      }
    }
    return (value / 1000).toStringAsFixed(2);
  }

  String getMinVolue(String sensorId) {
    double max = 0;
    for (var item in todayDataModel!) {
      if (sensorId == item.sensorName) {
        max += item.sensorVolume;
      }
    }
    num value = max;
    for (var item in todayDataModel!) {
      if (sensorId == item.sensorName) {
        if (value > item.sensorVolume) {
          value = item.sensorVolume;
        }
      }
    }
    return (value / 1000).toStringAsFixed(2);
  }

  String getMaxVolue(String sensorId) {
    num value = 0;
    for (var item in todayDataModel!) {
      if (sensorId == item.sensorName) {
        if (value < item.sensorVolume) {
          value = item.sensorVolume;
        }
      }
    }
    return (value / 1000).toStringAsFixed(2);
  }

  String getAllSensor() {
    num value = 0;
    for (var item in todayDataModel!) {
      value += item.sensorVolume;
    }
    return (value / 1000).toStringAsFixed(2);
  }

  bool getCompData(int index) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('HH:mm').format(now);
    var data = onlineData![index].sensorTime;
    print(data + " " + formattedDate);
    if (data == formattedDate) {
      return false;
    } else {
      return true;
    }
  }

  String timeS(String time) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('HH:mm').format(now);
    if (formattedDate.substring(0, 2) == time.substring(0, 2)) {
      return time;
    } else {
      return "Noso'zlik mavjud";
    }
  }
}

class ChartSampleData {
  ChartSampleData({
    this.x,
    this.value,
  });

  double? value;
  String? x;
}
