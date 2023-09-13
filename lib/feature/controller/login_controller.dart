import 'package:booking_transition_flutter/core/component/drawer/header_drawer.dart';
import 'package:booking_transition_flutter/core/component/snackbar.dart';
import 'package:booking_transition_flutter/feature/controller/account_controller.dart';
import 'package:booking_transition_flutter/feature/models/account_information.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Account/myaccount.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Search/choose_route.dart';
import 'package:booking_transition_flutter/feature/services/insert_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/utils/colors.dart';
import '../presentation/page/Tickets/myticket.dart';
import '../services/get_data_service.dart';

class LoginController {
  Future onLogin(String name, String pass, BuildContext context) async {
    final _appSnackbar = AppSnackbar();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: name, password: pass);

      //String userId = 'KH${userCredential.user!.uid}';
      String userId = userCredential.user!.uid;
      final accountoController = Get.find<AccountController>();

      final accountInformation =
          await GetDataService.fetchAccountInformation(userId);

      if (accountInformation.fullName == '') {
        _appSnackbar.buildSnackbar(
            context, 'Username or Password is incorrect');
        return;
      }

      accountoController.setAccountInfo(accountInformation);
      accountoController.setUid(userId);

      String previousPage = Get.previousRoute;

      if (previousPage == '/MyTicket') {
        _appSnackbar.buildSnackbar(context, "Login successfully!");
        Get.offAll(MyTicket());
      } else {
        print(previousPage);
        AppHeaderDrawer();

        if ((previousPage == '/Search' && ChooseRoute.routes.isEmpty) ||
            previousPage == '/Login' ||
            previousPage == '/') {
          _appSnackbar.buildSnackbar(context, "Login successfully!");
          Get.offAll(MyAccount());
        } else {
          _appSnackbar.buildSnackbar(context, "Login successfully!");
          //print('err is here');
          Get.back();
        }
      }
    } catch (e) {
      _appSnackbar.buildSnackbar(context, 'Username or Password is incorrect');
    }
  }

  Future onLoginWithGoogle(BuildContext context) async {
    final _appSnackbar = AppSnackbar();
    try {
      GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      //print(googleSignInAccount?.photoUrl);
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      //print("UID:${userCredential.user!.uid}");
      if (userCredential.user!.uid.isNotEmpty) {
        String uid = userCredential.user!.uid;

        AccountInformation accountInformation =
            await GetDataService.fetchAccountInformation(uid);

        if (accountInformation.fullName.isEmpty) {
          AccountInformation newAcc = AccountInformation(
              fullName: userCredential.user!.displayName.toString(),
              gender: 'Unknow',
              mail: userCredential.user!.email.toString(),
              phoneNumbers: 'Unknow',
              avatarUrl: googleSignInAccount.photoUrl.toString());

          final insertInfo =
              await InsertDataService.insertAccountInformation(newAcc, uid);
          if (insertInfo) {
            accountInformation =
                await GetDataService.fetchAccountInformation(uid);
          }
        }

        String previousPage = Get.previousRoute;
        final accountoController = Get.find<AccountController>();

        // final accountInformation =
        //     await GetDataService.fetchAccountInformation(uid);

        accountoController.setAccountInfo(accountInformation);
        accountoController.setUid(uid);

        if (previousPage == '/MyTicket') {
          _appSnackbar.buildSnackbar(context, "Login successfully!");
          Get.offAll(MyTicket());
        } else {
          AppHeaderDrawer();
          if ((previousPage == '/Search' && ChooseRoute.routes.isEmpty) ||
              previousPage == '/Login' ||
              previousPage == '/') {
            _appSnackbar.buildSnackbar(context, "Login successfully!");
            Get.offAll(MyAccount());
          } else {
            _appSnackbar.buildSnackbar(context, "Login successfully!");
            Get.back();
          }
        }
      }
    } catch (e) {
      _appSnackbar.buildSnackbar(context, "Can\'t login with Google!");
    }
  }
}
