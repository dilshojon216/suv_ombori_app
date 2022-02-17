import 'package:flutter/material.dart';

import 'custom_text.dart';

pintMessage(String message, BuildContext context, Color color) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.white,
    behavior: SnackBarBehavior.floating,
    content: CustomText(
      text: message,
      color: color,
      size: 14,
    ),
  ));
}
