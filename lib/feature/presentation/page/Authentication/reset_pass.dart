import 'package:booking_transition_flutter/core/component/snackbar.dart';
import 'package:booking_transition_flutter/core/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ResetPass extends StatelessWidget {
  final _emailEditingController = TextEditingController();
  final _appSnackbar = AppSnackbar();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: AppColor.mainColor,
        title: const Text('Go back'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Enter your email and we will send you a password reset link',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _emailEditingController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: AppColor.mainColor),
                  //icon: const Icon(Icons.account_circle_outlined),
                  label: Text(
                    'Email',
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
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.mainColor,
                    foregroundColor: Colors.white),
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: _emailEditingController.text);
                    _appSnackbar.buildSnackbar(
                        context,
                        'Password reset link sent! Check your email',
                        AppColor.mainColor,
                        Colors.white);
                  } catch (e) {
                    String err = e.toString();
                    _appSnackbar.buildSnackbar(
                        context,
                        err.substring(err.indexOf(']') + 2),
                        AppColor.mainColor,
                        Colors.white);
                  }
                },
                child: const Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 18),
                ))
          ],
        ),
      ),
    ));
  }
}
