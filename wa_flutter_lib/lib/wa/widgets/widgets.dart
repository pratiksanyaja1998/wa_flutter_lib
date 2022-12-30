
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:wa_flutter_lib/wa_flutter_lib.dart';

class Widgets {

  Widget textButton({
    required void Function()? onPressed,
    required String text,
    double? elevation,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? overlayColor,
    double? fontSize,
    TextStyle? style,
    double? borderRadius,
    Widget? child,
  }){
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor ?? themeColor),
        surfaceTintColor: MaterialStateProperty.all(primaryColor),
        foregroundColor: MaterialStateProperty.all(Colors.transparent),
        padding: MaterialStateProperty.all(
            padding ?? (kIsWeb || Platform.isWindows ? const EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 10) : const EdgeInsets.symmetric(horizontal: 20, vertical: 8))),
        elevation: MaterialStateProperty.all(elevation ?? 4),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
        ),
        overlayColor: MaterialStateProperty.all(overlayColor ?? Colors.black.withOpacity(0.04)),
      ),
      child: child ?? Text(
        text,
        style: style ?? TextStyle(
            fontSize: fontSize ?? 18,
            fontWeight: FontWeight.bold,
            color: primaryColor
        ),
      ),
    );
  }

  Widget textFormField({
    required TextEditingController controller,
    required String labelText,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    double? maxWidth,
    int? maxLines,
    bool? obscureText,
    void Function()? onPressedSuffixIcon,
    IconData? suffixIcon,
  }){
    return Container(
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
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? 370,
      ),
      child: TextFormField(
        maxLines: maxLines ?? 1,
        // textAlignVertical: TextAlignVertical.top,
        controller: controller,
        obscureText: obscureText ?? false,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
              color: Colors.grey
          ),
          alignLabelWithHint: true,
          suffixIcon: onPressedSuffixIcon != null ? IconButton(
            onPressed: onPressedSuffixIcon,
            icon: obscureText != null ? Icon(obscureText ? Icons.remove_red_eye : CupertinoIcons.eye_slash_fill, color: themeColor,) :
            Icon(suffixIcon ?? Icons.remove_red_eye, color: themeColor,),
          ) : suffixIcon != null ? Icon(suffixIcon, color: themeColor,) : null,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          errorStyle: const TextStyle(
            fontSize: 0,
          ),
          hintText: labelText,
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
        validator: validator,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontFamily: "Poppins",
        ),
      ),
    );
  }

  Widget appLogo({
    required double height,
    required double width,
    required double radius,
  }){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 6,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset("assets/images/logo.png", width: width, height: height, fit: BoxFit.cover,),
      ),
    );
  }

  Widget otpField({
    required BuildContext context,
    required bool first,
    required bool last,
    required TextEditingController otpController,
  }) {
    return Container(
      height: 55,
      width: 40,
      margin: EdgeInsets.only(left: first ? 0 :5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6
          ),
        ],
      ),
      child: TextFormField(
        controller: otpController,
        autofocus: true,
        onChanged: (value) {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && first == false) {
            FocusScope.of(context).previousFocus();
          }
        },
        validator: (value){
          if(value!.isEmpty){
            return "";
          }else{
            return null;
          }
        },
        readOnly: false,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        keyboardType: TextInputType.number,
        maxLength: 1,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          errorStyle: const TextStyle(
            fontSize: 0,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
          filled: true,
          fillColor: primaryColor,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          counter: const Offstage(),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: Colors.black.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(6)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1.5, color: Colors.black,),
              borderRadius: BorderRadius.circular(6)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1.5, color: Colors.black),
              borderRadius: BorderRadius.circular(6)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: Colors.black.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Widget settingOptionTile({
    required BuildContext context,
    required String tileText,
    void Function()? onTap,
    bool showArrowIcon = true,
    Color? tileTextColor,
  }){
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 6,
          ),
        ],
      ),
      child: Material(
        elevation: 0,
        color: Colors.transparent,
        child: ListTile(
          leading: Text(
              tileText,
              style: TextStyle(
                color: tileTextColor,
                fontSize: 13,
              )
          ),
          onTap: onTap,
          tileColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          dense: true,
          trailing: showArrowIcon ? const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 20,) : null,
        ),
      ),
    );
  }

  Widget noProfileContainer({String? name,}){
    List<Color> colors = [Colors.deepOrange, Colors.purple, Colors.indigo];
    return Container(
      decoration: BoxDecoration(
        color: colors[1],
      ),
      child: Center(child: Text(
        name ?? "",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      )),
    );
  }

  Widget networkImageContainer({String? imageUrl, double? width, double? height}){
    return Container(
      width: width ?? 55,
      height: height ?? 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height != null ? height/2 : 27.5),
        border: Border.all(color: Colors.grey),
        color: primaryColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height != null ? height/2 : 27.5),
        child: imageUrl == null ?
        Image.asset(
          "assets/images/profile.png",
          width: width ?? 55,
          height: height ?? 55,
        ) :
        imageUrl.isNotEmpty ? Image.network(
          imageUrl,
          width: width ?? 55,
          height: height ?? 55,
          loadingBuilder: (context, child, loadingProgress){
            if(loadingProgress != null){
              return Center(
                child: CircularProgressIndicator(
                  color: themeColor,
                  strokeWidth: 3,
                ),
              );
            }else{
              return child;
            }
          },
          errorBuilder: (context, obj, st){
            return Image.asset(
              "assets/images/profile.png",
              width: width ?? 55,
              height: height ?? 55,
            );
          },
        ) : Image.asset(
          "assets/images/profile.png",
          width: width ?? 55,
          height: height ?? 55,
        ),
      ),
    );
  }

}
