import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suv_ombori_app/pages/usersInfo/widget/user_info_card_medium.dart';

import '../../constants/controllers.dart';
import '../../constants/style.dart';
import '../../helpers/reponsiveness.dart';
import '../../models/users_model.dart';
import '../../services/NetworkHandler.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/message_print.dart';
import '../../widgets/scrollable_widget.dart';
import 'widget/user_info_card_large.dart';
import 'widget/user_info_card_small.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  NetworkHandler networkHandler = NetworkHandler();
  UserModel? userModel;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  List<DropdownMenuItem<String>> listRole = [];
  String selected = "User";
  List<UserModel>? userList;
  int? sortColumnIndex;
  bool isAscending = false;
  bool cicl = false;
  bool circlAdd = false;
  bool addPanel = false;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  void loadData() {
    listRole = [];

    listRole.add(new DropdownMenuItem(
      child: CustomText(
        text: "User",
        size: 18,
      ),
      value: "User",
    ));

    listRole.add(new DropdownMenuItem(
      child: CustomText(
        text: "Admin",
        size: 18,
      ),
      value: "Admin",
    ));
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userModel = UserModel.fromJson(json.decode(prefs.getString("user")!));
    });

    setState(() {
      cicl = true;
    });

    String tokin = prefs.getString("token")!;
    if (tokin != "") {
      var res = await networkHandler.getAllUser("/api/user/getAllUser", tokin);
      if (res.statusCode == 200 || res.statusCode == 201) {
        var resjson = json.decode(res.body);
        if (resjson is List) {
          var users = resjson.map((json) => UserModel.fromJson(json)).toList();

          setState(() {
            loadData();
            userList = users;
            cicl = false;
          });
        }
      } else {
        cicl = false;
        String output = json.decode(res.body)["msg"];
        pintMessage(output, context, Colors.red);
      }
    }
  }

  void saveUser() async {
    if (nameController.text == "") {
      return pintMessage("Foydalanuvchi ismi kiritilmadi", context, Colors.red);
    }

    if (lastNameController.text == "") {
      return pintMessage(
          "Foydalanuvchi familiyasi kiritilmadi", context, Colors.red);
    }

    if (usernameController.text == "") {
      return pintMessage("Login kiritilmadi", context, Colors.red);
    }

    if (passwordController.text == "" || passwordController.text.length < 6) {
      return pintMessage(
          "parol kiritilmadi yoki parol belgilar soni 6 tadan kam",
          context,
          Colors.red);
    }

    if (phoneController.text == "") {
      return pintMessage("Telefon nomer kiritilmadi", context, Colors.red);
    }

    var user = UserModel(
        name: nameController.text,
        lastname: lastNameController.text,
        username: usernameController.text,
        password: passwordController.text,
        phone: phoneController.text,
        role: selected);
    try {
      circlAdd = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token")!;
      var response = await networkHandler.updateUser(
          "/api/user/register", token, user.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          userList!.add(user);
          addPanel = false;
          circlAdd = false;
          String output = json.decode(response.body)["msg"];
          pintMessage(output, context, Colors.green);
          nameController.text = "";
          lastNameController.text = "";
          usernameController.text = "";
          passwordController.text = "";
          phoneController.text = "";
        });
      } else {
        circlAdd = false;
        String output = json.decode(response.body)["msg"];
        pintMessage(output, context, Colors.red);
      }
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
                      text: menuController.activeItem.value,
                      size: 24,
                      weight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (ResponsiveWidget.isLargeScreen(context) ||
                    ResponsiveWidget.isMediumScreen(context))
                  if (ResponsiveWidget.isCustomSize(context))
                    UserInfoCardMedium(
                      userModel: userModel,
                    )
                  else
                    UserInfoCardLarge(
                      userModel: userModel!,
                    )
                else
                  UserInfoCardSmall(
                    userModel: userModel,
                  ),
                Visibility(
                    visible: userModel!.role == "Admin",
                    child: !addPanel
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10, top: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        text: "Foydalanuvchilar ma'lumotlari:",
                                        size: ResponsiveWidget.isLargeScreen(
                                                context)
                                            ? 24
                                            : 18,
                                        weight: FontWeight.bold,
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, right: 30),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            child: TextButton(
                                              child: Icon(Icons.person_add),
                                              onPressed: () {
                                                setState(() {
                                                  addPanel = true;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      flex: 1,
                                    )
                                  ],
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: active.withOpacity(.4),
                                          width: .5),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 6),
                                            color: lightGrey.withOpacity(.1),
                                            blurRadius: 12)
                                      ],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    margin: EdgeInsets.only(bottom: 30),
                                    child: cicl
                                        ? CircularProgressIndicator()
                                        : ScrollableWidget(
                                            child: buildDataTable()))
                              ],
                            ),
                          )
                        : Container(
                            height: ResponsiveWidget.isLargeScreen(context) ||
                                    ResponsiveWidget.isCustomSize(context)
                                ? 510
                                : 850,
                            margin: EdgeInsets.only(
                                left: ResponsiveWidget.isLargeScreen(context)
                                    ? 50
                                    : 5,
                                right: ResponsiveWidget.isLargeScreen(context)
                                    ? 50
                                    : 5,
                                top: 30,
                                bottom: 60),
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
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Expanded(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: CustomText(
                                              text:
                                                  "Yangi foydalanuvchi qo'shish",
                                              size: 20,
                                              weight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  addPanel = false;
                                                });
                                              },
                                              child: Icon(Icons.close)),
                                        ),
                                      )
                                    ],
                                  ),
                                  if (ResponsiveWidget.isLargeScreen(context))
                                    userAddLargeScreen()
                                  else if (ResponsiveWidget.isCustomSize(
                                          context) ||
                                      ResponsiveWidget.isMediumScreen(context))
                                    userAddMediumScreen()
                                  else
                                    userAddSmallcreen()
                                ],
                              ),
                            ),
                          ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget userAddSmallcreen() {
    return Container(
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  text: "Foydalanuvchi ismi:",
                  color: active,
                  weight: FontWeight.bold,
                  size: 18,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: active, width: .5),
              ),
              child: TextField(
                controller: nameController,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  text: "Foydalanuvchi familiyasi:",
                  color: active,
                  weight: FontWeight.bold,
                  size: 18,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: active, width: .5),
              ),
              child: TextField(
                controller: lastNameController,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  text: "Login:",
                  color: active,
                  weight: FontWeight.bold,
                  size: 18,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: active, width: .5),
              ),
              child: TextField(
                controller: usernameController,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  text: "Parol:",
                  color: active,
                  weight: FontWeight.bold,
                  size: 18,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: active, width: .5),
              ),
              child: TextField(
                controller: passwordController,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  text: "Foydalanuvchi telefon raqami:",
                  color: active,
                  weight: FontWeight.bold,
                  size: 18,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: active, width: .5),
              ),
              child: TextField(
                controller: phoneController,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  text: "Role",
                  color: active,
                  weight: FontWeight.bold,
                  size: 18,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    margin:
                        EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: active, width: .5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items: listRole,
                        isDense: true,
                        onChanged: (String? value) {
                          setState(() {
                            selected = value!;
                            print(selected);
                          });
                        },
                        value: selected,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            circlAdd
                ? CircularProgressIndicator()
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: active,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(20),
                    child: TextButton(
                      onPressed: () {
                        setState(() async {
                          saveUser();
                        });
                      },
                      child: CustomText(
                        text: "Ma'lumotlarni saqlash",
                        color: Colors.white,
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget userAddMediumScreen() {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: "Foydalanuvchi ismi:",
                        size: 16,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    margin:
                        EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: active, width: .5),
                    ),
                    child: TextField(
                      controller: nameController,
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
              flex: 1,
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: "Foydalanuvchi familiyasi:",
                        size: 16,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    margin:
                        EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: active, width: .5),
                    ),
                    child: TextField(
                      controller: lastNameController,
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
              flex: 1,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: "Login:",
                        size: 16,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    margin:
                        EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: active, width: .5),
                    ),
                    child: TextField(
                      controller: usernameController,
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
              flex: 1,
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: "Parol:",
                        size: 16,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    margin:
                        EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: active, width: .5),
                    ),
                    child: TextField(
                      controller: passwordController,
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
              flex: 1,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: "Foydalanuvchi telefon raqami::",
                        size: 16,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    margin:
                        EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: active, width: .5),
                    ),
                    child: TextField(
                      controller: phoneController,
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
              flex: 1,
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: "Role:",
                        size: 16,
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
                              right: 10, top: 5, bottom: 5, left: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: active, width: .5),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: listRole,
                              isDense: true,
                              onChanged: (String? value) {
                                setState(() {
                                  selected = value!;
                                  print(selected);
                                });
                              },
                              value: selected,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              flex: 1,
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: active,
          ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(20),
          child: TextButton(
            onPressed: () {
              setState(() async {
                saveUser();
              });
            },
            child: CustomText(
              text: "Ma'lumotlarni saqlash",
              color: Colors.white,
            ),
          ),
        )
      ],
    ));
  }

  Widget userAddLargeScreen() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 20,
                  ),
                  child: CustomText(
                    text: "Foydalanuvchi ismi:",
                    color: active,
                    weight: FontWeight.bold,
                    size: 18,
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(right: 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: active, width: .2),
                ),
                child: TextField(
                  controller: nameController,
                  style: TextStyle(fontSize: 18),
                ),
              )),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: CustomText(
                    text: "Foydalanuvchi familiyasi:",
                    color: active,
                    weight: FontWeight.bold,
                    size: 18,
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: active, width: .2),
                ),
                child: TextField(
                  controller: lastNameController,
                  style: TextStyle(fontSize: 18),
                ),
              ))
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 20,
                  ),
                  child: CustomText(
                    text: "Login:",
                    color: active,
                    weight: FontWeight.bold,
                    size: 18,
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(right: 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: active, width: .2),
                ),
                child: TextField(
                  controller: usernameController,
                  style: TextStyle(fontSize: 18),
                ),
              )),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: CustomText(
                    text: "Parol:",
                    color: active,
                    weight: FontWeight.bold,
                    size: 18,
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: active, width: .2),
                ),
                child: TextField(
                  controller: passwordController,
                  style: TextStyle(fontSize: 18),
                ),
              ))
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 20,
                  ),
                  child: CustomText(
                    text: "Foydalanuvchi telefon raqami:",
                    color: active,
                    weight: FontWeight.bold,
                    size: 18,
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(right: 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: active, width: .2),
                ),
                child: TextField(
                  controller: phoneController,
                  style: TextStyle(fontSize: 18),
                ),
              )),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: CustomText(
                    text: "Role:",
                    color: active,
                    weight: FontWeight.bold,
                    size: 18,
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(right: 20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: active, width: .2),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items: listRole,
                        isDense: true,
                        onChanged: (String? value) {
                          setState(() {
                            selected = value!;
                            print(selected);
                          });
                        },
                        value: selected,
                      ),
                    )),
                flex: 1,
              )
            ],
          ),
          circlAdd
              ? CircularProgressIndicator()
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: active,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(20),
                  child: TextButton(
                    onPressed: () {
                      setState(() async {
                        saveUser();
                      });
                    },
                    child: CustomText(
                      text: "Ma'lumotlarni saqlash",
                      color: Colors.white,
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget buildDataTable() {
    final columns = [
      'Ism',
      'Familiya',
      'Login',
      'Parol',
      'Telefon',
      'Roli',
      "O'chirish"
    ];

    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(userList!),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: CustomText(
              text: column,
              size: 18,
              color: active,
            ),
          ))
      .toList();

  List<DataRow> getRows(List<UserModel> users) => users.map((UserModel user) {
        final cells = [
          user.name,
          user.lastname,
          user.username,
          "******",
          user.phone,
          user.role,
          "delete"
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) => cells
      .map((data) => DataCell(Container(
          width: data == "delete" ? 50 : 170,
          child: data != "delete"
              ? CustomText(
                  text: '$data',
                  size: 18,
                )
              : TextButton(
                  onPressed: () {
                    setState(() async {
                      try {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String token = prefs.getString("token")!;
                        var response = await networkHandler.updateUser(
                            "/api/user/deleteuser",
                            token,
                            {"username": cells[2]});
                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          userList!.removeWhere(
                              (element) => element.username == cells[2]);
                          String output = json.decode(response.body)["msg"];
                          pintMessage(output, context, Colors.green);
                        } else {
                          String output = json.decode(response.body)["msg"];
                          pintMessage(output, context, Colors.red);
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                    });
                  },
                  child: Icon(
                    Icons.delete,
                    color: active,
                  )))))
      .toList();
}
