import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart' as locat;
import 'package:permission_handler/permission_handler.dart' as perMiss;
import 'package:polyline_do/polyline_do.dart' as polydo;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:tracker_run/app/base/base_controller.dart';
import 'package:tracker_run/app/enum/format_timer.dart';
import 'package:tracker_run/app/modules/count_down_timer/views/count_down_timer_view.dart';
import 'package:tracker_run/app/modules/tracking_map_v2/views/tracking_map_v2_basic.dart';
import 'package:tracker_run/app/resources/dev_utils.dart';

import '../../../../generated/locales.g.dart';
import '../../../components/default_dialog.dart';
import '../../../routes/app_pages.dart';
import '../model/data_model_strava.dart';
import '../model/streamdata.dart';
import '../utils/calculate.dart';
import '../widget/overlay_finish.dart';

class TrackingMapV2Controller extends BaseController
    with WidgetsBindingObserver {
//Biến trạng thái
  Rx<String> typeMode = "RUN".obs;
  Rx<bool> isLoading = true.obs;
  Rx<bool> isLoadingBeforeStart = false.obs;
  Rx<bool> isButtonStart = true.obs;
  Rx<bool> isStart = false.obs;
//Tổng hơp dữ liệu view màn hình
  Rx<String> elapTime = "00:00:00".obs;
  Rx<String> pace = "00:00".obs;
  Rx<String> speed = "0.0".obs;
  Rx<String> calo = "0.0".obs;
  Rx<String> distance = "0.0".obs;
  Rx<String> km = "0.0".obs;
  late RxList<LatLng> polyline = <LatLng>[].obs;
  late RxList<LatLng> polylineSummary = <LatLng>[].obs;
  Rx<bool> isGpsDisable = false.obs;

//Xử lý đữ liệu
  late locat.Location location;
  late StreamSubscription<locat.LocationData> positionStreamOnApp;
  GoogleMapController? controllerGm;
  late locat.LocationData currentPosition;
  late locat.LocationData beforeLocation;

  double lastDistance = 0;
  double conditionDistance = 2;
  double weight = 60;
  late StopWatchTimer movingWatchTimer;
  late StopWatchTimer elapsedWatchTimer;
  late DataModelStrava dataModelStrava;
  int movingtimeSplit = 0;
  int elaptimeSplit = 0;

  // double dataModelStrava.totalElevationGain = 0;
  double totalSpeed = 0;
  double beforeElevationGain = 0;
  double totalSpeedSplit = 0;
  int lastIndex = 0;
  double elevBefore = 0;
  double conditionFilterKm = 1000;
  double avgSpeed = 0;
  StreamData streamData = StreamData();
  Rx<int> numSignal = 0.obs;
  RxSet<Marker> markers = Set<Marker>().obs;
  Rx<bool> interupCheck = false.obs;

  @override
  void onInit() async {
    super.onInit();
    try {
      isLoading(true);
      location = locat.Location();
      location.changeSettings(accuracy: locat.LocationAccuracy.navigation);
      await getCurrentPosion();
      await getNumSinal();
      dataModelStrava = DataModelStrava();
      Box a = await Hive.openBox("stream");
      if (a.values.isNotEmpty) {
        interupCheck(true);
        dataModelStrava = a.getAt(0) as DataModelStrava;
        distance.value =
            (dataModelStrava.distance / 1000).toPrecision(2).toString();
        calo.value = dataModelStrava.calories.round().toString();
        polyline.assignAll(List<LatLng>.from(dataModelStrava.listPolyline!
            .map((e) => LatLng(e[0], e[1]))
            .toList()));
        polylineSummary.assignAll(List<LatLng>.from(dataModelStrava
            .listPolylineSum!
            .map((e) => LatLng(e[0], e[1]))
            .toList()));
        isButtonStart(false);
        for (var i = 0;
            i <= dataModelStrava.dataStream.latlng.length - 1;
            i++) {
          polyline.add(LatLng(dataModelStrava.dataStream.latlng[i][0],
              dataModelStrava.dataStream.latlng[i][1]));
        }
        lastedCountTimer();
        onClickStop();
      } else {
        newCountTimer();
      }
      WidgetsBinding.instance.addObserver(this);
      positionStreamOnApp =
          location.onLocationChanged.listen((locat.LocationData locationData) {
        dataProcess(locationData);
      });
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo info = await deviceInfo.androidInfo;
        dataModelStrava.deviceName = info.model!;
      } else {
        dataModelStrava.deviceName = "Unknow";
      }
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude!, currentPosition.longitude!);
      dataModelStrava.locationCountry = placemarks[0].country!;
      StreamSubscription<ServiceStatus> serviceStatusStream =
          Geolocator.getServiceStatusStream()
              .listen((ServiceStatus status) async {
        if (status == ServiceStatus.disabled) {
          isGpsDisable(true);
          if (isButtonStart.isFalse) {
            await onClickStop();
          }
          QuickAlert.show(
              barrierDismissible: true,
              context: Get.context!,
              type: QuickAlertType.error,
              title: "GPS",
              text: LocaleKeys.common_GPS_disable.tr,
              onConfirmBtnTap: () async {
                Get.back();
                await location.requestService();
              });
        } else {
          isGpsDisable(false);
        }
      });

      await handlePermission();
    } finally {
      isLoading(false);
    }
  }

  // void setDeviceName() {
  //   var receivePort = ReceivePort();
  //   Isolate.spawn(getNameDevice, receivePort.sendPort);
  //   receivePort.listen((message) {
  //     print(message);
  //    });
  // }

  // static void getNameDevice(SendPort sendPort) async {
  //   int nameDevice = 0;
  //  for(var i=0;i<1000000000;i++){
  //   nameDevice+=i;
  //  }
  //   sendPort.send(nameDevice);
  // }

  Future<void> getNumSinal() async {
    if (await perMiss.Permission.locationAlways.status.isGranted) {
      numSignal.value = 2;
    } else if (await perMiss.Permission.locationWhenInUse.status.isGranted) {
      numSignal.value = 1;
    }
  }

  @override
  void onReady() async {
    super.onReady();
    once(isStart, (_) {
      if (isStart.isTrue) {
        startCountTimer();
        positionStreamOnApp.resume();
        Get.to(() => TrackingMapV2Basic(), transition: Transition.topLevel);
        print("bắt đầu");
      }
    });
    // NotificationController.createNewNotification();
    // await
    //           NotificationController().showProgressNotification(10);
  }

  @override
  void onClose() {
    location.enableBackgroundMode(enable: false);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("abc2");
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print("resumed");
      await getNumSinal();
      await updateMap();
      perMiss.PermissionStatus checkLocation =
          await perMiss.Permission.locationAlways.status;
      if (checkLocation.isGranted) {
        location.enableBackgroundMode(enable: true);
      }
    }
    if (state == AppLifecycleState.detached) {
      location.enableBackgroundMode(enable: false);
    }
    if (state == AppLifecycleState.paused) {
      print("paused");
    }
    if (state == AppLifecycleState.inactive) {
      print("inactive");
    }
  }

  Future<void> updateMap() async {
    var currentPosition = await location.getLocation();
    controllerGm?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target:
                LatLng(currentPosition.latitude!, currentPosition.longitude!),
            zoom: 18),
      ),
    );
  }

  //Tổng các hàm xử lý dữ liệu
  //1.TODO: GetCurrentPosition
  Future<void> getCurrentPosion() async {
    try {
      currentPosition = await location.getLocation();

      beforeLocation = currentPosition;
    } catch (e) {
      DevUtils.printLog("TrackingV2", "getCurrentPosion", e.toString());
    }
  }

  //2.TODO: Tạo đồng hồ bấm giờ
  void newCountTimer() {
    movingWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
      onChange: (value) {
        dataModelStrava.movingTime = CalculateFactoryUtils()
            .convertTimeStrToSecond(StopWatchTimer.getDisplayTime(
          value,
          hours: true,
          minute: true,
          second: true,
          milliSecond: false,
        ));
      },
    );
    elapsedWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
      onChange: (value) {
        dataModelStrava.elapsedTime = CalculateFactoryUtils()
            .convertTimeStrToSecond(StopWatchTimer.getDisplayTime(
          value,
          hours: true,
          minute: true,
          second: true,
          milliSecond: false,
        ));
        elapTime.value = StopWatchTimer.getDisplayTime(
          value,
          hours: true,
          minute: true,
          second: true,
          milliSecond: false,
        );
      },
    );
  }

  void lastedCountTimer() {
    movingWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
      presetMillisecond: dataModelStrava.movingTime * 1000,
      onChange: (value) {
        dataModelStrava.movingTime = CalculateFactoryUtils()
            .convertTimeStrToSecond(StopWatchTimer.getDisplayTime(
          value,
          hours: true,
          minute: true,
          second: true,
          milliSecond: false,
        ));
      },
    );
    elapsedWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
      presetMillisecond: dataModelStrava.elapsedTime * 1000,
      onChange: (value) {
        dataModelStrava.elapsedTime = CalculateFactoryUtils()
            .convertTimeStrToSecond(StopWatchTimer.getDisplayTime(
          value,
          hours: true,
          minute: true,
          second: true,
          milliSecond: false,
        ));
        elapTime.value = StopWatchTimer.getDisplayTime(
          value,
          hours: true,
          minute: true,
          second: true,
          milliSecond: false,
        );
      },
    );
    elapTime.value = StopWatchTimer.getDisplayTime(
      dataModelStrava.elapsedTime * 1000,
      hours: true,
      minute: true,
      second: true,
      milliSecond: false,
    );
  }

  //3. Tạo Map
  void onMapCreated(GoogleMapController controller) {
    controllerGm = controller;
    controllerGm!.setMapStyle(
        '[{"featureType": "poi.business","stylers": [{ "visibility": "off" }]}]');
  }

  // 4. Start đồng hò
  void startCountTimer() {
    movingWatchTimer.onStartTimer();
    elapsedWatchTimer.onStartTimer();
  }

  // 5. Stop đồng hò
  void stopCountTimer() {
    movingWatchTimer.onStopTimer();
    elapsedWatchTimer.onStopTimer();
  }

  //5.1 Resume đồng hồ
  void resumeCountTimer() {
    movingWatchTimer.onStartTimer();
    elapsedWatchTimer.onStartTimer();
  }

  //6. Xử lý dữ liệu
  void dataProcess(locat.LocationData location) {
    switch (typeMode.value) {
      case "RUN":
        modeRunDataProcess(location);
        break;
      case "RIDE":
        modeRunDataProcess(location);
        break;
      default:
        modeRunDataProcess(location);
    }
  }

//Các hàm phụ trách tính toán cho xử lý dữ liệu mode
  int calculatePace(double speed) {
    var speedInMps = speed;
    return (1000 / speedInMps).round();
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    return (GeolocatorPlatform.instance
        .distanceBetween(lat1, lon1, lat2, lon2));
  }

  int timeOld = 0;
  double countCalories(double weight, double currentSpeed) {
    double rsCalo = 0;
    int sec2Tmp = dataModelStrava.movingTime;
    if (pace.value != "00:00" || dataModelStrava.distance != 0) {
      rsCalo = ((getMETConstant(currentSpeed) * 3.5 * weight) / 200) *
          ((sec2Tmp - timeOld) * 0.06);
    } else {
      rsCalo = 0.0;
    }
    timeOld = sec2Tmp;
    return rsCalo;
  }

  double getMETConstant(double currentSpeed) {
    var runPace = minPerKmToMinPerMile(currentSpeed / 60);
    if (runPace >= 13) {
      return 5;
    } else if (runPace >= 12) {
      return 8.3;
    } else if (runPace >= 11.5) {
      return 9;
    } else if (runPace >= 10) {
      return 8;
    } else if (runPace >= 9) {
      return 10.5;
    } else if (runPace >= 8.5) {
      return 11;
    } else if (runPace >= 8) {
      return 11.5;
    } else if (runPace >= 7.5) {
      return 11.8;
    } else if (runPace >= 7) {
      return 12.3;
    } else if (runPace >= 6.5) {
      return 12.8;
    } else if (runPace >= 6) {
      return 14.5;
    } else if (runPace >= 5.5) {
      return 16;
    } else if (runPace >= 5) {
      return 19;
    } else if (runPace >= 4.6) {
      return 19.8;
    } else if (runPace >= 4.3) {
      return 23;
    } else {
      return 8;
    }
  }

  static double minPerKmToMinPerMile(double speedInKm) {
    double speedInmMile = speedInKm * 1.609;

    return speedInmMile;
  }

  setMaxValue(locat.LocationData position) {
    if (position.speed! > dataModelStrava.maxSpeed) {
      dataModelStrava.maxSpeed = position.speed!;
    }
    //SPPOCTP2CHUEL30D
    if ((1000 / position.speed!) < dataModelStrava.maxPace) {
      dataModelStrava.maxPace = (1000 / position.speed!);
    }
    if (position.altitude! > dataModelStrava.elevHigh) {
      dataModelStrava.elevHigh = position.altitude!;
    }
    if (position.altitude! < dataModelStrava.elevLow) {
      dataModelStrava.elevLow = position.altitude!;
    }
  }

  void getLastRecord() {
    // splitsMetric=SplitsMetric();
    SplitsMetric splitsMetric = SplitsMetric();
    splitsMetric.split = dataModelStrava.splitsMetric.length + 1;
    splitsMetric.distance = dataModelStrava.distance;
    splitsMetric.movingTime = dataModelStrava.movingTime - movingtimeSplit;
    splitsMetric.elapsedTime = dataModelStrava.elapsedTime - elaptimeSplit;
    splitsMetric.averageSpeed =
        totalSpeedSplit / (polylineSummary.length - lastIndex);
    lastIndex = polylineSummary.length;
    splitsMetric.elevationDifference =
        dataModelStrava.totalElevationGain - beforeElevationGain;
    beforeElevationGain = dataModelStrava.totalElevationGain;
    totalSpeedSplit = 0;
    dataModelStrava.splitsMetric.add(splitsMetric);
    dataModelStrava.averageSpeed =
        dataModelStrava.averageSpeed / dataModelStrava.dataStream.speed.length;
    if (polylineSummary.isNotEmpty) {
      dataModelStrava.endLatlng.add(polylineSummary.last.latitude);
      dataModelStrava.endLatlng.add(polylineSummary.last.longitude);
      dataModelStrava.startLatlng.add(polylineSummary.first.latitude);
      dataModelStrava.startLatlng.add(polylineSummary.first.longitude);
    }

    var endCodePolyline = jsonEncode(polyline);
    List<List<double>> listPolyline = List<List<double>>.from(json
        .decode(endCodePolyline)
        .map((x) => List<double>.from(x.map((x) => x.toDouble()))));

    var endCodePolylineSumary = jsonEncode(polylineSummary);
    List<List<double>> listPolylineSumary = List<List<double>>.from(json
        .decode(endCodePolylineSumary)
        .map((x) => List<double>.from(x.map((x) => x.toDouble()))));
    avgSpeed = (totalSpeed / polyline.length).toPrecision(2);

    dataModelStrava.map = MapClass(
        id: dataModelStrava.id.toString(),
        polyline:
            polydo.Polyline.Encode(decodedCoords: listPolyline, precision: 5)
                .encodedString,
        summaryPolyline: polydo.Polyline.Encode(
                decodedCoords: listPolylineSumary, precision: 5)
            .encodedString);
    // dataModelStrava.dataStream = streamData;

    Get.offNamed(Routes.TRACKING_RESULT, arguments: dataModelStrava);

    DevUtils.printLog("nameClass", "funcOrLine", "okkkkkkkk");
  }

  //7. Mode Run
  void modeRunDataProcess(locat.LocationData location) {
    if (isStart.value) {
      polyline.add(LatLng(location.latitude!, location.longitude!));
      dataModelStrava.listPolyline!
          .add([location.latitude!, location.longitude!]);
      speed.value = ((location.speed ?? 0.0) * 3.6).toPrecision(1).toString();
      pace.value =
          Duration(seconds: calculatePace(location.speed!)).toMinutesSeconds();

      lastDistance = calculateDistance(beforeLocation.latitude,
          beforeLocation.longitude, location.latitude, location.longitude);
      setMaxValue(location);
      if ((location.speed! * 0.06 * 60) >= 2) {
        movingWatchTimer.onStartTimer();
      } else {
        movingWatchTimer.onStopTimer();
        pace.value = "00:00";
      }

      if (lastDistance > conditionDistance) {
        dataModelStrava.distance += lastDistance;
        distance.value =
            (dataModelStrava.distance / 1000).toPrecision(2).toString();

        dataModelStrava.dataStream.time.add(dataModelStrava.movingTime);
        dataModelStrava.dataStream.latlng
            .add([location.latitude!, location.longitude!]);
        dataModelStrava.dataStream.altitude.add(location.latitude!);
        dataModelStrava.dataStream.distance.add(dataModelStrava.distance);
        dataModelStrava.dataStream.speed.add(location.speed!);
        dataModelStrava.averageSpeed += location.speed!;
        dataModelStrava.listPolylineSum!
            .add([location.latitude!, location.longitude!]);
        polylineSummary.add(LatLng(location.latitude!, location.longitude!));
        beforeLocation = location;
        dataModelStrava.calories += countCalories(weight, location.speed!);
        calo.value = dataModelStrava.calories.round().toString();

        totalSpeedSplit += location.speed!;
        totalSpeed += location.speed!;

        if (location.altitude! > elevBefore) {
          dataModelStrava.totalElevationGain +=
              (location.altitude! - elevBefore);
        }
        elevBefore = location.altitude!;

        if (dataModelStrava.distance >= conditionFilterKm) {
          SplitsMetric splitsMetric = SplitsMetric();
          splitsMetric.split = dataModelStrava.splitsMetric.length + 1;
          splitsMetric.distance = dataModelStrava.distance;
          splitsMetric.movingTime =
              dataModelStrava.movingTime - movingtimeSplit;
          splitsMetric.elapsedTime =
              dataModelStrava.elapsedTime - elaptimeSplit;
          splitsMetric.averageSpeed =
              totalSpeedSplit / (polylineSummary.length - lastIndex);
          lastIndex = polylineSummary.length;
          splitsMetric.elevationDifference =
              dataModelStrava.totalElevationGain - beforeElevationGain;
          beforeElevationGain = dataModelStrava.totalElevationGain;
          totalSpeedSplit = 0;
          dataModelStrava.splitsMetric.add(splitsMetric);
          conditionFilterKm += 1000;
          movingtimeSplit = dataModelStrava.movingTime;
          elaptimeSplit = dataModelStrava.elapsedTime;
        }
      }
      dataModelStrava.save();
    }
  }

//Tổng các sự kiện nút
  onClickStart() async {
    try {
      isLoadingBeforeStart(true);
      Box a = await Hive.openBox("stream");
      if (a.values.isEmpty) {
        a.add(dataModelStrava);
      }
      if (await perMiss.Permission.locationAlways.isGranted) {
        location.enableBackgroundMode();
      }
      //  await locat.Location().changeSettings(accuracy: geo.LocationAccuracy);
      print("isButtonStart" + isButtonStart.value.toString());
      await getCurrentPosion();
      await addMarkerStart(
          LatLng(beforeLocation.latitude!, beforeLocation.longitude!));

      polylineSummary
          .add(LatLng(currentPosition.latitude!, currentPosition.longitude!));

      dataModelStrava.sportType = typeMode.value;
      dataModelStrava.type = typeMode.value;
      dataModelStrava.startDate = DateTime.now().toUtc();
      dataModelStrava.startDateLocal =
          DateTime.now().toUtc().add(const Duration(hours: 7));

      String timzoneStr = "(GMT" +
          DateTime.now().timeZoneName.substring(0, 1) +
          DateTime.now().timeZoneOffset.toHoursMinutes() +
          ") " +
          await FlutterNativeTimezone.getLocalTimezone();
      dataModelStrava.timezone = timzoneStr;
      dataModelStrava.utcOffset = DateTime.now().timeZoneOffset.inSeconds;
      dataModelStrava.id = DateTime.now().millisecondsSinceEpoch;
      dataModelStrava.name = dataModelStrava.id.toString();
      // isStart(true);
      // startCountTimer();
      // positionStreamOnApp.resume();
      isLoadingBeforeStart(false);
      Get.to(() => CountDownTimerView());
      isButtonStart.value = !isButtonStart.value;
    } catch (e) {
      DevUtils.printLog("TrackingMapV2", "onClickStart", e.toString());
    }
  }

  onClickStop() {
    isStart(false);

    stopCountTimer();
    Get.defaultDialog(
      title: '',
      content: OverlayFinish(
        onResume: () async {
          if (isGpsDisable.isTrue) {
            QuickAlert.show(
                barrierDismissible: true,
                context: Get.context!,
                type: QuickAlertType.error,
                title: "GPS",
                text: LocaleKeys.common_GPS_disable.tr,
                onConfirmBtnTap: () async {
                  Get.back();
                  await location.requestService();
                });
          } else {
            Get.back();
            if (interupCheck.value) {
              interupCheck.value = !interupCheck.value;
            }
            await onClickResume();
          }
        },
        onFinish: () async {
          getLastRecord();
          Box a = await Hive.openBox("stream");
          a.clear();
        },
        onDiscard: (context) async {
          showDialog(
              context: context,
              builder: (BuildContext context) => DefaultDialog(
                    confirm: LocaleKeys.common_discard.tr,
                    cancel: 'Cancel',
                    title: LocaleKeys.common_alert.tr,
                    content: LocaleKeys.common_alert_content_discard.tr,
                    onConfirm: () async {
                      Box a = await Hive.openBox("stream");
                      await a.clear();
                      Get.offAllNamed(
                        Routes.HOME,
                      );
                    },
                  ));
        },
      ),
    );
  }

  onClickResume() async {
    isStart(true);
    resumeCountTimer();
    await getCurrentPosion();
    positionStreamOnApp =
        location.onLocationChanged.listen((locat.LocationData locationData) {
      dataProcess(locationData);
    });
    location.changeSettings(accuracy: locat.LocationAccuracy.navigation);
    positionStreamOnApp.resume();
  }

  addMarkerStart(LatLng location) async {
    markers = Set<Marker>().obs;
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/icons/ic_map_pin_purple.png', 50);
    final Marker marker = Marker(
        icon: BitmapDescriptor.fromBytes(markerIcon),
        markerId: MarkerId('1'),
        position: LatLng(location.latitude, location.longitude));
    markers.add(marker);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  handlePermission() async {
    // await testRequestLocationPermission();
    perMiss.PermissionStatus permisstionCheck =
        await perMiss.Permission.locationAlways.status;
    if (permisstionCheck == perMiss.PermissionStatus.granted) {
      location.enableBackgroundMode(enable: true);
    } else {
      QuickAlert.show(
        context: Get.context!,
        title: "Vị trí",
        text:
            "Để thực hiện việc tracking chính xác hơn cần quyền luôn truy cập vị trí",
        type: QuickAlertType.warning,
        confirmBtnText: "OK",
        onConfirmBtnTap: () async {
          Get.back();
          await testRequestLocationPermission();
        },
        cancelBtnText: "Cancel",
        showCancelBtn: true,
        onCancelBtnTap: () {
          Get.back();
        },
      );
    }
  }

  Future<void> testRequestLocationPermission() async {
    perMiss.PermissionStatus locationStatus =
        await perMiss.Permission.locationAlways.request();
    print("locationStatus" + locationStatus.toString());
    if (locationStatus != perMiss.PermissionStatus.granted) {
//Show thông báo

      if (locationStatus == perMiss.PermissionStatus.denied) {
        await QuickAlert.show(
            title: "Location Permission ",
            text: "Cần cấp quyền luôn truy cập vị trí",
            context: Get.context!,
            type: QuickAlertType.warning,
            confirmBtnText: "Cấp quyền",
            onConfirmBtnTap: () async {
              Get.back();
              await perMiss.Permission.locationAlways.request();
            },
            onCancelBtnTap: () {
              Get.back();
            },
            showCancelBtn: true);
      } else if (locationStatus == perMiss.PermissionStatus.permanentlyDenied) {
        //Show thông báo Bị từ chối vĩnh viễn
        await QuickAlert.show(
            title: LocaleKeys.common_location_off_parmanent.tr,
            text: "${LocaleKeys.common_open_app_setting.tr}"
                "\n"
                "${LocaleKeys.common_permission_app.tr}"
                "\n"
                "${LocaleKeys.common_location_permiss.tr}"
                "\n"
                "${LocaleKeys.common_location_always.tr}",
            context: Get.context!,
            type: QuickAlertType.warning,
            confirmBtnText: LocaleKeys.common_allow.tr,
            onConfirmBtnTap: () async {
              Get.back();
              await perMiss.openAppSettings();
            },
            onCancelBtnTap: () {
              Get.back();
            },
            showCancelBtn: true);
      }
    }
  }
}
