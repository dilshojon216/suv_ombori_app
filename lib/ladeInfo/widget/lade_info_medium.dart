import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/style.dart';
import '../../models/lade_model.dart';
import '../../models/users_model.dart';
import '../../services/NetworkHandler.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/message_print.dart';

class LadeInfoMedium extends StatefulWidget {
  const LadeInfoMedium({Key? key}) : super(key: key);

  @override
  _LadeInfoMediumState createState() => _LadeInfoMediumState();
}

class _LadeInfoMediumState extends State<LadeInfoMedium> {
  List<LadeModel>? sensors;
  List<bool> sensorBool = [];
  List<int> sensorInt = [];
  bool adminbool = false;
  bool cicle = true;
  NetworkHandler networkHandler = NetworkHandler();
  List<TextEditingController> sensorNameController = [];
  List<TextEditingController> sensorDistanceController = [];
  List<TextEditingController> sensorCorrectionController = [];

  List<TextEditingController> sensorLavelController = [];
  @override
  void initState() {
    super.initState();
    getLades();
  }

  void getLades() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      var userModel = UserModel.fromJson(json.decode(prefs.getString("user")!));
      var respons =
          await networkHandler.getAllSensor("/api/sensor/getAllSensor", token!);

      setState(() {
        if (userModel.role == "Admin") {
          adminbool = true;
        }
        if (respons.statusCode == 200 || respons.statusCode == 201) {
          var resjson = json.decode(respons.body);
          if (resjson is List) {
            var sensor =
                resjson.map((json) => LadeModel.fromJson(json)).toList();
            sensors = sensor;
            for (var i = 0; i < sensors!.length; i++) {
              sensorBool.add(false);
              sensorInt.add(0);

              sensorDistanceController.add(TextEditingController());
              sensorNameController.add(TextEditingController());
              sensorCorrectionController.add(TextEditingController());
              sensorLavelController.add(TextEditingController());
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
          Row(
            children: [
              Expanded(
                child: cicle ? CircularProgressIndicator() : conternerList(0),
                flex: 1,
              ),
              Expanded(
                child: cicle ? CircularProgressIndicator() : conternerList(1),
                flex: 1,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: cicle ? CircularProgressIndicator() : conternerList(2),
                flex: 1,
              ),
              Expanded(
                child: cicle ? CircularProgressIndicator() : conternerList(3),
                flex: 1,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: cicle ? CircularProgressIndicator() : conternerList(4),
                flex: 1,
              ),
              Expanded(
                child: cicle ? CircularProgressIndicator() : conternerList(5),
                flex: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget conternerList(int index) {
    return Container(
      padding: sensorInt[index] != 1 ? EdgeInsets.only(bottom: 20) : null,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 6),
              color: lightGrey.withOpacity(.1),
              blurRadius: 12)
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        child: cicle
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Visibility(
                          visible: adminbool,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        if (sensorInt[index] == 0) {
                                          sensorBool[index] = true;
                                          sensorInt[index] = 1;

                                          sensorNameController[index].text =
                                              sensors![index].sensorName;

                                          sensorDistanceController[index].text =
                                              sensors![index].sensorDistance;

                                          sensorCorrectionController[index]
                                                  .text =
                                              sensors![index].sensorCorrection;
                                          sensorLavelController[index].text =
                                              sensors![index].sensorLavel;
                                        } else {
                                          sensorBool[index] = false;
                                          sensorInt[index] = 0;
                                        }
                                      });
                                    },
                                    child: Icon(
                                      sensorInt[index] == 0
                                          ? Icons.create
                                          : Icons.close,
                                      color: sensorInt[index] == 0
                                          ? active
                                          : Colors.red,
                                    ))),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: "Qurilmaning ID si:",
                        color: Colors.black,
                        size: 18,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.only(
                              right: 20, top: 5, bottom: 5, left: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: active, width: .5),
                          ),
                          child: CustomText(
                            text: sensors![index].sensorId,
                            size: 20,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: "Qurilmaning nomi:",
                        color: Colors.black,
                        size: 18,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.only(
                              right: 20, top: 5, bottom: 5, left: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: active, width: .5),
                          ),
                          child: sensorBool[index]
                              ? Container(
                                  height: 35,
                                  child: TextField(
                                    controller: sensorNameController[index],
                                    style: TextStyle(fontSize: 20),
                                  ))
                              : CustomText(
                                  text: sensors![index].sensorName,
                                  size: 20,
                                  weight: FontWeight.bold,
                                ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: "Suv sathning qiymati (sm):",
                        color: Colors.black,
                        size: 18,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.only(
                              right: 20, top: 5, bottom: 5, left: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: active, width: .5),
                          ),
                          child: sensorBool[index]
                              ? Container(
                                  height: 35,
                                  child: TextField(
                                    controller: sensorDistanceController[index],
                                    style: TextStyle(fontSize: 20),
                                  ))
                              : CustomText(
                                  text: sensors![index].sensorDistance,
                                  size: 20,
                                  weight: FontWeight.bold,
                                ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: "Koordinata tuzatishi:",
                        color: Colors.black,
                        size: 18,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.only(
                              right: 20, top: 5, bottom: 5, left: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: active, width: .5),
                          ),
                          child: sensorBool[index]
                              ? Container(
                                  height: 35,
                                  child: TextField(
                                    controller:
                                        sensorCorrectionController[index],
                                    style: TextStyle(fontSize: 20),
                                  ))
                              : CustomText(
                                  text: sensors![index].sensorCorrection,
                                  size: 20,
                                  weight: FontWeight.bold,
                                ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: sensorBool[index],
                    child: Container(
                      margin: EdgeInsets.only(left: 30, right: 30),
                      padding: EdgeInsets.all(30),
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
                              text: "O'zgartirish",
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              updateLade(index);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void updateLade(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")!;

    if (sensorNameController[index].text != "" &&
        sensorDistanceController[index].text != "" &&
        sensorCorrectionController[index].text != "") {
      var lade = LadeModel(
        id: sensors![index].id,
        sensorId: sensors![index].sensorId,
        sensorName: sensorNameController[index].text,
        sensorDistance: sensorDistanceController[index].text,
        sensorCorrection: sensorCorrectionController[index].text,
        sensorLavel: sensorLavelController[index].text,
      );

      try {
        var res = await networkHandler.updateSensor(
            "/api/sensor/updateSensor", token, lade.toJson());

        if (res.statusCode == 200 || res.statusCode == 201) {
          setState(() {
            String output = json.decode(res.body)["msg"];
            pintMessage(output, context, Colors.green);
            sensorInt[index] = 0;
            sensorBool[index] = false;
            sensors![index].sensorName = sensorNameController[index].text;
            sensors![index].sensorDistance =
                sensorDistanceController[index].text;
            sensors![index].sensorCorrection =
                sensorCorrectionController[index].text;
            sensors![index].sensorLavel = sensorLavelController[index].text;
          });
        } else {
          String output = json.decode(res.body)["msg"];
          pintMessage(output, context, Colors.red);
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
