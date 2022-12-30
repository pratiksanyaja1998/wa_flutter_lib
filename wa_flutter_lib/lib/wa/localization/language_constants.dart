import 'package:flutter/material.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';

//languages code
const String english = 'en';
const String hindi = 'hi';
const String gujrati = 'ml';

Future<Locale> setLocale(String languageCode) async {
  await SharedPreference.setLocale(languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  String languageCode = SharedPreference.getLocale();
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case english:
      return const Locale(english, 'US');
    case gujrati:
      return const Locale(gujrati, "IN");
    case hindi:
      return const Locale(hindi, "IN");
    default:
      return const Locale(english, 'US');
  }
}

String getTranslated(BuildContext context, var key) {
  return DemoLocalization.of(context)!.translate(key);
}