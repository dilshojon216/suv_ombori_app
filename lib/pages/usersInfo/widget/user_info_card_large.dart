import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/style.dart';
import '../../../models/users_model.dart';
import '../../../services/NetworkHandler.dart';
import '../../../widgets/custom_text.dart';

class UserInfoCardLarge extends StatefulWidget {
  final UserModel userModel;
  const UserInfoCardLarge({Key? key, required this.userModel})
      : super(key: key);

  @override
  _UserInfoCardLargeState createState() => _UserInfoCardLargeState();
}

class _UserInfoCardLargeState extends State<UserInfoCardLarge> {
  NetworkHandler networkHandler = NetworkHandler();
  final TextEditingController? nameController = TextEditingController();
  final TextEditingController? lastNameController = TextEditingController();
  final TextEditingController? usernameController = TextEditingController();
  final TextEditingController? passwordController = TextEditingController();
  final TextEditingController? phoneController = TextEditingController();
  final TextEditingController? roleController = TextEditingController();

  bool namebool = false;
  bool lastnamebool = false;
  bool usernamebool = false;
  bool passwordbool = false;
  bool phonebool = false;
  bool rolebool = false;
  bool updateBtn = false;
  int nameChangaBtn = 0;
  int lastNameChangeBtn = 0;
  int usernameChangeBtn = 0;
  int passwordChageBtn = 0;
  int roleControlerBtn = 0;
  int phoneBtn = 0;
  bool cicle = false;

  void closePhoneBtn() {
    setState(() {
      phonebool = !phonebool;
      phoneBtn = 0;
    });
  }

  void editPhoneBtn() {
    setState(() {
      phonebool = !phonebool;
      if (phoneBtn == 0) {
        phoneBtn = 1;
        phoneController!.text = widget.userModel.phone;
      } else {
        if (phoneController!.text != widget.userModel.phone &&
            phoneController!.text != "") {
          updateBtn = true;
          widget.userModel.phone = phoneController!.text;
        }
        phoneBtn = 0;
      }
    });
  }

  void closeRoleBtn() {
    setState(() {
      rolebool = !rolebool;
      roleControlerBtn = 0;
    });
  }

  void editRoleBtn() {
    setState(() {
      rolebool = !rolebool;
      if (roleControlerBtn == 0) {
        roleControlerBtn = 1;
        roleController!.text = widget.userModel.role;
      } else {
        if (roleController!.text != "" &&
            roleController!.text != widget.userModel.role) {
          updateBtn = true;
          widget.userModel.role = roleController!.text;
        }
        roleControlerBtn = 0;
      }
    });
  }

  void closePasswordBtn() {
    setState(() {
      passwordbool = !passwordbool;
      passwordChageBtn = 0;
    });
  }

  void editPasswordBtn() {
    setState(() {
      passwordbool = !passwordbool;
      if (passwordChageBtn == 0) {
        passwordChageBtn = 1;
        passwordController!.text = "";
      } else {
        passwordChageBtn = 0;
        if (passwordController!.text != "") {
          if (passwordController!.text.length < 6) {
            updateBtn = true;
            widget.userModel.password = passwordController!.text;
          } else {
            passwordChageBtn = 1;
            passwordbool = true;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.white,
              content: CustomText(
                text: "Parol 6 ta belgidan kam bo'lmasligi kerak.",
                color: Colors.red,
                size: 14,
              ),
            ));
          }
        }
      }
    });
  }

  void editUsernameBtn() {
    setState(() {
      usernamebool = !usernamebool;
      if (usernameChangeBtn == 0) {
        usernameController!.text = widget.userModel.username;
        usernameChangeBtn = 1;
      } else {
        usernameChangeBtn = 0;
        if (usernameController!.text != "" &&
            usernameController!.text != widget.userModel.username) {
          widget.userModel.username = usernameController!.text;
          updateBtn = true;
        }
      }
    });
  }

  void closeUsername() {
    setState(() {
      usernamebool = !usernamebool;
      usernameChangeBtn = 0;
    });
  }

  void closeNameBtn() {
    setState(() {
      namebool = !namebool;
      nameChangaBtn = 0;
    });
  }

  void editNameBtn() {
    setState(() {
      namebool = !namebool;
      if (nameChangaBtn == 0) {
        nameController!.text = widget.userModel.name;
        nameChangaBtn = 1;
      } else {
        nameChangaBtn = 0;
        if (nameController!.text != "" &&
            nameController!.text != widget.userModel.name) {
          widget.userModel.name = nameController!.text;
          updateBtn = true;
        }
      }
    });
  }

  void closeLastNameBtn() {
    setState(() {
      lastnamebool = !lastnamebool;
      lastNameChangeBtn = 0;
    });
  }

  void editLastNameBtn() {
    setState(() {
      lastnamebool = !lastnamebool;
      if (lastNameChangeBtn == 0) {
        lastNameController!.text = widget.userModel.lastname;
        lastNameChangeBtn = 1;
      } else {
        lastNameChangeBtn = 0;
        if (lastNameController!.text != "" &&
            lastNameController!.text != widget.userModel.lastname) {
          widget.userModel.lastname = lastNameController!.text;
          updateBtn = true;
        }
      }
    });
  }

  void updaUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      if (passwordController!.text == "") {
        widget.userModel.password = prefs.getString("password")!;
      }
      var response = await networkHandler.updateUser(
          "/api/user/updateuser", token!, widget.userModel.toJson());
      String output = json.decode(response.body)["msg"];
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          updateBtn = false;
          cicle = false;
          prefs.setString("user", json.encode(widget.userModel.toJson()));

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.white,
            content: CustomText(
              text: output,
              color: Colors.green,
              size: 14,
            ),
          ));
        });
      } else {
        cicle = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.white,
          content: CustomText(
            text: output,
            color: Colors.red,
            size: 14,
          ),
        ));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: Container(
        height: 500,
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
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(30),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
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
                      child: nameContiner(
                          widget.userModel.name,
                          nameController!,
                          namebool,
                          editNameBtn,
                          closeNameBtn,
                          true),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
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
                      child: nameContiner(
                          widget.userModel.lastname,
                          lastNameController!,
                          lastnamebool,
                          editLastNameBtn,
                          closeLastNameBtn,
                          true),
                      flex: 2,
                    ),
                  ],
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(30),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
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
                      child: nameContiner(
                          widget.userModel.username,
                          usernameController!,
                          usernamebool,
                          editUsernameBtn,
                          closeUsername,
                          true),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
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
                      child: nameContiner(
                          "*******",
                          passwordController!,
                          passwordbool,
                          editPasswordBtn,
                          closePasswordBtn,
                          true),
                      flex: 2,
                    ),
                  ],
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(30),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
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
                      child: nameContiner(
                          widget.userModel.phone,
                          phoneController!,
                          phonebool,
                          editPhoneBtn,
                          closePhoneBtn,
                          true),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
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
                      child: nameContiner(
                          widget.userModel.role,
                          roleController!,
                          rolebool,
                          editRoleBtn,
                          closeRoleBtn,
                          widget.userModel.role == "Admin"),
                      flex: 2,
                    ),
                  ],
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Visibility(
                visible: updateBtn,
                child: cicle
                    ? CircularProgressIndicator()
                    : Container(
                        margin: EdgeInsets.only(left: 30, right: 30),
                        padding: EdgeInsets.all(30),
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: active,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: active, width: .5),
                          ),
                          child: TextButton(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: CustomText(
                                text: "O'zgartirish",
                                color: Colors.white,
                              ),
                            ),
                            onPressed: updaUser,
                          ),
                        ),
                      ),
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget nameContiner(String value, TextEditingController controller,
      bool change, Function() editBtn, Function() exitbtn, bool a) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(right: 20, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: active, width: .5),
      ),
      child: Row(
        children: [
          Expanded(
              child: !change
                  ? CustomText(
                      text: value,
                      size: 20,
                      weight: FontWeight.bold,
                    )
                  : TextField(
                      controller: controller,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    )),
          Visibility(
            visible: change,
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Icon(
                  Icons.close,
                  color: Colors.red,
                ),
                onPressed: exitbtn,
              ),
            ),
          ),
          Visibility(
            visible: a,
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  child: Icon(
                    !change ? Icons.edit : Icons.check,
                    color: !change ? active : Colors.green,
                  ),
                  onPressed: editBtn),
            ),
          )
        ],
      ),
    );
  }
}
