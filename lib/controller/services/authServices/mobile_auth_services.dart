// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:uberdriver/constants/constant.dart';
import 'package:uberdriver/controller/provider/authProvider/auth_provider.dart';
import 'package:uberdriver/controller/services/profileServices/profile_services.dart';
import 'package:uberdriver/view/authScreens/mobile_login_screen.dart';
import 'package:uberdriver/view/authScreens/otp_screen.dart';
import 'package:uberdriver/view/bottomNavigatorBar/bottom_navigator_bar.dart';
import 'package:uberdriver/view/driverRegistrationScreen/driver_registration_screen.dart';
import 'package:uberdriver/view/signInLogicScreen/sign_in_logic_screen.dart';

class MobileAuthServices {
  static checkAuthentication(BuildContext context) {
    User? user = auth.currentUser;
    if (user == null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileLoginScreen()),
          (route) => false);
      return false;
    }
    checkUserRegistration(context: context);
  }

  static receiveOTP(
      {required BuildContext context, required String mobileNo}) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: mobileNo,
        verificationCompleted: (PhoneAuthCredential credentials) {
          log(credentials.toString());
        },
        verificationFailed: (FirebaseAuthException exception) {
          log(exception.toString());
          throw Exception(exception);
        },
        codeSent: (String verificationID, int? resendToken) {
          context
              .read<MobileAuthProvider>()
              .updateVerificationID(verificationID);
          Navigator.push(
            context,
            PageTransition(
              child: const OTPScreen(),
              type: PageTransitionType.rightToLeft,
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationID) {},
      );
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static verifyOTP({required BuildContext context, required String otp}) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: context.read<MobileAuthProvider>().verificationID!,
        smsCode: otp,
      );
      await auth.signInWithCredential(credential);
      Navigator.push(
        context,
        PageTransition(
          child: const SignInLogicScreen(),
          type: PageTransitionType.rightToLeft,
        ),
      );
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static checkUserRegistration({required BuildContext context}) async {
    try {
      bool userIsRegistered = await ProfileServices.checkForRegistration();

      if (userIsRegistered) {
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              child: const BottomNavigationBarDriverEats(),
              type: PageTransitionType.rightToLeft),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              child: const DriverRegistrationScreen(),
              type: PageTransitionType.rightToLeft),
          (route) => false,
        );
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
