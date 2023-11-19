// import 'dart:async';
// import 'dart:ui';

// import 'package:awesome_notifications/android_foreground_service.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:pedometer/pedometer.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// const notificationChannelId = 'my_foreground';

// // this will be used for notification id, So you can update your custom notification with this id.
// const notificationId = 888;

// class BackgroundServiceStep {
//   BackgroundServiceStep._privateConstructor();

//   static final BackgroundServiceStep _instance =
//       BackgroundServiceStep._privateConstructor();

//   static BackgroundServiceStep get instance => _instance;

// // this will be used as notification channel id
// // Future<void> runabc()async{
// //   await initializeService();
// // }
//   static final service = FlutterBackgroundService();
//   static Future<void> onStart(ServiceInstance service) async {
//    try {
//       // Only available for flutter 3.0.0 and later
//         // Get.snackbar("hehe","Ơ");
//     DartPluginRegistrant.ensureInitialized();
//     int count = 0;

//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();

//     StreamSubscription<StepCount> _stepCountStream =
//         Pedometer.stepCountStream.listen((value) async {
//       count++;
//       SharedPreferences abc=await SharedPreferences.getInstance();
//       abc.setInt("key", count);
//     }, onError: (error) {
//       print("ee");
//     }, cancelOnError: false);
//     _stepCountStream.resume();

//     // bring to foreground
//     Timer.periodic(const Duration(seconds: 1), (timer) async {
//       if (service is ServiceInstance) {
//         flutterLocalNotificationsPlugin.show(
//           notificationId,
//           'TestBackground SERVICE $count',
//           'Awesome ${DateTime.now()}',
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               notificationChannelId,
//               'MY FOREGROUND SERVICE',
//               icon: 'ic_bg_service_small',
//               ongoing: true,
//             ),
//           ),
//         );
//         if (await service is AndroidForegroundService) {
//           flutterLocalNotificationsPlugin.show(
//             notificationId,
//             'COOL SERVICE',
//             'Awesome ${DateTime.now()}',
//             const NotificationDetails(
//               android: AndroidNotificationDetails(
//                 notificationChannelId,
//                 'MY FOREGROUND SERVICE',
//                 icon: 'ic_bg_service_small',
//                 ongoing: true,
//               ),
//             ),
//           );
//         }
//       }

//     });
//    } catch (e) {
//     Get.snackbar("sb",e.toString());
     
//    }
//   }
//   static Future<void> initializeService() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       notificationChannelId, // id
//       'MY FOREGROUND SERVICE', // title
//       description:
//           'This channel is used for important notifications.', // description
//       importance: Importance.low, // importance must be at low or higher level
//     );

//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         // this will be executed when app is in foreground or background in separated isolate
//         onStart: onStart,

//         // auto start service
//         autoStart: true,
//         isForegroundMode: true,
//         autoStartOnBoot: true,

//         notificationChannelId:
//             notificationChannelId, // this must match with notification channel you created above.
//         initialNotificationTitle: 'AWESOME SERVICE',
//         initialNotificationContent: 'Initializing',
//         foregroundServiceNotificationId: notificationId,
//       ),
//       iosConfiguration: IosConfiguration(),
//     );
//   }
// }
