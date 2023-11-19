import 'dart:convert';

import 'package:get/get.dart';
import 'package:tracker_run/app/data/local/best_record.dart';
import 'package:tracker_run/app/resources/dev_utils.dart';

import 'package:http/http.dart' as http;

import '../../login/controllers/login_controller.dart';
import '../../tracking_map_v2/model/data_model_strava.dart';
class TabApi {
  Future<List<DataModelStrava>> getListActivities(int page,int perPage)async{
    List<DataModelStrava> list=[];
    try {
      var response=await http.get(Uri.parse("https://tracking.irace.vn/api/v1/app/activities?page=$page&per_page=$perPage"),
      headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer ${Get.find<LoginController>().jwtToken}'
        },
      );
      var statusCode=response.statusCode;
      if(statusCode==200){
           var dataRespone = jsonDecode(response.body);
            //  DevUtils.printLog("TabApi", "getListActivities", dataRespone.toString());
           Iterable listData=dataRespone["data"]["activities"];

           final mapData=listData.cast<Map<String, dynamic>>();
      list=mapData.map<DataModelStrava>((json){
        return DataModelStrava.fromJson(json);
      }).toList();
      }
    } catch (e) {
      DevUtils.printLog("TabApi", "getListActivities", e.toString());
    }
      // DevUtils.printLog("TabApi", "getListActivities1", list[0].dataStrava.toJson().toString());
    return Future<List<DataModelStrava>>.value(list);
  }  
   Future<BestRecord?> getBestActivities()async{
    BestRecord rs;
    try {
      var response=await http.get(Uri.parse("https://tracking.irace.vn/api/v1/app/users/best-record"),
      headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer ${Get.find<LoginController>().jwtToken}'
        },
      );
      var statusCode=response.statusCode;
      if(statusCode==200){
           var dataRespone = jsonDecode(response.body);
      rs=BestRecord.fromJson(dataRespone["data"]);
      return rs;
      }
    } catch (e) {
      DevUtils.printLog("TabApi", "getBestActivities", e.toString());
    }
      // DevUtils.printLog("TabApi", "getListActivities1", list[0].dataStrava.toJson().toString());
    return null;
  }  
}