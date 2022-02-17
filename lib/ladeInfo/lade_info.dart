import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../constants/controllers.dart';
import '../helpers/reponsiveness.dart';
import '../widgets/custom_text.dart';
import 'widget/lade_info_large.dart';
import 'widget/lade_info_medium.dart';
import 'widget/lade_info_small.dart';

class LadeInfoPage extends StatefulWidget {
  const LadeInfoPage({Key? key}) : super(key: key);

  @override
  _LadeInfoPageState createState() => _LadeInfoPageState();
}

class _LadeInfoPageState extends State<LadeInfoPage> {
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
                if (ResponsiveWidget.isLargeScreen(context) ||
                    ResponsiveWidget.isMediumScreen(context))
                  if (ResponsiveWidget.isLargeScreen(context))
                    LadeInfoLarge()
                  else
                    LadeInfoMedium()
                else
                  LadeInfoSmall()
              ],
            ),
          )
        ],
      ),
    );
  }
}
