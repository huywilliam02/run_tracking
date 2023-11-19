import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tracker_run/app/data/local/best_record.dart';
import 'package:tracker_run/app/database/database_local.dart';
import 'package:tracker_run/app/modules/tab_view/api/tab_api.dart';
import 'package:tracker_run/app/modules/tracking_map_v2/api/tracking_api.dart';
import 'package:tracker_run/app/modules/tracking_step/controllers/tracking_step_controller.dart';
import 'package:tracker_run/app/resources/app_constants.dart';
import 'package:tracker_run/app/resources/dev_utils.dart';
import '../../../../../class_test_data/viewjson.dart';
import '../../../../../generated/locales.g.dart';
import '../../../../base/base_controller.dart';
import '../../../../routes/app_pages.dart';
import '../../../login/controllers/login_controller.dart';
import '../../../tracking_map_v2/model/data_model_strava.dart';
import '../../views/tab_home_view/more_record/more_record.dart';

class TabHomeController extends BaseController {
  Rx<bool> isLoading = true.obs;
  RxList<DataModelStrava> list = <DataModelStrava>[].obs;
  List<DataModelStrava> listPushOnline = <DataModelStrava>[].obs;
  BestRecord bestRecord = BestRecord();
  RxList<DataModelStrava> listBestRecord = <DataModelStrava>[].obs;
  ScrollController scrollController = ScrollController();
  Rx<int> maximumItemShow = 10.obs;
  int indexPage = 1;
  Rx<bool> notHaveData = false.obs;
  @override
  void onInit() async {
    super.onInit();
    await getDataModel();
    await getBestRecord();
    isLoading(false);
  }

  @override
  void onReady() async {
    super.onReady();
    if (await Permission.activityRecognition.isGranted) {
      Get.put(TrackingStepController());
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  onClickMore() {
    Get.to(()=>MoreRecord());
    if (scrollController.hasListeners) {
      scrollController.removeListener(() {});
    }
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _getMoreList();
      }
    });
  }

  onTapDetail(DataModelStrava model) {
    Get.toNamed(Routes.TRACKING_DETAIL, arguments: model);
  }

  _getMoreList() async {
    List<DataModelStrava> listMore =
        await TabApi().getListActivities(++indexPage, 5);
    if (listMore.isNotEmpty) {
      list.addAll(listMore);
    } else {
      notHaveData.value = true;
      Get.snackbar(LocaleKeys.common_notification_title.tr,
          LocaleKeys.common_not_have_data.tr,
          backgroundColor: Colors.white);
    }
  }

  Future<void> pushOnline(List<DataModelStrava> listPushOnline) async {
    try {
      Rx<int> completed = 0.obs;

      if (listPushOnline.isNotEmpty) {
        QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.loading,
          title: LocaleKeys.tab_home_view_text_sync_data.tr,
          widget: Obx(() => Text(
                completed.value.toString() + "/${listPushOnline.length}",
                style: TextStyleConstant.whiteBold16,
              )),
        );
        await Future.delayed(Duration(seconds: 2));
        DataModelStrava? tmp;
        listPushOnline.forEach((modelTracking) async {
          tmp = await TrackingApi.postActivity(
              modelTracking, Get.find<LoginController>().jwtToken);

          if (tmp != null) {
            completed.value++;
        await    DatabaseLocal.instance.deleteRecordNotOnline("${modelTracking.id}",
                "${Get.find<LoginController>().loginModel.value.id}");
          }
        });
        await Future.delayed(Duration(seconds: 2));

        Get.back();
      } else {}
    } catch (e) {
      DevUtils.printLog("TabHomeController", "120", e.toString());
    }
  }

  Future<bool> postApi(DataModelStrava modelTracking) async {
    var response = await http.post(
        Uri.parse("https://tracking.irace.vn/api/v1/app/activities"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body: jsonEncode(modelTracking));
    if (response.statusCode == 200) {
      // modelTracking.isOnline = true;
      modelTracking.save();

      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  viewJson(int index) {
    DataModelStrava dataModelStrava = list[index];
    Get.to(ViewJson(modelStrava: dataModelStrava));
  }

  getDataModel() async {
    bool checkInternet = Get.find<LoginController>().hasInternet.value;
    if (checkInternet == true) {
      //Kiểm list local xem có cái nào chưa push online ko
      List<DataModelStrava> listNotOnline = await DatabaseLocal.instance
          .getListTrackingLocalNotOnline(
              Get.find<LoginController>().loginModel.value.id.toString());
      //Rỗng
      if (listNotOnline.isNotEmpty) {
        DevUtils.printLog(
            "getDataModel", "IsNotEmpty", "lengh${listNotOnline.length}");
        await pushOnline(listNotOnline);
      } else {
        DevUtils.printLog(
            "getDataModel", "Empty", "lengh${listPushOnline.length}");
      } //Không rỗng

      list.value = await TabApi().getListActivities(indexPage, 5);

      await DatabaseLocal.instance.updateListTrackingLocal(list.value,
          Get.find<LoginController>().loginModel.value.id.toString());
      // Nếu có thì lưu 1 mảng và push lên sau đó kéo hết về lại và lưu local 3 cái mới nhất4
    } else {
      list.value = await DatabaseLocal.instance.getListTrackingLocal(
          Get.find<LoginController>().loginModel.value.id.toString());
      //Lấy list local
    }
  }

  getBestRecord() async {
    try {
      bool checkInternet = Get.find<LoginController>().hasInternet.value;
      if (checkInternet) {
        var rs = await TabApi().getBestActivities();
        if (rs != null) {
          bestRecord = rs;
          print(bestRecord.bestPace!.maxSpeed);
          await DatabaseLocal.instance.updateBestRecord(bestRecord,
              Get.find<LoginController>().loginModel.value.id.toString());
        }
      } else {
        bestRecord = await DatabaseLocal.instance.getBestRecord(
            Get.find<LoginController>().loginModel.value.id.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkPermission() async {
    // if(Platform.isAndroid){
    var status = await Permission.activityRecognition.status;
    print(status);
    if (status.isDenied) {
      var status2 = await Permission.activityRecognition.request();
      if (!status2.isGranted) {
        stepsPermissionDialog();
      }
      return;
    }
  }

  void stepsPermissionDialog() {
    showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Please give permission"),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("GO TO SETTING"),
                onPressed: () async {
                  openAppSettings();
                },
              ),
            ],
          );
        });
  }
}
