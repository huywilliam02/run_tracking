import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tracker_run/app/modules/login/model/login_model.dart';
import 'package:tracker_run/app/modules/sign-up/model/sign_up.dart';

import '../../../database/database_local.dart';

class SignUpApi {
  static Future<LoginModel?> register(SignUpModel model) async {
    LoginModel loginModel = LoginModel();
    var response = await http.post(
        Uri.parse('https://api-datly.phamthanhnam.com/api/auth/login'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body: jsonEncode(model.toJson()));
    print(response.statusCode);
    print(response.body);
    print(response);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      await DatabaseLocal.instance.setJwtToken(data["access_token"]);
      loginModel = LoginModel.fromJson(data['user']);

      return Future<LoginModel>.value(loginModel);
    } else {
      // return null;

      throw Exception(jsonDecode(response.body)['code'].toString());
    }
    //   Map data =jsonDecode(response.body);
    //  LoginModel rs= LoginModel.fromJson(data["data"]);
    //  print(rs.accessToken);
    // Map data = jsonDecode(response.body);
    // return Future<LoginModel>.value(LoginModel.fromJson(data["data"]));
    // }
  }
}
