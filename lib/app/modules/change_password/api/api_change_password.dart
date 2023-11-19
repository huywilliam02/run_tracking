import 'dart:convert';
import 'dart:developer' as dev;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../login/controllers/login_controller.dart';

class ChangePassWordApi {
  Future<String> updatePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    Map body = {
      "current_password": oldPassword,
      "new_password": newPassword,
      "confirm_password": confirmPassword
    };
    var response = await http.post(
        Uri.parse("https://tracking.irace.vn/api/v1/app/users/change-password"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization':
              'Bearer ${Get.find<LoginController>().jwtToken}'
        },
        body: jsonEncode(body));
    dev.log("ChangePassWordApi - updatePassword: ${response.statusCode}");
    if (response.statusCode == 200) {
      return "Success";
    } else {
       throw Exception(jsonDecode(response.body)['code'].toString());
    }
  }
}
