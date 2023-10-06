import 'package:booking_transition_flutter/core/component/snackbar.dart';
import 'package:booking_transition_flutter/core/utils/colors.dart';
import 'package:booking_transition_flutter/feature/controller/login_controller.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Authentication/register.dart';
import 'package:booking_transition_flutter/feature/presentation/page/Authentication/reset_pass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/colors.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateLogin();
  }
}

class StateLogin extends State<Login> {
  final _nameEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  final _loginController = LoginController();
  final _appSnackbar = AppSnackbar();

  @override
  void dispose() {
    _nameEditingController.clear();
    _passwordEditingController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String previousPage = Get.previousRoute;
    print(previousPage);
    return SafeArea(
        child: Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Container(
            width: double.infinity,
            color: AppColor.mainColor,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: AppColor.mainColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
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
                                'Welcome',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontFamily: 'Roboto bold'),
                              ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              const Text(
                                'Log in now to have better experience',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Image(
                                image: ResizeImage(
                                    AssetImage(
                                        'assets/images/banner_login.jpg'),
                                    height: 130,
                                    width: 220)))
                      ],
                    ),
                  ),
                ),
                Container(
                  //height: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _nameEditingController,
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
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(ResetPass());
                              },
                              child: Text(
                                'Forgot / Change Password?',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Roboto bold',
                                    color: AppColor.mainColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.mainColor,
                                  foregroundColor: Colors.white),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (_nameEditingController.text.isEmpty) {
                                  _appSnackbar.buildSnackbar(
                                      context,
                                      "Please, Enter your username!",
                                      Colors.white,
                                      Colors.red);
                                  return;
                                }

                                if (_passwordEditingController.text.isEmpty) {
                                  _appSnackbar.buildSnackbar(
                                      context,
                                      "Please, Enter your password!",
                                      Colors.white,
                                      Colors.red);
                                  return;
                                }
                                await _loginController.onLogin(
                                    _nameEditingController.text,
                                    _passwordEditingController.text,
                                    context);

                                _nameEditingController.clear();
                                _passwordEditingController.clear();
                              },
                              child: const Text(
                                'Log in',
                                style: TextStyle(fontSize: 20),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account?',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            TextButton(
                                onPressed: () {
                                  _loginController.onLogin(
                                      _nameEditingController.text,
                                      _passwordEditingController.text,
                                      context);
                                },
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(Register());
                                  },
                                  child: Text(
                                    'Sign up',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppColor.mainColor,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColor.mainColor),
                                  ),
                                ))
                          ],
                        ),
                        const Text(
                          'Or',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await _loginController.onLoginWithGoogle(context);
                          },
                          child: const Image(
                            image: AssetImage('assets/images/sign_in_gg.png'),
                            width: 70,
                            height: 70,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
