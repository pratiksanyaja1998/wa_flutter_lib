
import 'package:flutter/material.dart';

late final dynamic homeScreen;
late final String businessDomain;
late final String baseUrl;
late final Color primaryColor;
late final Color secondaryColor;
late final Color themeColor;
late final bool isLoginRequired;
late final String fcmToken;

void initWA({
  required dynamic screen,
  required String domain,
  required String apiUrl,
  required Color theme,
  required Color primary,
  required Color secondary,
  required bool loginRequired,
  String? firebaseToken,
}){
  homeScreen = screen;
  businessDomain = domain;
  baseUrl = apiUrl;
  themeColor = theme;
  primaryColor = primary;
  secondaryColor = secondary;
  isLoginRequired = loginRequired;
  fcmToken = firebaseToken ?? "";
}