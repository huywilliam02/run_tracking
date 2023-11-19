import 'dart:convert';
import 'dart:developer' as logDev;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/database/database_local.dart';
import 'package:tracker_run/app/modules/login/controllers/login_controller.dart';
import 'package:tracker_run/app/resources/dev_utils.dart';

import '../model/login_model.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  static Future<LoginModel?> getDataCustomer(String token) async {
    var response = await http.get(
        Uri.parse('http://116.118.49.43:3000/api/auth/users'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer ${Get.find<LoginController>().jwtToken}'
        });
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      DevUtils.printLog("nameClass", "po", jsonEncode(data["data"]));
      return Future<LoginModel>.value(LoginModel.fromJson(data["data"]));
    }
    return null;
    // }
  }

  static Future<LoginModel> login(String email, String password) async {
    Map<String, String> body = {"username": email, "password": password};
    var response = await http.post(
        Uri.parse('http://116.118.49.43:3000/api/auth/login'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body: jsonEncode(body));
    DevUtils.printLog(
        "LoginApiTrackingApi", "login", DateTime.now().toString());
    logDev.log("sbc" + response.body.toString());
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      logDev.log(data["data"].toString());
      await DatabaseLocal.instance.setJwtToken(data["data"]["accesstoken"]);
      return Future<LoginModel>.value(
          LoginModel.fromJson(data["data"]["user"]));
    } else {
      throw Exception(jsonDecode(response.body)['code'].toString());
    }
  }

  static Future<bool> resetPassword(String email) async {
    var response = await http.post(
        Uri.parse("https://tracking.irace.vn/api/v1/app/auth/reset-password"),
        body: {"email": email});
    print(response.statusCode);
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(jsonDecode(response.body)['code'].toString());
    }
  }
}
