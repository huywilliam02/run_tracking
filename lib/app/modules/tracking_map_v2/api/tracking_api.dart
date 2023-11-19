import 'dart:convert';

import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:tracker_run/app/modules/login/controllers/login_controller.dart';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dioO;

import '../model/data_model_strava.dart';

class TrackingApi {
  static Future<DataModelStrava?> postActivity(
      DataModelStrava data, String jwtToken) async {
    var response = await http.post(
        Uri.parse("https://tracking.irace.vn/api/v1/app/activities"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer ${jwtToken}'
        },
        body: jsonEncode(data));
    //b1// /d649ee77863e91289d2d0f1695531a5e63730821309f1
    // dev.log("TrackingApi- ${G  et.find<LoginController>().jwtToken}- postApi: ${response.statusCode}");
    if (response.statusCode == 200) {
      var dataRespone = jsonDecode(response.body);
      DataModelStrava? model;
      if (data.photos.isNotEmpty) {
        int id = dataRespone["data"]["id"];
        model = await updateAvatar(data.photos[0], id.toString());
        if (model != null) {
          return Future.value(model);
        }
      }
      model = DataModelStrava.fromJson(dataRespone["data"]);
      return Future.value(model);
    } else {
      return null;
    }
  }

  static Future<DataModelStrava?> updateAvatar(
      String imagePath, String id) async {
    var abc = await dioO.MultipartFile.fromFile(imagePath,
        contentType: MediaType("image", "png"));

    var formData = dioO.FormData.fromMap({'photos': abc});
    var a = dioO.Dio();
    a.options.headers["authorization"] =
        'Bearer ${Get.find<LoginController>().jwtToken}';
    var response = await a.post(
        "https://tracking.irace.vn/api/v1/app/activities/$id/photos",
        data: formData);
    dev.log("TrackingApi - updateAvatar: ${response.statusCode}");
    if (response.statusCode == 200) {
      var dataRespone = response.data["data"];
      DataModelStrava model = DataModelStrava.fromJson(dataRespone);
      return Future.value(model);
    } else {
      return null;
    }
  }

//   static Future<DataModelStrava?> postActivity2(
//       DataModelStrava modelStrava) async {
// //         Map <String,String> headers={
// //           "Accept": "text/plain",
// //           "content-type": "multipart/form-data",
// //           'Authorization': 'Bearer ${Get.find<LoginController>().jwtToken}'
// //         };
// //   var postUri = Uri.parse("https://tracking.irace.vn/api/v1/app/activities");
// //  var request = new http.MultipartRequest("POST", postUri);
// //  request.headers.addAll(headers);
// //  request.fields

//     var tmp;
//     if (modelStrava.photos.isNotEmpty) {
//       dev.log("TrackingApi - postApi2: NotEmpty");
//       tmp = modelStrava.photos[0];
//     }
//     if (tmp != null) {
//       dev.log("TrackingApi - postApi2: not Null");
//     }
//     Map<String, dynamic> mapData = await modelStrava.toJsonAc(tmp);
//     var formData = dioO.FormData.fromMap(mapData);
//     var a = dioO.Dio();
//     a.options.headers["authorization"] =
//         'Bearer ${Get.find<LoginController>().jwtToken}';
//     a.options.headers["Accept"] = 'application/json';
//     a.options.headers["content-type"] = 'application/json';
//     var response = await a.post(
//         "https://tracking.irace.vn/api/v1/app/activities",
//         data: jsonEncode(mapData));

//     // dev.log("TrackingApi - postApi2: ${jsonEncode(formData)}");
//     dev.log("TrackingApi - postApi2: ${response.data}");
//     Map<String, dynamic> data1 = response.data as Map<String, dynamic>;
//     // dev.log("TrackingApi - postApi3: ${jsonDecode(response.data)['data']}");

//     dev.log("TrackingApi - postApi2: ${response.statusCode}");

//     if (response.statusCode == 200) {
//       // var data1 = jsonDecode(response.data);
//       // dev.log("TrackingApi - postApi: ${data1["data"]}");
//       DataModelStrava model = DataModelStrava.fromJson(data1["data"]);
//       return Future<DataModelStrava>.value(model);
//     } else {
//       return Future<DataModelStrava>.value(DataModelStrava());
//     }
//   }
}
