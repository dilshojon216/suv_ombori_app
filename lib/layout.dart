import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/local_navigator.dart';
import 'helpers/reponsiveness.dart';
import 'models/users_model.dart';
import 'services/NetworkHandler.dart';
import 'widgets/large_screen.dart';
import 'widgets/side_menu.dart';
import 'widgets/top_nav.dart';

class SiteLayout extends StatefulWidget {
  @override
  _SiteLayoutState createState() => _SiteLayoutState();
}

class _SiteLayoutState extends State<SiteLayout> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  NetworkHandler networkHandler = NetworkHandler();
  UserModel? user;

  bool circular = true;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token")!;
      var response =
          await networkHandler.getUserByToken("/api/user/getuser", token);
      setState(() {
        circular = false;
        user = UserModel.fromJson(json.decode(response.body)["data"]);
        prefs.setString("user", json.encode(user!.toJson()));
      });
      print(user.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: topNavigationBar(context,
          circular ? " " : user!.name + " " + user!.lastname, scaffoldKey),
      drawer: Drawer(
        child: SideMenu(),
      ),
      body: ResponsiveWidget(
          largeScreen: LargeScreen(),
          smallScreen: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: localNavigator(),
          )),
    );
  }
}
