import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:uberdriver/controller/provider/authProvider/auth_provider.dart';
import 'package:uberdriver/controller/services/authServices/mobile_auth_services.dart';
import 'package:uberdriver/utils/colors.dart';
import 'package:uberdriver/utils/text_styles.dart';

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  String selectedCountry = '+55';
  TextEditingController mobileController = TextEditingController();
  bool receiveOTPButtonPressed = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        receiveOTPButtonPressed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        children: [
          SizedBox(
            height: 3.h,
          ),
          Text(
            'Enter your mobile number',
            style: AppTextStyles.body16,
          ),
          SizedBox(
            height: 3.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode:
                        true, // optional. Shows phone code before the country name.
                    onSelect: (Country country) {
                      setState(() {
                        selectedCountry = '+${country.phoneCode}';
                      });
                    },
                  );
                },
                child: Container(
                  height: 6.h,
                  width: 25.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.sp),
                      color: greyShade3),
                  child: Text(
                    selectedCountry,
                    style: AppTextStyles.body14,
                  ),
                ),
              ),
              SizedBox(
                width: 65.w,
                child: TextField(
                  controller: mobileController,
                  cursorColor: black,
                  style: AppTextStyles.textFieldHintTextStyle,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 2.w),
                    hintText: 'Mobile number',
                    hintStyle: AppTextStyles.textFieldHintTextStyle,
                    filled: true,
                    fillColor: greyShade3,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: black,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: grey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: grey,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                receiveOTPButtonPressed = true;
              });
              context.read<MobileAuthProvider>().updateMobileNumber(
                  '$selectedCountry${mobileController.text.trim()}');
              MobileAuthServices.receiveOTP(
                context: context,
                mobileNo: '$selectedCountry${mobileController.text.trim()}',
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: black, minimumSize: Size(90.w, 6.h)),
            child: receiveOTPButtonPressed
                ? CircularProgressIndicator(
                    color: white,
                  )
                : Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Next',
                          style: AppTextStyles.body16.copyWith(color: white),
                        ),
                      ),
                      Positioned(
                        right: 5.w,
                        child: Icon(
                          Icons.arrow_forward,
                          color: white,
                          size: 4.h,
                        ),
                      )
                    ],
                  ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            'By proceeding, you consent to get calls, Whatsapp or sms messages, including by automated means, from uber and its affiliates to the number provided.',
            style: AppTextStyles.small12.copyWith(
              color: grey,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: grey,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Text(
                  'or',
                  style: AppTextStyles.small12.copyWith(
                    color: grey,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: grey,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: black,
              minimumSize: Size(
                90.w,
                6.h,
              ),
            ),
            onPressed: () {},
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Continue with Google',
                    style: AppTextStyles.body16.copyWith(color: white),
                  ),
                ),
                Positioned(
                    left: 2.w,
                    child: FaIcon(
                      FontAwesomeIcons.google,
                      color: white,
                      size: 3.h,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
