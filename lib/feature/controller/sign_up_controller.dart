import 'package:booking_transition_flutter/core/component/snackbar.dart';
import 'package:booking_transition_flutter/feature/models/account_information.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Authentication/login.dart';
import 'package:booking_transition_flutter/feature/services/insert_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:get/get.dart';

class SignUpController {
  Future onRegister(String full, String phone, String username, String pass,
      BuildContext context) async {
    final _appSnackbar = AppSnackbar();
    try {
      UserCredential newUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: username, password: pass);

      if (newUser.user?.uid != null) {
        String uid = newUser.user!.uid;
        AccountInformation newAcc = AccountInformation(
            fullName: full,
            gender: 'Unknow',
            mail: username,
            phoneNumbers: phone,
            avatarUrl: 'Unknow');

        final insertedInfo =
            await InsertDataService.insertAccountInformation(newAcc, uid);

        if (insertedInfo) {
          _appSnackbar.buildSnackbar(
              context, "Register successfully, Let\'s login now!");
          Get.back();
        } else {
          _appSnackbar.buildSnackbar(context, "Register fail");
        }
      }
    } catch (e) {
      _appSnackbar.buildSnackbar(context, e.toString());
    }
  }
}
