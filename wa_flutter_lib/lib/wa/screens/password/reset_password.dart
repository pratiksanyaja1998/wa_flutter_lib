
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key, required this.userName}) : super(key: key);

  final String userName;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  static final _resetPasswordFormKey = GlobalKey<FormState>();

  bool showProgress = false;
  bool isMerchant = false;

  TextEditingController otpController1 = TextEditingController();
  TextEditingController otpController2 = TextEditingController();
  TextEditingController otpController3 = TextEditingController();
  TextEditingController otpController4 = TextEditingController();
  TextEditingController otpController5 = TextEditingController();
  TextEditingController otpController6 = TextEditingController();

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool showNewPassword = false;

  late Timer _timer;
  int _start = 120;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                themeColor,
                Colors.white,
              ]
          )
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Reset Your Password"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: Center(
                  child: Form(
                    key: _resetPasswordFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Widgets().appLogo(height: 90, width: 90, radius: 10),
                          const SizedBox(height: 50,),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Widgets().otpField(context: context, first: true, last: false, otpController: otpController1),
                                Widgets().otpField(context: context, first: false, last: false, otpController: otpController2),
                                Widgets().otpField(context: context, first: false, last: false, otpController: otpController3),
                                Widgets().otpField(context: context, first: false, last: false, otpController: otpController4),
                                Widgets().otpField(context: context, first: false, last: false, otpController: otpController5),
                                Widgets().otpField(context: context, first: false, last: true, otpController: otpController6),
                              ],
                            ),
                          ),
                          const SizedBox(height: 35,),
                          Widgets().textFormField(
                            controller: newPasswordController,
                            labelText: getTranslated(context, ["changePasswordScreen", "placeholder", "newPassword"]),
                            validator: (val) {
                              if(val!.length < 6){
                                return "";
                              }else{
                                return null;
                              }
                            },
                            suffixIcon: Icons.remove_red_eye,
                            obscureText: !showNewPassword,
                            onPressedSuffixIcon: (){
                              setState(() {});
                              showNewPassword = !showNewPassword;
                            },
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 15,),
                          Widgets().textFormField(
                            controller: confirmPasswordController,
                            labelText: getTranslated(context, ["changePasswordScreen", "placeholder", "confirmPassword"]),
                            validator: (val) {
                              if(val!.length < 6){
                                return "";
                              }else{
                                return null;
                              }
                            },
                            obscureText: true,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              const Text("Merchant?"),
                              Checkbox(
                                value: isMerchant,
                                fillColor: MaterialStateProperty.all(themeColor),
                                onChanged: (value){
                                  isMerchant = !isMerchant;
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Widgets().textButton(
                                  onPressed: ()async{
                                    if(_resetPasswordFormKey.currentState!.validate()) {
                                      if(newPasswordController.text.length < 6){
                                        CommonFunctions().showAlertDialog(
                                          alertMessage: getTranslated(context, ["changePasswordScreen", "alert", "newPasswordLength"]), context: context,
                                        );
                                      }else if(confirmPasswordController.text.length < 6){
                                        CommonFunctions().showAlertDialog(
                                          alertMessage: getTranslated(context, ["changePasswordScreen", "alert", "confirmPasswordLength"]), context: context,
                                        );
                                      }else if(newPasswordController.text != confirmPasswordController.text){
                                        CommonFunctions().showAlertDialog(
                                          alertMessage: getTranslated(context, ["changePasswordScreen", "alert", "notMatch"]), context: context,
                                        );
                                      }else {
                                        String otp = otpController1.text +
                                            otpController2.text +
                                            otpController3.text +
                                            otpController4.text +
                                            otpController5.text +
                                            otpController6.text;

                                        printMessage("--- $otp ---");

                                        showProgress = true;
                                        setState(() {});

                                        var response = await UserServices().resetPassword(
                                          isMerchant: isMerchant,
                                          newPassword: newPasswordController.text,
                                          confirmPassword: confirmPasswordController.text,
                                          userName: widget.userName,
                                          otp: otp,
                                        );
                                        if(!mounted) return;
                                        if(response.statusCode == 200){
                                          Navigator.pop(context);
                                          CommonFunctions().showAlertDialog(alertMessage: "Your password has been reset", context: context);
                                        }else{
                                          var data = jsonDecode(response.body);
                                          CommonFunctions().showError(data: data, context: context);
                                        }

                                        showProgress = false;
                                        setState(() {});

                                      }
                                    }else{
                                      printMessage("otp could not be empty");
                                      CommonFunctions().showAlertDialog(
                                        alertMessage: "Please enter a valid OTP",
                                        context: context,
                                      );
                                    }
                                  },
                                  text: "Reset Password",
                                  fontSize: 24,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: kIsWeb ? 12 : 8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25,),
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Text(getTranslated(context, ["loginScreen", "or"]),),
                              const SizedBox(width: 10,),
                              const Expanded(
                                child: Divider(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            children: [
                              Expanded(
                                child: Widgets().textButton(
                                  onPressed: ()async{
                                    if(_start == 0){
                                      var response = await UserServices().resendVerificationOtp(userName: widget.userName);
                                      if(!mounted) return;
                                      if(response.statusCode == 200){
                                        CommonFunctions().showAlertDialog(
                                          alertMessage: '''OTP email sent to your 
                                          ${SharedPreference.getBusinessConfig()!.authenticationType == "phone-and-email" ||
                                              SharedPreference.getBusinessConfig()!.authenticationType.isEmpty ?
                                          "mail and phone" : SharedPreference.getBusinessConfig()!.authenticationType == "phone" ?
                                          "phone": "mail"}''',
                                          context: context,
                                        );
                                        _start = 120;
                                        setState(() {});
                                        printMessage("---");
                                        startTimer();
                                      }else{
                                        var data = jsonDecode(response.body);
                                        CommonFunctions().showError(data: data, context: context);
                                      }
                                    }else{

                                    }
                                  },
                                  text: _start == 0 ? "Resend OTP" : "${((_start/60).floor()).toString()} : ${_start%60}",
                                  fontSize: 24,
                                  backgroundColor: _start == 0 ? themeColor : secondaryColor,
                                  overlayColor: _start == 0 ? Colors.black.withOpacity(0.1) : Colors.transparent,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: kIsWeb ? 12 : 8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if(showProgress)
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: themeColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
