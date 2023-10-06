import 'dart:async';

import 'package:booking_transition_flutter/core/component/snackbar.dart';
import 'package:booking_transition_flutter/core/utils/colors.dart';
import 'package:booking_transition_flutter/feature/controller/sign_up_controller.dart';
import 'package:booking_transition_flutter/feature/models/account_information.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Authentication/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateRegister();
  }
}

class StateRegister extends State<Register> {
  static late bool isVerified;
  Timer? timer;
  Future checkVerifiedEmail() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final _fullnameEditingController = TextEditingController();
    final _phoneNumsEditingController = TextEditingController();
    final _usernameEditingController = TextEditingController();
    final _passwordEditingController = TextEditingController();
    final _verifyEditingController = TextEditingController();
    final _signUpController = SignUpController();
    final _appSnackbar = AppSnackbar();

    return SafeArea(
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                color: AppColor.mainColor,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Sign up, now',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontFamily: 'Roboto bold'),
                          ),
                          const Text(
                            'Register with us, and unlock unlimited possibilities.',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Image(
                          image: AssetImage(
                            'assets/images/sign_up_banner.jpg',
                          ),
                          width: 220,
                          height: 130,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _fullnameEditingController,
                        decoration: InputDecoration(
                          hintText: 'Enter your full name',
                          hintStyle: TextStyle(color: AppColor.mainColor),
                          //icon: const Icon(Icons.account_circle_outlined),
                          label: Text(
                            'Full name',
                            style: TextStyle(color: AppColor.mainColor),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            // Change the default border color
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: AppColor.mainColor,
                                width: 2), // Change color and width
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.phone,
                        controller: _phoneNumsEditingController,
                        decoration: InputDecoration(
                          hintText: 'Enter your phone numbers',
                          hintStyle: TextStyle(color: AppColor.mainColor),
                          //icon: const Icon(Icons.account_circle_outlined),
                          label: Text(
                            'Phone numbers',
                            style: TextStyle(color: AppColor.mainColor),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            // Change the default border color
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: AppColor.mainColor,
                                width: 2), // Change color and width
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _usernameEditingController,
                        decoration: InputDecoration(
                          hintText: 'Enter your username',
                          hintStyle: TextStyle(color: AppColor.mainColor),
                          //icon: const Icon(Icons.account_circle_outlined),
                          label: Text(
                            'Username',
                            style: TextStyle(color: AppColor.mainColor),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            // Change the default border color
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: AppColor.mainColor,
                                width: 2), // Change color and width
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _passwordEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: AppColor.mainColor),
                          //icon: const Icon(Icons.account_circle_outlined),
                          label: Text(
                            'Password',
                            style: TextStyle(color: AppColor.mainColor),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            // Change the default border color
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: AppColor.mainColor,
                                width: 2), // Change color and width
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _verifyEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Enter your password again',
                          hintStyle: TextStyle(color: AppColor.mainColor),
                          //icon: const Icon(Icons.account_circle_outlined),
                          label: Text(
                            'Verify password',
                            style: TextStyle(color: AppColor.mainColor),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            // Change the default border color
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: AppColor.mainColor,
                                width: 2), // Change color and width
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.mainColor,
                                foregroundColor: Colors.white),
                            onPressed: () async {
                              String pass = _passwordEditingController.text;
                              String verifyPass = _verifyEditingController.text;

                              if (_fullnameEditingController.text.isEmpty) {
                                _appSnackbar.buildSnackbar(
                                    context,
                                    "Please, Fill in full name field!",
                                    Colors.white,
                                    Colors.red);
                                return;
                              }

                              if (_phoneNumsEditingController.text.isEmpty) {
                                _appSnackbar.buildSnackbar(
                                    context,
                                    "Please, Fill in phone field!",
                                    Colors.white,
                                    Colors.red);
                                return;
                              }

                              if (_usernameEditingController.text.isEmpty) {
                                _appSnackbar.buildSnackbar(
                                    context,
                                    "Please, Fill in username field!",
                                    Colors.white,
                                    Colors.red);
                                return;
                              }

                              if (_passwordEditingController.text.isEmpty) {
                                _appSnackbar.buildSnackbar(
                                    context,
                                    "Please, Fill in password field!",
                                    Colors.white,
                                    Colors.red);
                                return;
                              }

                              if (_verifyEditingController.text.isEmpty) {
                                _appSnackbar.buildSnackbar(
                                    context,
                                    "Please, Fill in verify field!",
                                    Colors.white,
                                    Colors.red);
                                return;
                              }

                              if (pass == verifyPass) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.mainColor,
                                        ),
                                      );
                                    });

                                // await _signUpController.onRegister(
                                //     _fullnameEditingController.text,
                                //     _phoneNumsEditingController.text,
                                //     _usernameEditingController.text.trim(),
                                //     _passwordEditingController.text.trim(),
                                //     context);

                                String uid =
                                    await _signUpController.onCreateAccount(
                                        _usernameEditingController.text.trim(),
                                        _passwordEditingController.text.trim(),
                                        context);
                                Navigator.of(context).pop();

                                if (uid != '') {
                                  AccountInformation accountInformation =
                                      AccountInformation(
                                          fullName:
                                              _fullnameEditingController.text,
                                          gender: 'Unknow',
                                          mail: _usernameEditingController.text
                                              .trim(),
                                          phoneNumbers:
                                              _phoneNumsEditingController.text,
                                          avatarUrl: 'Unknow');

                                  Get.to(VerifyEmail(
                                    accountInformation: accountInformation,
                                    uid: uid,
                                  ));
                                  //   // isVerified = FirebaseAuth
                                  //   //     .instance.currentUser!.emailVerified;

                                  //   // if (!isVerified) {
                                  //   //   await FirebaseAuth.instance.currentUser
                                  //   //       ?.sendEmailVerification();

                                  //   //   timer = Timer.periodic(
                                  //   //       const Duration(minutes: 2), (_) {
                                  //   //     checkVerifiedEmail();
                                  //   //   });
                                  //   // } else {
                                  //   //   AccountInformation newAcc =
                                  //   //       AccountInformation(
                                  //   //           fullName:
                                  //   //               _fullnameEditingController.text,
                                  //   //           gender: 'Unknow',
                                  //   //           mail: _usernameEditingController
                                  //   //               .text
                                  //   //               .trim(),
                                  //   //           phoneNumbers:
                                  //   //               _phoneNumsEditingController
                                  //   //                   .text,
                                  //   //           avatarUrl: 'Unknow');

                                  //   //   await _signUpController.onCreateInfoAccount(
                                  //   //       newAcc, uid, context);
                                  //   // }
                                }

                                // isVerified = FirebaseAuth
                                //     .instance.currentUser!.emailVerified;
                              } else {
                                print('verify fail');
                              }
                            },
                            child: const Text(
                              'Sign up',
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
