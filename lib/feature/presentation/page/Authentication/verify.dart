import 'dart:async';

import 'package:booking_transition_flutter/core/utils/colors.dart';
import 'package:booking_transition_flutter/feature/controller/sign_up_controller.dart';
import 'package:booking_transition_flutter/feature/models/account_information.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Account/myaccount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmail extends StatefulWidget {
  late AccountInformation accountInformation;
  late String uid;
  //late BuildContext context;

  VerifyEmail({super.key, required this.accountInformation, required this.uid});

  @override
  State<StatefulWidget> createState() {
    return StateVerifyEmail();
  }
}

class StateVerifyEmail extends State<VerifyEmail> {
  bool isVerified = false;
  Timer? timer;
  final _signUpController = SignUpController();
  @override
  void initState() {
    isVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isVerified) {
      sendVerificationEmail();
      print(isVerified);
      timer = Timer.periodic(Duration(seconds: 10), (timer) async {
        await FirebaseAuth.instance.currentUser!.reload();
        if (mounted) {
          setState(() {
            isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
            if (isVerified == true) {
              //Get.offAll(MyAccount());
              _signUpController.onCreateInfoAccount(
                  widget.accountInformation, widget.uid, context);
            }
          });
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppColor.mainColor,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Please active your\'s account by email!',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          sendVerificationEmail();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.mainColor,
                            foregroundColor: Colors.white),
                        child:
                            Text('Send again!', style: TextStyle(fontSize: 18)))
                  ],
                ))));
  }
}
