import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:tracker_run/app/modules/tracking-drink_water/drinkWaterReminder/utils/Constant.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/drinkWaterReminder/utils/Debug.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/drinkWaterReminder/models/Preference.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/utils/datetime_utils.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/views/views.dart';
import 'package:tracker_run/app/resources/app_constants.dart';

import '../../../../../main.dart';

class DrinkWaterReminderScreen extends StatefulWidget {
  @override
  _DrinkWaterReminderScreenState createState() =>
      _DrinkWaterReminderScreenState();
}

class _DrinkWaterReminderScreenState extends State<DrinkWaterReminderScreen> {
  bool isNotification = false;
  int dropdownIntervalValue = 30;

  String? _hour, _minute, _time;
  TextEditingController _timeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _notificationMSgController = TextEditingController();

  String? prefStartTimeValue;
  String? prefEndTimeValue;
  String? prefNotiMsg;

  // late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    _getPreference();
    // _loadBanner();
    super.initState();
  }

  _getPreference() {
    prefStartTimeValue =
        Preference.shared.getString(Preference.START_TIME_REMINDER);
    prefEndTimeValue =
        Preference.shared.getString(Preference.END_TIME_REMINDER);
    prefNotiMsg = Preference.shared
        .getString(Preference.DRINK_WATER_NOTIFICATION_MESSAGE);
    isNotification =
        Preference.shared.getBool(Preference.IS_REMINDER_ON) ?? false;

    dropdownIntervalValue =
        Preference.shared.getInt(Preference.DRINK_WATER_INTERVAL) ?? 30;
    setState(() {
      if (prefStartTimeValue == null) {
        _startTimeController.text = "08:00 AM";
        prefStartTimeValue = "08:00";
      } else {
        var hr = int.parse(prefStartTimeValue!.split(":")[0]);
        var min = int.parse(prefStartTimeValue!.split(":")[1]);
        _startTimeController.text =
            DateFormat.jm().format(DateTime(2021, 08, 1, hr, min));
      }
      if (prefEndTimeValue == null) {
        _endTimeController.text = "11:00 PM";
        prefEndTimeValue = "23:00";
      } else {
        var hr = int.parse(prefEndTimeValue!.split(":")[0]);
        var min = int.parse(prefEndTimeValue!.split(":")[1]);
        _endTimeController.text =
            DateFormat.jm().format(DateTime(2021, 08, 1, hr, min));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    if (_notificationMSgController.text.isEmpty) {
      _notificationMSgController.text = prefNotiMsg ?? "Đã đến lúc uống nước";
    }
    return WillPopScope(
      onWillPop: () async {
        showSaveChangeDialog();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colur.common_bg_dark,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: ColorConstant.progress_background_color,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.to(() => TrackingDrinkWaterView());
            },
          ),
          title: Text("Nhắc nhở uống nước"),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                showSaveChangeDialog();
              },
            )
          ],
        ),
        body: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: _notificationRadioButton(
                        context, fullWidth, fullHeight),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _notificationRadioButton(
      BuildContext context, double fullWidth, double fullHeight) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Thông báo",
                style: TextStyle(
                    color: Colur.txt_white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              Expanded(child: Container()),
              buildSwitch(),
            ],
          ),
          buildDivider(),
          buildTitleText(fullWidth, fullHeight, context, "Lịch trình"),
          InkWell(
            onTap: () {
              var hr = int.parse(prefStartTimeValue!.split(":")[0]);
              var min = int.parse(prefStartTimeValue!.split(":")[1]);

              TimeOfDay _startTime = TimeOfDay(hour: hr, minute: min);
              _selectTime(context, "START", _startTime);
            },
            child: Container(
              margin: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: [
                  Text(
                    "Bắt Đầu",
                    style: TextStyle(
                        color: Colur.txt_white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Expanded(child: Container()),
                  Text(
                    _startTimeController.text,
                    style: TextStyle(
                        color: Colur.txt_white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colur.white,
                    size: 20,
                  )
                ],
              ),
            ),
          ),
          buildDivider(),
          InkWell(
            onTap: () {
              var hr = int.parse(prefEndTimeValue!.split(":")[0]);
              var min = int.parse(prefEndTimeValue!.split(":")[1]);

              TimeOfDay _endTime = TimeOfDay(hour: hr, minute: min);
              _selectTime(context, "END", _endTime);
            },
            child: Container(
              margin: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: [
                  Text(
                    "Kết thúc",
                    style: TextStyle(
                        color: Colur.txt_white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Expanded(child: Container()),
                  Text(
                    _endTimeController.text,
                    style: TextStyle(
                        color: Colur.txt_white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colur.white,
                    size: 20,
                  )
                ],
              ),
            ),
          ),
          buildDivider(),
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Thời gian thông báo",
                  style: TextStyle(
                      color: Colur.txt_white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              _intervalDropdown(context),
            ],
          ),
          buildDivider(),
          buildTitleText(fullWidth, fullHeight, context, "Thông điệp"),
          _buildTextField(context, fullWidth, fullHeight),
        ],
      ),
    );
  }

  _buildTextField(BuildContext context, double fullWidth, double fullHeight) {
    return Container(
      child: TextFormField(
        maxLines: 1,
        textInputAction: TextInputAction.done,
        controller: _notificationMSgController,
        keyboardType: TextInputType.text,
        style: TextStyle(
            color: Colur.txt_white, fontSize: 18, fontWeight: FontWeight.w500),
        cursorColor: Colur.txt_grey,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Future<void> _selectTime(
      BuildContext context, String s, TimeOfDay selectedTime) async {
    final TimeOfDay picked = (await showTimePicker(
      context: context,
      initialTime: selectedTime,
    ))!;
    setState(() {
      selectedTime = picked;
      _hour = selectedTime.hour.toString();
      _minute = selectedTime.minute.toString();
      _time = _hour! + ' : ' + _minute!;
      _timeController.text = _time!;
      if (s == "START") {
        _startTimeController.text = DateFormat.jm().format(
            DateTime(2021, 08, 1, selectedTime.hour, selectedTime.minute));

        if (selectedTime.hour > int.parse(prefEndTimeValue!.split(":")[0])) {
          _endTimeController.text = DateFormat.jm().format(DateTime(
              2021, 08, 1, selectedTime.hour + 1, selectedTime.minute));
          var newtime = (selectedTime.hour + 1).toString() +
              ' : ' +
              (selectedTime.minute).toString();
          prefEndTimeValue = newtime;
        }

        prefStartTimeValue = _time!;
      } else {
        _endTimeController.text = DateFormat.jm().format(
            DateTime(2021, 08, 1, selectedTime.hour, selectedTime.minute));
        if (int.parse(prefStartTimeValue!.split(":")[0]) > selectedTime.hour) {
          _startTimeController.text = DateFormat.jm().format(DateTime(
              2021, 08, 1, selectedTime.hour - 1, selectedTime.minute));
          print(
              "${int.parse(prefStartTimeValue!.split(":")[0])}::::::${selectedTime.hour}");
          var newtime = (selectedTime.hour + 1).toString() +
              ' : ' +
              (selectedTime.minute).toString();
          prefStartTimeValue = newtime;
        }
        prefEndTimeValue = _time!;
      }
    });
  }

  buildTitleText(
      double fullWidth, double fullHeight, BuildContext context, String title) {
    return Container(
      alignment: Alignment.centerLeft,
      margin:
          EdgeInsets.only(top: fullHeight * 0.02, bottom: fullHeight * 0.02),
      child: Text(
        title,
        style: TextStyle(
            color: Colur.txt_grey, fontWeight: FontWeight.w400, fontSize: 14),
      ),
    );
  }

  buildDivider() {
    return Divider(
      color: Colur.txt_grey,
    );
  }

  buildSwitch() {
    return Switch(
      onChanged: (bool value) async {
        var status = await Permission.notification.status;
        if (status.isDenied) {
          await Permission.notification.request();
        }

        if (status.isPermanentlyDenied) {
          openAppSettings();
        }

        if (isNotification == false) {
          setState(() {
            isNotification = true;
          });
        } else {
          setState(() {
            isNotification = false;
          });
        }
      },
      value: isNotification,
      activeColor: Colur.purple_gradient_color2,
      inactiveTrackColor: Colur.txt_grey,
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.STR_BACK) {
      showSaveChangeDialog();
    }
  }

  _intervalDropdown(BuildContext context) {
    return DropdownButton(
        value: dropdownIntervalValue,
        iconDisabledColor: Colur.white,
        iconEnabledColor: Colur.white,
        underline: Container(
          color: Colur.transparent,
        ),
        dropdownColor: Colur.common_bg_dark,
        items: [
          DropdownMenuItem(
            value: 30,
            child: Text(Utils.getIntervalString(context, 30),
                style: _commonTextStyle()),
          ),
          DropdownMenuItem(
            value: 60,
            child: Text(Utils.getIntervalString(context, 60),
                style: _commonTextStyle()),
          ),
          DropdownMenuItem(
            value: 90,
            child: Text(Utils.getIntervalString(context, 90),
                style: _commonTextStyle()),
          ),
          DropdownMenuItem(
            value: 120,
            child: Text(Utils.getIntervalString(context, 120),
                style: _commonTextStyle()),
          ),
          DropdownMenuItem(
            value: 150,
            child: Text(Utils.getIntervalString(context, 150),
                style: _commonTextStyle()),
          ),
          DropdownMenuItem(
              value: 180,
              child: Text(Utils.getIntervalString(context, 180),
                  style: _commonTextStyle())),
          DropdownMenuItem(
              value: 210,
              child: Text(Utils.getIntervalString(context, 210),
                  style: _commonTextStyle())),
          DropdownMenuItem(
              value: 240,
              child: Text(Utils.getIntervalString(context, 240),
                  style: _commonTextStyle())),
        ],
        onChanged: (val) {
          setState(() {
            dropdownIntervalValue = val as int;
          });
        });
  }

  _commonTextStyle() {
    return TextStyle(
        color: Colur.txt_white, fontSize: 17, fontWeight: FontWeight.w400);
  }

  setWaterReminder() async {
    var titleText = "Thời gian để uống nước";
    var msg = _notificationMSgController.text;
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    List<PendingNotificationRequest> pendingNoti =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    pendingNoti.forEach((element) {
      if (element.payload != Constant.STR_RUNNING_REMINDER) {
        Debug.printLog("Cancele Notification ::::::==> ${element.id}");
        flutterLocalNotificationsPlugin.cancel(element.id);
      }
    });

    tz.TZDateTime startTime = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day,
            int.parse(prefStartTimeValue!.split(":")[0]),
            int.parse(prefStartTimeValue!.split(":")[1]))
        .toLocal();
    tz.TZDateTime endTime = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day,
            int.parse(prefEndTimeValue!.split(":")[0]),
            int.parse(prefEndTimeValue!.split(":")[1]))
        .toLocal();

    scheduledNotification(
        tz.TZDateTime scheduledDate, int notificationId) async {
      Debug.printLog(
          "Schedule Notification at ::::::==> id= $notificationId ${scheduledDate}");
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId,
          titleText,
          msg,
          scheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
                'drink_water_reminder', 'Drink Water',
                channelDescription:
                    'This is reminder for drinking water on time',
                icon: '@mipmap/ic_launcher'),
            // iOS: IOSNotificationDetails(),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: scheduledDate.millisecondsSinceEpoch.toString());
    }

    var interVal = dropdownIntervalValue;
    var notificationId = 1;
    while (startTime.isBefore(endTime)) {
      tz.TZDateTime newScheduledDate = startTime;
      if (newScheduledDate.isBefore(now)) {
        newScheduledDate = newScheduledDate.add(const Duration(days: 1));
      }
      await scheduledNotification(newScheduledDate, notificationId);
      notificationId += 1;
      startTime = startTime.add(Duration(minutes: interVal));
    }
  }

  void showSaveChangeDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Bạn chắc chắn chứ"),
            actions: [
              TextButton(
                child: Text("Thoát"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Lưu"),
                onPressed: () async {
                  Preference.shared.setString(
                      Preference.END_TIME_REMINDER, prefEndTimeValue!);
                  Preference.shared.setString(
                      Preference.START_TIME_REMINDER, prefStartTimeValue!);
                  Preference.shared.setString(
                      Preference.DRINK_WATER_NOTIFICATION_MESSAGE,
                      _notificationMSgController.text);
                  Preference.shared
                      .setBool(Preference.IS_REMINDER_ON, isNotification);
                  Preference.shared.setInt(
                      Preference.DRINK_WATER_INTERVAL, dropdownIntervalValue);
                  if (isNotification)
                    setWaterReminder();
                  else {
                    List<PendingNotificationRequest> pendingNoti =
                        await flutterLocalNotificationsPlugin
                            .pendingNotificationRequests();

                    pendingNoti.forEach((element) {
                      if (element.payload != Constant.STR_RUNNING_REMINDER) {
                        Debug.printLog(
                            "Cancele Notification ::::::==> ${element.id}");
                        flutterLocalNotificationsPlugin.cancel(element.id);
                      }
                    });
                  }
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
