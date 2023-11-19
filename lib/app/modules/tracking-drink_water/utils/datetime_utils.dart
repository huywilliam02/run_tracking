import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/drinkWaterReminder/models/Preference.dart';
import 'package:tracker_run/app/modules/tracking-drink_water/drinkWaterReminder/utils/Constant.dart';

class DateTimeUtils {
  static List<DateTime> getSartAndEndDayOfWeek() {
    DateTime now = DateTime.now();
    DateTime start = now.subtract(Duration(days: now.weekday - 1));
    DateTime end = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));

    return [
      start,
      end,
    ];
  }

  static List<DateTime> getSartAndEndmouth() {
    DateTime now = DateTime.now();
    DateTime firstDayCurrentMonth =
        DateTime.utc(DateTime.now().year, DateTime.now().month, 1);

    DateTime lastDayCurrentMonth = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month + 1,
    ).subtract(const Duration(days: 1));

    return [firstDayCurrentMonth, lastDayCurrentMonth];
  }

  static String dateTimeString(DateTime dateTime, String format) {
    return DateFormat(format).format(dateTime);
  }

  static bool isToday(DateTime dateTime) {
    DateTime now = DateTime.now();
    return now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;
  }

  static String nameOfDay(DateTime dateTime) =>
      DateFormat('E').format(dateTime);

  static String mouth(DateTime dateTime) => DateFormat('LLL').format(dateTime);

  static bool compareYMD(DateTime dateTime1, DateTime dateTime2) {
    dateTime1 = DateTime(dateTime1.year, dateTime1.month, dateTime1.day);
    dateTime2 = DateTime(dateTime2.year, dateTime2.month, dateTime2.day);

    return dateTime1 == dateTime2;
  }

  static bool compareYMDMouth(DateTime dateTime1, DateTime dateTime2) {
    dateTime1 = DateTime(
      dateTime1.year,
      dateTime1.month,
    );
    dateTime2 = DateTime(
      dateTime2.year,
      dateTime2.month,
    );

    return dateTime1 == dateTime2;
  }

  static DateTime dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static String timeTo12HourFormatString(TimeOfDay time) {
    return '${time.hourOfPeriod}:${time.minute.toString().length == 1 ? "0${time.minute.toString()}" : time.minute} ${time.period.name.toUpperCase()}';
  }
}



class Utils {
  static getCurrentDateTime() {
    DateTime dateTime = DateTime.now();
    return "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString()}-${dateTime.minute.toString()}-${dateTime.second.toString()}";
  }

  static getCurrentDate() {
    return "${DateFormat.yMd().format(DateTime.now())}";
  }

  static getCurrentDayTime() {
    return "${DateFormat.jm().format(DateTime.now())}";
  }

  static double lbToKg(double weightValue) {
    return double.parse((weightValue / 2.2046226218488).toStringAsFixed(1));
  }

  static double kgToLb(double weightValue) {
    return double.parse((weightValue * 2.2046226218488).toStringAsFixed(1));
  }

  static int daysInMonth(final int monthNum, final int year) {
    List<int> monthLength = List.filled(12, 0, growable: true);

    monthLength[0] = 31;
    monthLength[2] = 31;
    monthLength[4] = 31;
    monthLength[6] = 31;
    monthLength[7] = 31;
    monthLength[9] = 31;
    monthLength[11] = 31;
    monthLength[3] = 30;
    monthLength[8] = 30;
    monthLength[5] = 30;
    monthLength[10] = 30;

    if (leapYear(year) == true)
      monthLength[1] = 29;
    else
      monthLength[1] = 28;

    return monthLength[monthNum - 1];
  }

  static bool leapYear(int year) {
    bool leapYear = false;

    bool leap = ((year % 100 == 0) && (year % 400 != 0));
    if (leap == true)
      leapYear = false;
    else if (year % 4 == 0) leapYear = true;

    return leapYear;
  }

  static String secToString(int sec) {
    var formatter = NumberFormat("00");
    var p1 = sec % 60;
    var p2 = sec / 60;
    var p3 = p2 % 60;
    p2 /= 60;

    return formatter.format(p2) +
        ":" +
        formatter.format(p3) +
        ":" +
        formatter.format(p1);
  }

  static double mileToKm(double mile) {
    double km = mile * 1.609;

    return km;
  }

  static double kmToMile(double km) {
    double mile = km / 1.609;

    return mile;
  }

  static double minPerKmToMinPerMile(double speedInKm) {
    double speedInmMile = speedInKm * 1.609;

    return speedInmMile;
  }

  static double calculationForHeartHealthGraph(
      int walkTime, int runTime, int targetWalkTime, int targetRunTime) {
    double walkTimeInMin = Utils.secToMin(walkTime);
    double runTimeInMin = Utils.secToMin(runTime);
    double avgWalk = (100 * walkTimeInMin) / targetWalkTime;
    double avgRun = (100 * runTimeInMin) / targetRunTime;
    double total = (avgWalk + avgRun) / 2;

    return total;
  }

  static double secToHour(int sec) {
    double hrs = sec / 3600;
    return hrs;
  }

  static double secToMin(int sec) {
    double mins = sec / 60;
    return mins;
  }

  static String getIntervalString(BuildContext context, int min) {
    switch (min) {
      case 30:
        return "30 phút một lần";
      case 60:
        return "1 giờ một lần";
      case 90:
        return "1 giờ 30 phút một lần";
      case 120:
        return "2 giờ một lần";
      case 150:
        return "Cứ 2,5 giờ một lần";
      case 180:
        return "3 giờ một lần";
      case 210:
        return "Cứ 3,5 giờ một lần";
      case 240:
        return "4 giờ một lần";
      default:
        return "";
    }
  }

  static nonPersonalizedAds() {
    if (Platform.isIOS) {
      if (Preference.shared.getString(Preference.TRACK_STATUS) !=
          Constant.trackingStatus) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
