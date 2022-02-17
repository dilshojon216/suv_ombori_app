import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../constants/style.dart';
import '../../routing/routes.dart';
import '../../services/NetworkHandler.dart';
import '../../widgets/custom_text.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  @override
  Widget build(BuildContext context) {
    var _globalkey = GlobalKey<FormState>();
    NetworkHandler networkHandler = NetworkHandler();
    TextEditingController? usernameController;
    TextEditingController? passwordController;
    String? errorText;
    bool validate = false;
    bool circular = false;

    setState(() {
      usernameController = TextEditingController();
      passwordController = TextEditingController();
    });

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: BlurryContainer(
          borderRadius: BorderRadius.circular(20),
          height: 450,
          width: 350,
          bgColor: Colors.white,
          child: Form(
            key: _globalkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text("Login",
                        style: GoogleFonts.roboto(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    CustomText(
                      text: "Boshqaruv paneliga xush kelibsiz",
                      color: lightGrey,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: usernameController!,
                  decoration: InputDecoration(
                      labelText: "Username",
                      hintText: "Islom",
                      errorText: validate ? null : errorText,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "123",
                      errorText: validate ? null : errorText,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: circular
                      ? CircularProgressIndicator()
                      : InkWell(
                          onTap: () async {
                            try {
                              if (usernameController!.text != "" &&
                                  passwordController!.text != "") {
                                setState(() {
                                  circular = true;
                                });
                                Map<String, String> data = {
                                  "username": usernameController!.text,
                                  "password": passwordController!.text,
                                };
                                var response = await networkHandler.signIn(
                                    "/api/user/login", data);
                                if (response.statusCode == 200 ||
                                    response.statusCode == 201) {
                                  var output = json.decode(response.body);
                                  print(output.toString());

                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString('token', output["token"]);
                                  prefs.setString(
                                      "password", passwordController!.text);

                                  setState(() {
                                    validate = true;
                                    circular = false;
                                    Get.offAllNamed(rootRoute);
                                  });
                                } else {
                                  String output =
                                      json.decode(response.body)["msg"];
                                  print(output);
                                  setState(() {
                                    validate = false;
                                    errorText = output;
                                    circular = false;
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor: Colors.white,
                                      content: CustomText(
                                        text: output,
                                        color: Colors.red,
                                        size: 14,
                                      ),
                                    ));
                                  });
                                }
                              }
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: active,
                                borderRadius: BorderRadius.circular(20)),
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: CustomText(
                              text: "Login",
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
