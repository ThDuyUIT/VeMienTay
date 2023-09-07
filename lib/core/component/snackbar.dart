import 'package:booking_transition_flutter/core/utils/colors.dart';
import 'package:flutter/material.dart';

class AppSnackbar {
  void buildSnackbar(BuildContext context, String content) {
    var snackBar = SnackBar(
        backgroundColor: AppColor.mainColor,
        content: Text(
          content,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
