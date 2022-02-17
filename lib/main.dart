import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suv_ombori_app/routing/routes.dart';

import 'constants/style.dart';
import 'controllers/menu_controller.dart';
import 'controllers/navigation_controller.dart';
import 'layout.dart';
import 'pages/404/error.dart';
import 'pages/authentication/authentication.dart';
import 'services/NetworkHandler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(MenuController());
  Get.put(NavigationController());
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool as = false;
  try {
    as = false;
    await verifiedToken(prefs);
  } catch (e) {
    print(e.toString());
  }
  if (as) {
    runApp(MyApp(
      vis: true,
    ));
  } else {
    runApp(MyApp(
      vis: false,
    ));
  }
}

class MyApp extends StatelessWidget {
  final vis;

  const MyApp({Key? key, this.vis}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: vis ? rootRoute : authenticationPageRoute,
      unknownRoute: GetPage(
          name: '/not-found',
          page: () => PageNotFound(),
          transition: Transition.fadeIn),
      getPages: [
        GetPage(
            name: rootRoute,
            page: () {
              return SiteLayout();
            }),
        GetPage(
            name: authenticationPageRoute, page: () => AuthenticationPage()),
      ],
      debugShowCheckedModeBanner: false,
      title: "To'polon Suv Ombori",
      theme: ThemeData(
        scaffoldBackgroundColor: light,
        textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.black),
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        }),
        primarySwatch: Colors.blue,
      ),
      // home: AuthenticationPage(),
    );
  }
}

Future<bool> verifiedToken(SharedPreferences prefs) async {
  try {
    NetworkHandler networkHandler = NetworkHandler();

    String token = prefs.getString("token") ?? "";
    if (token != "") {
      var res = await networkHandler.verifyUser("/api/user/verify", token);
      print(res);
      if (res.body == "true") {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    print(e.toString());
    return false;
  }
}
