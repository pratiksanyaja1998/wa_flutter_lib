
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  static final _forgotPasswordFormKey = GlobalKey<FormState>();

  var selectedLoginType =
  SharedPreference.getBusinessConfig()!.authenticationType == "phone-and-email" ||
      SharedPreference.getBusinessConfig()!.authenticationType == "phone" ||
      SharedPreference.getBusinessConfig()!.authenticationType.isEmpty ? LoginType.phone : LoginType.email;

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  PhoneNumber? phoneNumber;

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
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Forgot Password"),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: Container(
              margin: const EdgeInsets.all(20.0),
              constraints: BoxConstraints(
                maxWidth: 370,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _forgotPasswordFormKey,
                    child: Column(
                      children: [
                        Widgets().appLogo(
                          height: 80,
                          width: 80,
                          radius: 5,
                        ),
                        const SizedBox(height: 50,),
                        if(SharedPreference.getBusinessConfig()!.authenticationType == "phone-and-email" ||
                            SharedPreference.getBusinessConfig()!.authenticationType.isEmpty)
                          Row(
                            children: [
                              LoginScreenWidgets().loginTypeButton(
                                onPressed: (){
                                  if(selectedLoginType == LoginType.email){
                                    selectedLoginType = LoginType.phone;
                                    setState(() {});
                                  }
                                },
                                selectedLoginType: selectedLoginType,
                                buttonType: LoginType.phone,
                              ),
                              const SizedBox(width: 10,),
                              LoginScreenWidgets().loginTypeButton(
                                onPressed: (){
                                  if(selectedLoginType == LoginType.phone){
                                    selectedLoginType = LoginType.email;
                                    setState(() {});
                                  }
                                },
                                selectedLoginType: selectedLoginType,
                                buttonType: LoginType.email,
                              ),
                            ],
                          ),
                        const SizedBox(height: 30,),
                        if(selectedLoginType == LoginType.phone)
                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: 370,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0,3),
                                ),
                              ],
                            ),
                            child: IntlPhoneField(
                              controller: phoneNumberController,
                              decoration: InputDecoration(
                                labelText: getTranslated(context, ["loginScreen", "placeHolder", "phone"]),
                                labelStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                suffixIcon: Icon(Icons.phone, color: themeColor,),
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                errorStyle: const TextStyle(
                                  fontSize: 0,
                                ),
                                counterText: "",
                                hintText: getTranslated(context, ["loginScreen", "placeHolder", "phone"]),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14,vertical: 16),
                                filled: true,
                                fillColor: primaryColor,
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(10),
                                  gapPadding: 0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
                                  gapPadding: 0,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
                                ),
                              ),
                              initialCountryCode: 'IN',
                              onChanged: (phone) {
                                phoneNumber = phone;
                              },
                              autovalidateMode: AutovalidateMode.disabled,
                            ),
                          ),
                        if(selectedLoginType == LoginType.email)
                          Widgets().textFormField(
                            controller: emailController,
                            labelText: getTranslated(context, ["loginScreen", "placeHolder", "email"]),
                            validator: (val) {
                              if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!)){
                                return null;
                              }else{
                                CommonFunctions().showAlertDialog(
                                  alertMessage: getTranslated(context, ["registerScreen", "validate", "email"]), context: context,
                                );
                                return "";
                              }
                            },
                            suffixIcon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        const SizedBox(height: 30,),
                        Row(
                          children: [
                            Expanded(
                              child: Widgets().textButton(
                                onPressed: ()async{
                                  bool isPhoneNumberValid = false;
                                  if(selectedLoginType == LoginType.phone){
                                    if(phoneNumber != null) {
                                      if (phoneNumber!.number.length < 10) {
                                        isPhoneNumberValid = false;
                                        printMessage("Invalid phone number");
                                      }else {
                                        isPhoneNumberValid = true;
                                      }
                                    }else{
                                      isPhoneNumberValid = false;
                                      printMessage("Invalid phone number");
                                    }
                                  }
                                  if(isPhoneNumberValid || selectedLoginType == LoginType.email){
                                    if(_forgotPasswordFormKey.currentState!.validate()){
                                      String userName = isPhoneNumberValid || selectedLoginType == LoginType.phone ?
                                      phoneNumber!.completeNumber : emailController.text;
                                      var response = await UserServices().resendVerificationOtp(
                                        userName: userName,
                                      );
                                      if(!mounted) return;
                                      if(response.statusCode == 200){
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen(userName: userName,)));
                                      }else{
                                        var data = jsonDecode(response.body);
                                        CommonFunctions().showError(data: data, context: context);

                                      }
                                    }
                                  }else{
                                    if(selectedLoginType == LoginType.phone){
                                      CommonFunctions().showAlertDialog(
                                        alertMessage: getTranslated(context, ["registerScreen", "validate", "phone"]), context: context,
                                      );
                                    }
                                  }
                                },
                                text: "Send OTP",
                                fontSize: 24,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: kIsWeb ? 12 : 8),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
