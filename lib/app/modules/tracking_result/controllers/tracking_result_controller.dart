import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:tracker_run/app/base/base_controller.dart';
import 'package:tracker_run/app/database/database_local.dart';
import 'package:tracker_run/app/modules/tracking_map_v2/controllers/tracking_map_v2_controller.dart';
import 'package:tracker_run/app/resources/app_constants.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';
import 'package:tracker_run/app/routes/app_pages.dart';

import '../../login/controllers/login_controller.dart';
import '../../tracking_map_v2/api/tracking_api.dart';
import '../../tracking_map_v2/model/data_model_strava.dart';

class TrackingResultController extends BaseController {
  TrackingResultController({required this.model});

  DataModelStrava model;
  Rx<String> nameActivities = "".obs;
  // Rx<String> imageBase64 = "".obs;
  RxList<String> listImage = <String>[].obs;
//nhận data 1
  @override
  void onInit() {
    super.onInit();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  onTabDeleteIamge(int index) {
    listImage.removeAt(index);
  }

  onTapLeading() async {
    if (Get.isRegistered<TrackingMapV2Controller>()) {
      Get.find<TrackingMapV2Controller>().dispose();
    }
    Get.offAllNamed(Routes.HOME);
  }

  onTapDetail() {
    Get.offNamed(Routes.TRACKING_DETAIL, arguments: model);
  }

  submitActivitie() async {
    if (nameActivities.value != "") {
      model.name = nameActivities.value;
    }
    // trackingModel.imageMapBase64 = imageBase64.value;
    // Get.back();
    await storageData();
  }

  onImagePick() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      final LostDataResponse response2 = await _picker.retrieveLostData();
      File file = File(pickedFile.path);
      listImage.add(file.path);
    }
  }

  storageData() async {
    if (listImage.isNotEmpty) {
      model.photos = listImage;
    }

    DatabaseLocal.instance.storageLocal(
        model, Get.find<LoginController>().loginModel.value.id.toString());

    // if (Get.find<LoginController>().hasInternet.isTrue) {
    //   // await pushOnline(model);
    //   postOnline(Get.find<LoginController>().loginModel.value.id.toString(),Get.find<LoginController>().jwtToken);
    //   // await updateBestRecord(model);
    // }
    Get.offNamed(Routes.TRACKING_DETAIL, arguments: model);
  }

  void postOnline(String idUser, String jwtToken) {
    var receivePort = ReceivePort();
    Isolate.spawn(pushActivities, [receivePort.sendPort, model, jwtToken]);
    receivePort.listen((message) async {
      if (message) {
        await DatabaseLocal.instance
            .deleteRecordNotOnline(model.id.toString(), idUser);
        print("ok");
        // await    NotificationController.cancelNotifications();
      }
    });
  }

  static void pushActivities(List<Object> list) async {
    SendPort sendPort;
    DataModelStrava model;

    if (list[0] is SendPort) {
      //  await   NotificationController.createNewNotificationSyscingData();
      sendPort = list[0] as SendPort;

      if (list[1] is DataModelStrava) {
        model = list[1] as DataModelStrava;
        DataModelStrava? stravaCheck =
            await TrackingApi.postActivity(model, list[2] as String);
        sendPort.send(true);
      } else {
        sendPort.send(false);
      }
    }
  }

  Future<bool> getConnection() async {
    bool isConnection = await InternetConnectionChecker().hasConnection;
    if (isConnection) {
      print("have wifi");
      return Future.value(true);
    } else {
      print("no wifi");
      return Future.value(false);
    }
  }

  pushOnline(DataModelStrava data) async {
    Rx<int> completed = 0.obs;

    QuickAlert.show(
      context: Get.context!,
      type: QuickAlertType.loading,
      title: "Syncing data...",
      widget: Obx(() => Text(
            completed.toString() + "/1",
            style: TextStyleConstant.whiteBold16,
          )),
    );
    await Future.delayed(Duration(seconds: 2));

    DataModelStrava? stravaCheck = await TrackingApi.postActivity(
        data, Get.find<LoginController>().jwtToken);

    if (stravaCheck != null) {
      completed.value++;
      await DatabaseLocal.instance.deleteRecordNotOnline(data.id.toString(),
          Get.find<LoginController>().loginModel.value.id.toString());
      await Future.delayed(Duration(seconds: 2));
      Get.back();
      QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.success,
          text: "Will be move to Detail Page");
      await Future.delayed(Duration(seconds: 1));
      model = stravaCheck;
    } else {
      Get.back();
      QuickAlert.show(
          context: Get.context!,
          type: QuickAlertType.error,
          text: "Push activity online fail!");
    }
  }

  setValueName(String value) {
    nameActivities.value = value;
  }

  // updateBestRecord(DataModelStrava data) async {
  //   Box bestRecordBox = await Hive.openBox(
  //       "BESTRECORD-${Get.find<LoginController>().loginModel.value.id}");
  //   if (bestRecordBox.values.isEmpty) {
  //     await bestRecordBox.add(BestRecord());
  //   }
  //   BestRecord bestRecord = bestRecordBox.getAt(0) as BestRecord;
  //   if (data.distance > bestRecord.bestDistanceValue!) {
  //     bestRecord.bestDistanceValue = data.distance;
  //     bestRecord.idBestDistance = data.id.toString();
  //   }
  //   if (data.maxPace < bestRecord.bestPaceValue! ||
  //       bestRecord.bestPaceValue == 0) {
  //     bestRecord.bestPaceValue = data.maxPace;
  //     bestRecord.idBestPace = data.id.toString();
  //   }
  //   if (data.movingTime > bestRecord.bestDurationValue!) {
  //     bestRecord.bestDurationValue = data.movingTime;
  //     bestRecord.idBestDuration = data.id.toString();
  //   }
  //   bestRecord.save();
  // }

  showDialogMessage() {
    Get.dialog(
      WillPopScope(
        onWillPop: (() async {
          return false;
        }),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Builder(
            builder: (context) {
              return SafeArea(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorConstant.primary,
                        borderRadius: BorderRadius.circular(40)),
                    padding: EdgeInsets.all(UtilsReponsive.width(context, 20)),
                    margin: EdgeInsets.only(
                      left: UtilsReponsive.width(context, 50),
                      right: UtilsReponsive.width(context, 50),
                    ),
                    height: UtilsReponsive.height(context, 300),
                    width: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Tên :",
                          style: TextStyleConstant.whiteBold22,
                        ),
                        TextField(
                          onChanged: (value) {
                            nameActivities.value = value;
                          },
                        ),
                        ElevatedButton(
                          onPressed: submitActivitie,
                          child: const Text(
                            "Gửi thông tin",
                            style: TextStyleConstant.whiteBold16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
