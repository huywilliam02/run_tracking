import 'package:intl/intl.dart';

enum MyDateFormat {
  ddMMMyyyhhmm,
}

extension MyDateFormatExt on MyDateFormat {
  String _getType() {
    switch (this) {
      case MyDateFormat.ddMMMyyyhhmm:
        return 'dd MMM yyyy hh:mm';
    }
  }

  String format(DateTime date) {
    return DateFormat(
      _getType(),
    ).format(date);
  }

  String formatString(String? date) {
    if (date != null && date.isNotEmpty) {
      var parsedDate = DateTime.tryParse(date);
      if (parsedDate != null) {
        return format(parsedDate);
      }
    }
    return '';
  }

  static DateTime? parseDate(String? formattedString) {
    if (formattedString != null) {
      return DateTime.tryParse(formattedString);
    }
    return null;
  }
}
