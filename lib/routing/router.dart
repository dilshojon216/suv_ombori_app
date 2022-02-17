import 'package:flutter/material.dart';
import 'package:suv_ombori_app/routing/routes.dart';

import '../ladeInfo/lade_info.dart';
import '../pages/databaseInfo/database_info.dart';
import '../pages/overview/overview.dart';
import '../pages/table/table_page.dart';
import '../pages/usersInfo/users_info.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case overviewPageRoute:
      return _getPageRoute(OverviewPage());
    case driversPageRoute:
      return _getPageRoute(DatabaseInfoPage());

    case clientsPageRoute:
      return _getPageRoute(TabelPage());

    case ladeInfoPageRoute:
      return _getPageRoute(LadeInfoPage());

    case userInfoPageRoute:
      return _getPageRoute(UserInfo());

    default:
      return _getPageRoute(OverviewPage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
