
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum LoginType{
  phone,
  email,
}

class _LoginScreenState extends State<LoginScreen> {

  static final _loginFormKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  PhoneNumber? phoneNumber;

  bool showPassword = true;
  bool showProgress = false;

  var selectedLoginType =
  SharedPreference.getBusinessConfig()!.authenticationType == "phone-and-email" ||
      SharedPreference.getBusinessConfig()!.authenticationType == "phone" ||
      SharedPreference.getBusinessConfig()!.authenticationType.isEmpty ? LoginType.phone : LoginType.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 70,),
                      Widgets().appLogo(height: 80, width: 80, radius: 10),
                      const SizedBox(height: 20,),
                      if(SharedPreference.getBusinessConfig()!.authenticationType == "phone-and-email" ||
                          SharedPreference.getBusinessConfig()!.authenticationType.isEmpty)
                        LoginScreenWidgets().loginFormItem(
                          child: Row(
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
                        ),
                      if(selectedLoginType == LoginType.phone)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                          child: Container(
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
                        ),
                      if(selectedLoginType == LoginType.email)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                          child: Widgets().textFormField(
                            controller: emailController,
                            labelText: getTranslated(context, ["loginScreen", "placeHolder", "email"]),
                            suffixIcon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                        child: Widgets().textFormField(
                          controller: passwordController,
                          labelText: getTranslated(context, ["loginScreen", "placeHolder", "password"]),
                          suffixIcon: Icons.remove_red_eye,
                          obscureText: showPassword,
                          onPressedSuffixIcon: (){
                            showPassword = !showPassword;
                            setState(() {});
                          },
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      LoginScreenWidgets().loginFormItem(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Widgets().textButton(
                                    onPressed: ()async{
                                      bool isUserNameValid = false;
                                      if(selectedLoginType == LoginType.phone){
                                        if(phoneNumber != null) {
                                          if (phoneNumber!.number.length < 10) {
                                            isUserNameValid = false;
                                            printMessage("Invalid phone number");
                                            CommonFunctions().showAlertDialog(
                                              alertMessage: getTranslated(context, ["registerScreen", "validate", "phone"]), context: context,
                                            );
                                          }else {
                                            isUserNameValid = true;
                                          }
                                        }else{
                                          isUserNameValid = false;
                                          printMessage("Invalid phone number");
                                          CommonFunctions().showAlertDialog(
                                            alertMessage: getTranslated(context, ["registerScreen", "validate", "phone"]), context: context,
                                          );
                                        }
                                      }else{
                                        if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text)){
                                          isUserNameValid = true;
                                        }else{
                                          CommonFunctions().showAlertDialog(
                                            alertMessage: getTranslated(context, ["registerScreen", "validate", "email"]), context: context,
                                          );
                                          isUserNameValid = false;
                                        }
                                      }

                                      if(isUserNameValid){
                                        if(passwordController.text.length < 6){
                                          CommonFunctions().showAlertDialog(
                                            alertMessage: getTranslated(context, ["registerScreen", "validate", "password"]), context: context,
                                          );
                                        }else {
                                          showProgress = true;
                                          setState(() {});
                                          var response = await UserServices()
                                              .userLogin(
                                            password: passwordController.text,
                                            userName: selectedLoginType ==
                                                LoginType.phone
                                                ? phoneNumber!.completeNumber
                                                : emailController.text,
                                          );
                                          if (response.statusCode == 200) {
                                            var data = jsonDecode(
                                                response.body);
                                            if(!mounted) return;
                                            if (data["is_active"]) {
                                              showProgress = false;
                                              setState(() {});
                                              SharedPreference.setIsLogin(
                                                  true);
                                              if (SharedPreference
                                                  .isLogin() && !kIsWeb) {
                                                await UserServices()
                                                    .crateFcmToken();
                                              }
                                              if(!mounted) return;
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homeScreen));
                                              // Navigator.of(context).pop();
                                            } else {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OtpVerificationScreen(
                                                            userName: data["username"],
                                                            userId: data["id"],))
                                              ).then((value) async {
                                                if (value != null) {
                                                  if (value["verified"]) {
                                                    showProgress = false;
                                                    setState(() {});
                                                    // Navigator.of(context)
                                                    //     .pop();
                                                    UserModel userModel = UserModel
                                                        .fromJson(
                                                        value["data"]);
                                                    SharedPreference.setUser(
                                                        userModel: userModel);
                                                    SharedPreference
                                                        .setIsLogin(true);
                                                    if (SharedPreference
                                                        .isLogin() &&
                                                        !kIsWeb) {
                                                      await UserServices()
                                                          .crateFcmToken();
                                                    }
                                                    if(!mounted) return;
                                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homeScreen));
                                                    // Navigator.of(context).pop();
                                                  } else {
                                                    showProgress = false;
                                                    setState(() {});
                                                    // Navigator.of(context)
                                                    //     .pop();
                                                    printMessage(
                                                        "Sorry you did not verified please login and verify otp.");
                                                    CommonFunctions().showAlertDialog(
                                                      alertMessage: "Sorry you did not verified please login and verify otp.",
                                                      context: context,
                                                    );
                                                  }
                                                } else {
                                                  showProgress = false;
                                                  setState(() {});
                                                  if(!mounted) return;(
                                                      "Sorry you did not verified please login and verify otp.");
                                                  CommonFunctions().showAlertDialog(
                                                    alertMessage: "Sorry you did not verified please login and verify otp.",
                                                    context: context,
                                                  );
                                                }
                                              });
                                            }
                                          } else {
                                            var data = jsonDecode(
                                                response.body);
                                            if(!mounted) return;
                                            CommonFunctions().showError(
                                                data: data, context: context);
                                            showProgress = false;
                                            setState(() {});
                                          }
                                        }
                                      }
                                    },
                                    text: getTranslated(context, ["loginScreen", "login"]),
                                    fontSize: 24,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: kIsWeb ? 12 : 8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword()),);
                              },
                              child: Text(
                                getTranslated(context, ["loginScreen", "forgotPassword"]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      LoginScreenWidgets().loginFormItem(
                        child: Row(
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
                        verticalPadding: 0,
                      ),
                      LoginScreenWidgets().loginFormItem(
                        child: Row(
                          children: [
                            Expanded(
                              child: Widgets().textButton(
                                onPressed: ()async{
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterUserScreen()));
                                },
                                text: getTranslated(context, ["loginScreen", "register"]),
                                fontSize: 24,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: kIsWeb ? 12 : 8),
                              ),
                            ),
                          ],
                        ),
                        verticalPadding: 30
                      ),
                      const SizedBox(height: 40,),
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
    );
  }
}
