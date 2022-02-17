import 'package:flutter/material.dart';

import '../constants/style.dart';
import '../helpers/reponsiveness.dart';
import 'custom_text.dart';

AppBar topNavigationBar(
        BuildContext context, String fullname, GlobalKey<ScaffoldState> key) =>
    AppBar(
      leading: !ResponsiveWidget.isSmallScreen(context)
          ? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Image.asset(
                    "assets/icons/logo.png",
                    width: 28,
                  ),
                ),
              ],
            )
          : IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                key.currentState!.openDrawer();
              }),
      title: Container(
        child: Row(
          children: [
            Visibility(
                visible: !ResponsiveWidget.isSmallScreen(context),
                child: CustomText(
                  text: ResponsiveWidget.isMediumScreen(context)
                      ? "TSO"
                      : "To'polon Suv Ombori",
                  color: lightGrey,
                  size: ResponsiveWidget.isLargeScreen(context) ? 20 : 16,
                  weight: FontWeight.bold,
                )),
            Expanded(child: Container()),
            SizedBox(
              width: 24,
            ),
            if (!ResponsiveWidget.isSmallScreen(context))
              CustomText(
                text: fullname,
                color: active,
              ),
            SizedBox(
              width: 16,
            ),
            if (!ResponsiveWidget.isSmallScreen(context))
              Container(
                decoration: BoxDecoration(
                    color: active.withOpacity(.5),
                    borderRadius: BorderRadius.circular(30)),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.all(2),
                  margin: EdgeInsets.all(2),
                  child: CircleAvatar(
                    backgroundColor: light,
                    child: Icon(
                      Icons.person,
                      color: active,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
      iconTheme: IconThemeData(color: dark),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
