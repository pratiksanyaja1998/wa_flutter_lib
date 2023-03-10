
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  static final _changePasswordFormKey = GlobalKey<FormState>();

  bool showProgress = false;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool showOldPassword = false;
  bool showNewPassword = false;

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
            title: Text(getTranslated(context, ["changePasswordScreen", "title"])),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(20.0),
                  constraints: BoxConstraints(
                    maxWidth: 370,
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _changePasswordFormKey,
                      child: Column(
                        children: [
                          Widgets().appLogo(height: 80, width: 80, radius: 5),
                          const SizedBox(height: 30,),
                          Widgets().textFormField(
                            controller: oldPasswordController,
                            labelText: getTranslated(context, ["changePasswordScreen", "placeholder", "oldPassword"]),
                            validator: (val) {
                              if(val!.length < 6){
                                return "";
                              }else{
                                return null;
                              }
                            },
                            suffixIcon: Icons.remove_red_eye,
                            obscureText: !showOldPassword,
                            onPressedSuffixIcon: (){
                              showOldPassword = !showOldPassword;
                              setState(() {});
                            },
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 15,),
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
                          const SizedBox(height: 30,),
                          Row(
                            children: [
                              Expanded(
                                child: Widgets().textButton(
                                  onPressed: ()async{
                                    if(oldPasswordController.text.length < 6){
                                      CommonFunctions().showAlertDialog(
                                        alertMessage: getTranslated(context, ["changePasswordScreen", "alert", "oldPasswordLength"]), context: context,
                                      );
                                    }else if(newPasswordController.text.length < 6){
                                      CommonFunctions().showAlertDialog(
                                        alertMessage: getTranslated(context, ["changePasswordScreen", "alert", "newPasswordLength"]), context: context,
                                      );
                                    }else if(confirmPasswordController.text.length < 6){
                                      CommonFunctions().showAlertDialog(
                                        alertMessage: getTranslated(context, ["changePasswordScreen", "alert", "confirmPasswordLength"]), context: context,
                                      );
                                    }else if(newPasswordController.text != confirmPasswordController.text){
                                      CommonFunctions().showAlertDialog(alertMessage: getTranslated(context, ["changePasswordScreen", "alert", "notMatch"]), context: context);
                                    }else if(_changePasswordFormKey.currentState!.validate()){
                                      showProgress = true;
                                      setState(() {});
                                      var response = await UserServices().changePassword(
                                        oldPassword: oldPasswordController.text,
                                        newPassword: newPasswordController.text,
                                        confirmPassword: confirmPasswordController.text,
                                      );
                                      if(!mounted) return;
                                      if(response.statusCode == 200){
                                        Navigator.pop(context);
                                        CommonFunctions().showAlertDialog(
                                          alertMessage: "Your password has been changed.",
                                          context: context,
                                        );
                                      }else{
                                        var data = jsonDecode(response.body);
                                        CommonFunctions().showError(data: data, context: context);
                                      }
                                      showProgress = false;
                                      setState(() {});
                                    }
                                  },
                                  text: getTranslated(context, ["changePasswordScreen", "changePassword"]),
                                  fontSize: 24,
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
      ),
    );
  }
}
