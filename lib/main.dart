import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:tracker_run/app/data/local/best_record.dart';
import 'package:tracker_run/app/database/database_local.dart';
import 'package:tracker_run/app/modules/login/model/login_model.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/drinkWaterReminder/models/Preference.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/models/app_prefs.dart';
import 'package:tracker_run/app/modules/tracking_step/model/step_tracking_day.dart';
import 'package:tracker_run/generated/locales.g.dart';

import 'app/modules/tracking_map_v2/model/data_model_strava.dart';
import 'app/modules/tracking_map_v2/model/streamdata.dart';
import 'app/routes/app_pages.dart';

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

String? selectedNotificationPayload;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {

  HttpOverrides.global = new PostHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await Preference().instance();
  Directory dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter<DataModelStrava>(DataModelStravaAdapter());
  Hive.registerAdapter<MapClass>(MapClassAdapter());
  Hive.registerAdapter<SplitsMetric>(SplitsMetricAdapter());
  Hive.registerAdapter<LoginModel>(LoginModelAdapter());
  Hive.registerAdapter<BestRecord>(BestRecordAdapter());
  Hive.registerAdapter<StreamData>(StreamDataAdapter());
  Hive.registerAdapter<StepTrackingDay>(StepTrackingDayAdapter());

  await AppPrefs.instance.initListener();
  tz.initializeTimeZones();
  var detroit = tz.getLocation('Asia/Bangkok');
  tz.setLocalLocation(detroit);
  Locale language = await DatabaseLocal.instance.getLocale();


  runApp(
    GetMaterialApp(
      translationsKeys: AppTranslation.translations,
      title: "Application",
      locale: language,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
