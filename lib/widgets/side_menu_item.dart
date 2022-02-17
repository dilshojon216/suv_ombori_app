import 'package:flutter/material.dart';
import 'package:suv_ombori_app/widgets/vertical_menu_item.dart';

import '../helpers/reponsiveness.dart';
import 'horizontal_menu_item.dart';

class SideMenuItem extends StatelessWidget {
  final String? itemName;
  final Function()? onTap;

  const SideMenuItem({Key? key, this.itemName, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ResponsiveWidget.isCustomSize(context)) {
      return VertticalMenuItem(
        itemName: itemName!,
        onTap: onTap!,
      );
    } else {
      return HorizontalMenuItem(
        itemName: itemName,
        onTap: onTap,
      );
    }
  }
}
