import 'package:booking_transition_flutter/core/utils/colors.dart';
import 'package:flutter/material.dart';

class AppSnackbar {
  void buildSnackbar(
      BuildContext context, String content, Color background, Color textColor) {
    var snackBar = SnackBar(
        backgroundColor: background,
        content: Text(
          content,
          style: TextStyle(color: textColor, fontSize: 18),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
