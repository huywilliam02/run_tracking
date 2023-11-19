

class CalculateUtils {
  static double getAveragePace(
      List<double>? paceRecord, int? startIndex, int? endIndex) {
    double rs = 0;
    for (var i = startIndex; i! <= endIndex!; i++) {
      rs = rs + paceRecord![i];
    }
    return (rs / (endIndex - startIndex! + 1));
  }

  static double getAverageElevation(
      List<double>? elevaRecord, int? startIndex, int? endIndex) {
    double rs = 0;
    for (var i = startIndex; i! <= endIndex!; i++) {
      rs = rs + elevaRecord![i];
    }
    return (rs / (endIndex - startIndex! + 1));
  }

  static String changeToMinutesSecond(double minute) {
    int minuteRs = minute.floor();
    double tmp = minute - minuteRs.toDouble();

    int secondRs = (tmp * 60).round();
    String minuteStr = "$minuteRs";
    String secondStr = "$secondRs";
    if (minuteRs < 10) {
      minuteStr = "0$minuteRs";
    }
    if (secondRs < 10) {
      secondStr = "0$secondRs";
    }
    return "$minuteStr:$secondStr";
  }

 static String calculatePage(int movingTime, double distance) {
   String averagePage = "00:00";
  try {
     
    double abc = ((movingTime / 60) / (distance / 1000));

    int minute = abc.truncate();

    int secondd = ((abc - minute) * 60).round();
    if (secondd < 10) {
      averagePage = "${minute}:0${secondd}";
    } else {
      averagePage = "${minute}:${secondd}";
    }
    return averagePage;
  } catch (e) {
    return averagePage;
  }
  }
}
