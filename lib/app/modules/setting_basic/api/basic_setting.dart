import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dioO;
import 'package:http_parser/http_parser.dart';
import 'package:tracker_run/app/resources/dev_utils.dart';
import '../../login/controllers/login_controller.dart';

class BasicSettingApi {
  Future<String> updateInfoBasic(
      double height, double weight, String gender) async {
    var formData = dioO.FormData.fromMap(
        {'height': height, "weight": weight, "gender": "male"});
    var a = dioO.Dio();
    a.options.headers["authorization"] =
        'Bearer ${Get.find<LoginController>().jwtToken}';
    var response = await a.post(
        "https://tracking.irace.vn/api/v1/app/users/update-profile",
        data: formData);
    DevUtils.printLog("BasicSettingApi", "updateInfoBasic", response.statusCode.toString());

    var data = response.data["message"];
    DevUtils.printLog("BasicSettingApi", "updateInfoBasic", data);
    if (data != null) {
      return Future<String>.value(data);
    } else {
      return Future<String>.value("");
    }
  }
}
