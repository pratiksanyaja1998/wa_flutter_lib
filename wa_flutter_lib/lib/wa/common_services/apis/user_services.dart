
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wa_flutter_lib/wa_flutter_lib.dart';

class UserServices{

  // static const String _baseUrl = "https://api.whitelabelapp.in";
  static final String _baseUrl = baseUrl;

  static String get getBaseUrl => _baseUrl;

  static dynamic kAuthenticatedPostRequestHeader = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Token ${SharedPreference.getUser()!.token}"
  };

  static dynamic kAuthenticatedGetRequestHeader = {
    "Accept": "application/json",
    "Authorization": "Token ${SharedPreference.getUser()!.token}"
  };

  Future<http.Response> crateFcmToken()async{

    Uri url = Uri.parse("$_baseUrl/user/fcm/token/create");

    final body = jsonEncode({
      "token": fcmToken,
      "type": "fcm",
      "token_from": "client",
    });


    printMessage(body);

    http.Response response = await http.Client().post(
        url,
        body: body,
        headers: kAuthenticatedPostRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("CREATE FCM TOKEN RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("CREATE FCM TOKEN RESPONSE = ${response.statusCode}");
      printMessage("CREATE FCM TOKEN RESPONSE = ${response.body}");
      return response;
    }

  }

  Future<http.Response> registerUser({
    required String email,
    required String phone,
    required String password,
    required String firstName,
    required String lastName,
  })async{

    Uri url = Uri.parse("$_baseUrl/user/register");

    final body = jsonEncode({
      "email": email,
      "phone": phone,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
      "business": SharedPreference.getBusinessConfig()!.businessId,
    });

    printMessage(body);

    http.Response response = await http.Client().post(
        url,
        body: body,
        headers: kPostRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("REGISTER USER RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("REGISTER USER RESPONSE = ${response.statusCode}");
      printMessage("REGISTER USER RESPONSE = ${response.body}");
      return response;
    }

  }

  Future<http.Response> resendVerificationOtp({
    required String userName,
  })async{

    Uri url = Uri.parse("$_baseUrl/user/resend-verification-otp");

    final body = jsonEncode({
      "username": userName,
      "business": SharedPreference.getBusinessConfig()!.businessId,
    });

    printMessage(body);

    http.Response response = await http.Client().post(
        url,
        body: body,
        headers: kPostRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("RESEND VERIFICATION OTP RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("RESEND VERIFICATION OTP RESPONSE = ${response.statusCode}");
      printMessage("RESEND VERIFICATION OTP RESPONSE = ${response.body}");
      return response;
    }

  }

  Future<http.Response> verifyOtp({
    required String otp,
    required int userId,
  })async{

    Uri url = Uri.parse("$_baseUrl/user/verify-otp");

    final body = jsonEncode({
      "otp": otp,
      "user": userId,
    });

    printMessage(body);

    http.Response response = await http.Client().post(
        url,
        body: body,
        headers: kPostRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("VERIFY OTP RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("VERIFY OTP RESPONSE = ${response.statusCode}");
      printMessage("VERIFY OTP RESPONSE = ${response.body}");
      return response;
    }

  }

  Future<http.Response> userLogin({
    required String password,
    required String userName,
  })async{

    Uri url = Uri.parse("$_baseUrl/user/login");

    final body = jsonEncode({
      "password": password,
      "username": userName,
      "business": SharedPreference.getBusinessConfig()!.businessId,
    });

    printMessage(body);

    http.Response response = await http.Client().post(
        url,
        body: body,
        headers: kPostRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("USEr LOGIN RESPONSE = ${response.body}");
      UserModel userModel = UserModel.fromJson(jsonDecode(response.body));
      SharedPreference.setUser(userModel: userModel);
      kAuthenticatedPostRequestHeader = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Token ${SharedPreference.getUser()!.token}"
      };

      kAuthenticatedGetRequestHeader = {
        "Accept": "application/json",
        "Authorization": "Token ${SharedPreference.getUser()!.token}"
      };
      return response;
    }else{
      printMessage("USER LOGIN RESPONSE = ${response.statusCode}");
      printMessage("USER LOGIN RESPONSE = ${response.body}");
      return response;
    }

  }

  Future<http.Response> getUserProfile()async{

    Uri url = Uri.parse("$_baseUrl/user/profile");

    http.Response response = await http.Client().get(
      url,
      headers: kAuthenticatedGetRequestHeader,
    );

    if(response.statusCode == 200){
      printMessage("GET USER PROFILE RESPONSE = ${response.body}");
      UserModel userModel = UserModel.fromJson(jsonDecode(response.body));
      SharedPreference.setUser(userModel: userModel);
      kAuthenticatedPostRequestHeader = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Token ${SharedPreference.getUser()!.token}"
      };
      kAuthenticatedGetRequestHeader = {
        "Accept": "application/json",
        "Authorization": "Token ${SharedPreference.getUser()!.token}"
      };
      return response;
    }else{
      printMessage("GET USER PROFILE RESPONSE = ${response.statusCode}");
      printMessage("GET USER PROFILE RESPONSE = ${response.body}");
      return response;
    }

  }

  Future<http.Response> updateUserProfile({
    String? firstName,
    String? lastName,
    var photo,
  })async{
    Uri url = Uri.parse("$_baseUrl/user/update/profile/${SharedPreference.getUser()!.id}");

    var request = http.MultipartRequest("PUT", url);
    request.headers.addAll(kAuthenticatedPostRequestHeader);
    if(photo!=null){
      request.files.add(await http.MultipartFile.fromPath("photo", photo.path));
    }else{
      request.fields["photo"] = "";
    }
    if(firstName != null){
      request.fields["first_name"] = firstName;
    }
    if(lastName != null){
      request.fields["last_name"] = lastName;
    }
    var response = await request.send();
    var streamResponse = await http.Response.fromStream(response);
    final responseData = json.decode(streamResponse.body);
    if (response.statusCode == 200) {
      printMessage("UPDATE USER PROFILE RESPONSE = $responseData");
      return streamResponse;
    } else {
      printMessage("UPDATE USER PROFILE RESPONSE = ${response.statusCode}");
      printMessage("UPDATE USER PROFILE RESPONSE = $responseData");
      printMessage("ERROR");
      return streamResponse;
    }
  }

  Future<http.Response> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  })async{
    Uri url = Uri.parse("$_baseUrl/user/change-password");

    final body = jsonEncode({
      "old_password": oldPassword,
      "new_password": newPassword,
      "confirm_password": confirmPassword,
    });

    http.Response response = await http.Client().put(
        url,
        body: body,
        headers: kAuthenticatedPostRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("CHANGE PASSWORD RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("CHANGE PASSWORD RESPONSE = ${response.statusCode}");
      printMessage("CHANGE PASSWORD RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> resetPassword({
    bool isMerchant = false,
    required String newPassword,
    required String confirmPassword,
    required String userName,
    required String otp,
  })async{
    Uri url;
    if(isMerchant){
      url = Uri.parse("$_baseUrl/user/merchant/reset-password/");
    }else{
      url = Uri.parse("$_baseUrl/user/reset-password/");
    }

    final body = jsonEncode({
      "new_password": newPassword,
      "confirm_password": confirmPassword,
      "otp": otp,
      "username": userName,
      "business": SharedPreference.getBusinessConfig()!.businessId,
    });

    http.Response response = await http.Client().post(
        url,
        body: body,
        headers: kPostRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("RESET PASSWORD RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("RESET PASSWORD RESPONSE = ${response.statusCode}");
      printMessage("RESET PASSWORD RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> userLogOut()async{

    Uri url = Uri.parse("$_baseUrl/user/logout");

    http.Response response = await http.Client().get(
        url,
        headers: kAuthenticatedGetRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("USER LOG OUT RESPONSE = ${response.body}");
      SharedPreference.setIsLogin(false);
      SharedPreference.setUser();
      kAuthenticatedPostRequestHeader = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Token ${SharedPreference.getUser()!.token}"
      };
      kAuthenticatedGetRequestHeader = {
        "Accept": "application/json",
        "Authorization": "Token ${SharedPreference.getUser()!.token}"
      };
      return response;
    }else{
      printMessage("USER LOG OUT RESPONSE = ${response.statusCode}");
      printMessage("USER LOG OUT RESPONSE = ${response.body}");
      return response;
    }

  }

  Future<http.Response> deleteAccount()async{

    Uri url = Uri.parse("$_baseUrl/user/delete/account/request/${SharedPreference.getUser()!.id}");

    http.Response response = await http.Client().get(
        url,
        headers: kAuthenticatedGetRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("DELETE ACCOUNT RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("DELETE ACCOUNT RESPONSE = ${response.statusCode}");
      printMessage("DELETE ACCOUNT RESPONSE = ${response.body}");
      return response;
    }
  }


  Future<http.Response> getCoinTransactions({String? searchText, String? date, String? type})async{
    Uri url = Uri.parse("$_baseUrl/coin/transactions/list?${searchText != null ? "search=$searchText" : ""}${date != null ? "&created_at=$date" : ""}${type != null ? "&type=$type" :  ""}");

    http.Response response = await http.Client().get(
        url,
        headers: kAuthenticatedGetRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("GET COIN TRANSACTION LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET COIN TRANSACTION LIST RESPONSE = ${response.statusCode}");
      printMessage("GET COIN TRANSACTION LIST RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> redeemCoins({required double coin, required String upiId})async{
    Uri url = Uri.parse("$_baseUrl/coin/redeem/create");

    final body = jsonEncode({
      "coin": coin,
      "upi_id": upiId,
    });

    http.Response response = await http.Client().post(
        url,
        body: body,
        headers: kAuthenticatedPostRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("REDEEM COINS RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("REDEEM COINS RESPONSE = ${response.statusCode}");
      printMessage("REDEEM COINS RESPONSE = ${response.body}");
      return response;
    }
  }


  Future<http.Response> userSettingUpdate({
    required int userId,
    required bool orderUpdateNotification,
    required bool promotionNotification,
  })async{
    Uri url = Uri.parse("$_baseUrl/user/setting/update/$userId");

    final body = jsonEncode({
      "order_update_notification": orderUpdateNotification,
      "promotion_notification": promotionNotification,
    });

    http.Response response = await http.Client().put(
        url,
        body: body,
        headers: kAuthenticatedPostRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("UPDATE USER SETTING RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("UPDATE USER SETTING RESPONSE = ${response.statusCode}");
      printMessage("UPDATE USER SETTING RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> deleteNotification({required int notificationId})async{
    Uri url = Uri.parse("$_baseUrl/notification/delete/$notificationId}");

    http.Response response = await http.Client().delete(
        url,
        headers: kAuthenticatedGetRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("DELETE NOTIFICATION RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("DELETE NOTIFICATION RESPONSE = ${response.statusCode}");
      return response;
    }
  }

  Future<http.Response> deleteMultipleNotification({required String notificationId})async{
    Uri url = Uri.parse("$_baseUrl/notification/delete/multiple/$notificationId}");

    http.Response response = await http.Client().delete(
        url,
        headers: kAuthenticatedGetRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("DELETE MULTIPLE NOTIFICATION RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("DELETE MULTIPLE NOTIFICATION RESPONSE = ${response.statusCode}");
      return response;
    }
  }

}