
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wa_flutter_lib/wa_flutter_lib.dart';

class BusinessServices{

  static final String _baseUrl = UserServices.getBaseUrl;

  Future<http.Response> getAppConfig()async{

    Uri url = Uri.parse("$_baseUrl/business/app/config/$businessDomain");

    http.Response response = await http.Client().get(
        url,
        headers: kGetRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("GET APP CONFIG RESPONSE = ${response.body}");
      BusinessAppConfigModel? businessAppConfigModel = BusinessAppConfigModel.fromJson(jsonDecode(response.body)["data"]);
      SharedPreference.setBusinessConfig(businessAppConfigModel);
      return response;
    }else{
      printMessage("GET APP CONFIG RESPONSE = ${response.statusCode}");
      printMessage("GET APP CONFIG RESPONSE = ${response.body}");
      return response;
    }

  }

  Future<http.Response> getNotificationList()async{
    Uri url = Uri.parse("$_baseUrl/notification/list/${SharedPreference.getBusinessConfig()!.businessId}");

    http.Response response = await http.Client().get(
        url,
        headers: kGetRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("GET NOTIFICATION LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET NOTIFICATION LIST RESPONSE = ${response.statusCode}");
      return response;
    }
  }

  Future<http.Response> getPromotionList()async{
    Uri url = Uri.parse("$_baseUrl/promotion/list/${SharedPreference.getBusinessConfig()!.businessId}");

    http.Response response = await http.Client().get(
        url,
        headers: kGetRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("GET PROMOTION LIST RESPONSE = ${response.statusCode}");
      printMessage("GET PROMOTION LIST RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("GET PROMOTION LIST RESPONSE = ${response.statusCode}");
      return response;
    }
  }

  Future<http.Response> getTopProductList({String? ids})async{
    Uri url = Uri.parse("$_baseUrl/products/list/${SharedPreference.getBusinessConfig()!.businessId}?ids=${ids ?? ""}");

    http.Response response = await http.Client().get(
        url,
        headers: kGetRequestHeader
    );

    if(response.statusCode == 200){
      printMessage("GET PRODUCT LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET PRODUCT LIST RESPONSE = ${response.statusCode}");
      return response;
    }
  }

}