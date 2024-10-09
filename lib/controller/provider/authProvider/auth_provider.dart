import 'package:flutter/material.dart';
import 'package:uberdriver/constants/constant.dart';
import 'package:uberdriver/view/signInLogicScreen/sign_in_logic_screen.dart';

class MobileAuthProvider extends ChangeNotifier {
  String? mobileNumber;
  String? verificationID;
  updateVerificationID(String verification) {
    verificationID = verification;
    notifyListeners();
  }

  updateMobileNumber(String number) {
    mobileNumber = number;
    notifyListeners();
  }

  static signOut(BuildContext context) {
    auth.signOut();
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) {
        return const SignInLogicScreen();
      }),
      (Route) => false,
    );
  }
}
