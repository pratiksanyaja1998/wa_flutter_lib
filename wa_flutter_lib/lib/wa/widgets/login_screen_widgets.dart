
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';

class LoginScreenWidgets {

  Widget loginTypeButton({
    required void Function()? onPressed,
    required var selectedLoginType,
    required var buttonType,
  }){
    return Expanded(
      child: Widgets().textButton(
        onPressed: onPressed,
        text: buttonType == LoginType.email ? "Email" : "Phone",
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(buttonType == LoginType.email ? Icons.email : Icons.phone, color: selectedLoginType == buttonType ? primaryColor : themeColor,),
            const SizedBox(width: 10,),
            Text(
              buttonType == LoginType.email ? "Email" : "Phone",
              style: TextStyle(
                color: selectedLoginType == buttonType ? primaryColor : themeColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: selectedLoginType == buttonType ? themeColor : primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: kIsWeb ? 15 : 10),
      ),
    );
  }

  Widget loginFormItem({required Widget child, double? verticalPadding}){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: verticalPadding ?? 20),
      child: Container(
        constraints: const BoxConstraints(
            maxWidth: 370
        ),
        child: child,
      ),
    );
  }

}