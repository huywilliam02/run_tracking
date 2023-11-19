// import 'dart:async';

// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart'
//     as localNo;
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// class NotificationController {
//   static ReceivedAction? initialAction;

//   ///  *********************************************
//   ///     INITIALIZATIONS
//   ///  *********************************************
//   ///
//   static Future<void> initializeLocalNotifications() async {
//     await AwesomeNotifications().initialize(
//         null, //'resource://drawable/res_app_icon',//
//         [
//           NotificationChannel(
//               channelKey: 'alerts',
//               channelName: 'Alerts',
//               channelDescription: 'Notification tests as alerts',
//               playSound: false,
//               onlyAlertOnce: true,
//               groupAlertBehavior: GroupAlertBehavior.Children,
//               importance: NotificationImportance.Min,
//               defaultPrivacy: NotificationPrivacy.Private,
//               defaultColor: Colors.deepPurple,
//               ledColor: Colors.deepPurple)
//         ],
//         debug: true);

//     // Get initial notification action is optional
//     initialAction = await AwesomeNotifications()
//         .getInitialNotificationAction(removeFromActionEvents: false);
//   }

//   ///  *********************************************
//   ///     NOTIFICATION EVENTS LISTENER
//   ///  *********************************************
//   ///  Notifications events are only delivered after call this method
//   static Future<void> startListeningNotificationEvents() async {
//     AwesomeNotifications()
//         .setListeners(onActionReceivedMethod: onActionReceivedMethod);
//   }

//   ///  *********************************************
//   ///     NOTIFICATION EVENTS
//   ///  *********************************************
//   ///
//   @pragma('vm:entry-point')
//   static Future<void> onActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     if (receivedAction.actionType == ActionType.SilentAction ||
//         receivedAction.actionType == ActionType.SilentBackgroundAction) {
//       // For background actions, you must hold the execution until the end
//       print(
//           'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
//       await executeLongTaskInBackground();
//     } else {
//       print("hihi");
//       // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
//       //     '/notification-page',
//       //         (route) =>
//       //     (route.settings.name != '/notification-page') || route.isFirst,
//       //     arguments: receivedAction);
//     }
//   }

//   ///  *********************************************
//   ///     REQUESTING NOTIFICATION PERMISSIONS
//   ///  *********************************************
//   ///
//   static Future<bool> displayNotificationRationale() async {
//     bool userAuthorized = false;
//     BuildContext context = Get.context!;
//     await showDialog(
//         context: context,
//         builder: (BuildContext ctx) {
//           return AlertDialog(
//             title: Text('Get Notified!',
//                 style: Theme.of(context).textTheme.titleLarge),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Image.asset(
//                         'assets/animated-bell.gif',
//                         height: MediaQuery.of(context).size.height * 0.3,
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                     'Allow Awesome Notifications to send you beautiful notifications!'),
//               ],
//             ),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(ctx).pop();
//                   },
//                   child: Text(
//                     'Deny',
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleLarge
//                         ?.copyWith(color: Colors.red),
//                   )),
//               TextButton(
//                   onPressed: () async {
//                     userAuthorized = true;
//                     Navigator.of(ctx).pop();
//                   },
//                   child: Text(
//                     'Allow',
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleLarge
//                         ?.copyWith(color: Colors.deepPurple),
//                   )),
//             ],
//           );
//         });
//     return userAuthorized &&
//         await AwesomeNotifications().requestPermissionToSendNotifications();
//   }

//   ///  *********************************************
//   ///     BACKGROUND TASKS TEST
//   ///  *********************************************
//   static Future<void> executeLongTaskInBackground() async {
//     print("starting long task");
//     await Future.delayed(const Duration(seconds: 4));
//     final url = Uri.parse("http://google.com");
//     final re = await http.get(url);
//     print(re.body);
//     print("long task done");
//   }

//   ///  *********************************************
//   ///     NOTIFICATION CREATION METHODS
//   ///  *********************************************
//   ///
//   static Future<void> createNewNotification() async {
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) isAllowed = await displayNotificationRationale();
//     if (!isAllowed) return;
//     await AwesomeNotifications().cancelAll();
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//           // showWhen: true,
//           actionType: ActionType.SilentAction,
//           ticker: "hellou",
//           autoDismissible: true,
//           locked: true,
//           // badge: 2,
//           // progress: 70,
//           id: -1, // -1 is replaced by a random number
//           channelKey: 'alerts',
//           // displayOnForeground: false,
//           fullScreenIntent: true,
//           title: 'Huston! The eagle has landed!',
//           category: NotificationCategory.Progress,
//           body:
//               "A small step for a man, but a giant leap to Flutter's community!",
//           bigPicture:
//               'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
//           largeIcon:
//               'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
//           //'asset://assets/images/balloons-in-sky.jpg',
//           notificationLayout: NotificationLayout.ProgressBar,
//           payload: {
//             'notificationId': '1234567890',
//           }),
//       // actionButtons: [
//       //   NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
//       //   NotificationActionButton(
//       //       key: 'REPLY',
//       //       label: 'Reply Message',
//       //       requireInputText: true,
//       //       actionType: ActionType.SilentAction),
//       //   NotificationActionButton(
//       //       key: 'DISMISS',
//       //       label: 'Dismiss',
//       //       actionType: ActionType.DismissAction,
//       //       isDangerousOption: true)
//       // ]
//     );
//   }
//    static Future<void> createNewNotificationSyscingData() async {
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) isAllowed = await displayNotificationRationale();
//     if (!isAllowed) return;
//     await AwesomeNotifications().cancelAll();
//     await AwesomeNotifications().createNotification(

//       content: NotificationContent(
        
//           showWhen: false,
//           actionType: ActionType.SilentBackgroundAction,
//           ticker: "hellou",
//           autoDismissible: true,
//           locked: true,
//           badge: 2,
//           // progress: 70,
//           id: -1, // -1 is replaced by a random number
//           channelKey: 'alerts',
//           fullScreenIntent: false,
//           title: 'Syscing data',
//           category: NotificationCategory.Workout,
//           body:
//               "A small step for a man, but a giant leap to Flutter's community!",
//               // roundedBigPicture: true,
//           bigPicture:
//               'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
//           largeIcon:
//               'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
//           //'asset://assets/images/balloons-in-sky.jpg',
//           notificationLayout: NotificationLayout.ProgressBar,
//           payload: {
//             'notificationId': '1234567890',
//           }),
//       // actionButtons: [
//       //   NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
//       //   NotificationActionButton(
//       //       key: 'REPLY',
//       //       label: 'Reply Message',
//       //       requireInputText: true,
//       //       actionType: ActionType.SilentAction),
//       //   NotificationActionButton(
//       //       key: 'DISMISS',
//       //       label: 'Dismiss',
//       //       actionType: ActionType.DismissAction,
//       //       isDangerousOption: true)
//       // ]
//     );
//   }

//   static Future<void> scheduleNewNotification() async {
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed) isAllowed = await displayNotificationRationale();
//     if (!isAllowed) return;

//     await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             id: -1, // -1 is replaced by a random number
//             channelKey: 'alerts',
//             title: "Huston! The eagle has landed!",
//             body:
//                 "A small step for a man, but a giant leap to Flutter's community!",
//             bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
//             largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
//             //'asset://assets/images/balloons-in-sky.jpg',
//             notificationLayout: NotificationLayout.BigPicture,
//             payload: {
//               'notificationId': '1234567890'
//             }),
//         actionButtons: [
//           NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
//           NotificationActionButton(
//               key: 'DISMISS',
//               label: 'Dismiss',
//               actionType: ActionType.DismissAction,
//               isDangerousOption: true)
//         ],
//         schedule: NotificationCalendar.fromDate(
//             date: DateTime.now().add(const Duration(seconds: 10))));
//   }

//   static Future<void> resetBadgeCounter() async {
//     await AwesomeNotifications().resetGlobalBadge();
//   }

//   static Future<void> cancelNotifications() async {
//     await AwesomeNotifications().cancelAll();
//   }

//   final localNo.FlutterLocalNotificationsPlugin
//       flutterLocalNotificationsPlugin =
//       localNo.FlutterLocalNotificationsPlugin();
//   int id = 0;
//   Future<void> showProgressNotification() async {
//     id++;
//     final int progressId = id;
//     const int maxProgress = 5;
//     for (int i = 0; i <= maxProgress; i++) {
//       await Future<void>.delayed(const Duration(seconds: 1), () async {
//         final localNo.AndroidNotificationDetails androidNotificationDetails =
//             localNo.AndroidNotificationDetails(
//                 'progress channel', 'progress channel',
//                 channelDescription: 'progress channel description',
//                 channelShowBadge: false,
//                 importance: localNo.Importance.max,
//                 priority: localNo.Priority.high,
//                 onlyAlertOnce: true,
//                 showProgress: true,
//                 maxProgress: maxProgress,
//                 progress: i);
//         final localNo.NotificationDetails notificationDetails =
//             localNo.NotificationDetails(android: androidNotificationDetails);
//         await flutterLocalNotificationsPlugin.show(
//             progressId,
//             'progress notification title',
//             'progress notification body',
//             notificationDetails,
//             payload: 'item x');
//       });
//     }
//   }
// }
