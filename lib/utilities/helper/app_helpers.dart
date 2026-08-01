import 'package:intl/intl.dart';

import '../../core.dart';
import '../global.dart';

//region Date Time Helper
String formatTime({required dynamic time, required String format}) {
  DateTime dateTime;

  // Convert different types to DateTime
  if (time is DateTime) {
    dateTime = time;
  } else if (time is int) {
    // assume timestamp in milliseconds
    dateTime = DateTime.fromMillisecondsSinceEpoch(time);
  } else if (time is String) {
    dateTime = DateTime.tryParse(time) ?? DateTime.now();
  } else {
    throw ArgumentError('Unsupported time type');
  }

  return DateFormat(format).format(dateTime);
}

class DateTimeHelper {
  static DateTime dateParser(String dateTime) {
    DateTime? parsedDate;

    // List of potential date formats to try
    List<String> formats = [
      "yyyy-MM-ddTHH:mm:ssZ", // ISO 8601 with timezone
      "yyyy-MM-ddTHH:mm:ss", // ISO 8601 without timezone
      "yyyy-MM-dd", // Basic date format
      "dd/MM/yyyy", // European format
      "MM/dd/yyyy", // US format
      "d MMMM yyyy", // Full month name
      "d MMM yyyy", // Abbreviated month name
      "yyyy/MM/dd", // Alternative separator
      "dd-MM-yyyy", // Alternative separator
      "MM-dd-yyyy", // Alternative separator
      "MMM d, yyyy", // Short format with abbreviated month
      "MMM d yyyy", // Short format with abbreviated month and no comma
      "yyyy.MM.dd", // Dot separator format
      "dd.MM.yyyy", // Dot separator format
      "MM.dd.yyyy", // Dot separator format
      "dd-MMM-yyyy", // Abbreviated month name with dash
      "MM-MMM-yyyy", // Abbreviated month name with dash
      "yyyyMMdd", // Compact format without separators
      "yyyyMMddHHmmss", // Compact format with time
    ];

    for (String format in formats) {
      try {
        DateFormat dateFormat = DateFormat(format);
        parsedDate = dateFormat.parseStrict(dateTime);
        break;
      } catch (e) {
        // Handle parsing errors
      }
    }

    parsedDate ??= DateTime.now();
    return parsedDate;
  }

  static String getDay(String date) {
    final parsed = DateTime.parse(date);
    return parsed.day.toString().padLeft(2, '0');
  }

  static TimeOfDay parseTime(String timeString) {
    try {
      final format = DateFormat.jm(); // expects formats like "5:30 PM"
      return TimeOfDay.fromDateTime(format.parse(timeString));
    } catch (e) {
      return const TimeOfDay(hour: 0, minute: 0);
    }
  }

  static String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    // "h:mm a" → matches PHP g:i A (12h, no leading zero, uppercase AM/PM)
    return DateFormat("h:mm a").format(dt).toUpperCase();
  }

  static String formatToDayMonth(DateTime dateTime) {
    return DateFormat('EEEE, d MMMM').format(dateTime);
  }

  static String getTimePeriod(TimeOfDay time) {
    final totalMinutes = time.hour * 60 + time.minute;
    if (totalMinutes >= 300 && totalMinutes < 720) {
      return 'morning';
    } else if (totalMinutes >= 720 && totalMinutes < 1020) {
      return 'afternoon';
    } else {
      return 'evening';
    }
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  static String formatDateToString(String dateTime) {
    return DateFormat('dd MMM yyyy').format(dateParser(dateTime));
  }

  static DateTime getFixedDate() {
    return DateTime(2025, 1, 10);
  }

  static String getFormattedFixedDate() {
    DateTime fixedDate = getFixedDate();
    return DateFormat('dd MMM yyyy').format(fixedDate);
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateTime);
  }

  static String dateStringMonthYear(DateTime? dateTime) {
    return DateFormat('d MMM,y').format(dateTime!);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime).toLocal();
  }

  static String localDateToIsoStringAMPM(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime.toLocal());
  }

  static String formatToYearMonthDay(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static String supportTicketDateFormat(DateTime dateTime) {
    return DateFormat('h:mm a dd MMM,yyyy').format(dateTime.toLocal());
  }

  static String localDateToIsoStringAMPMOrder(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, h:mm a ').format(dateTime.toLocal());
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    return DateFormat('HH:mm').format(DateTime.parse(dateTime));
  }

  String formatCurrentTime() {
    final DateTime now = (DateTime.now()).toUtc();
    final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'");
    return formatter.format(now);
  }

  static DateTime parseIso8601ToLocal(String dateTime) {
    try {
      return DateTime.parse(dateTime).toLocal();
    } catch (_) {
      return DateTime.now(); // fallback to avoid crash
    }
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd:MM:yy').format(isoStringToLocalDate(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime.toLocal());
  }

  static String isoStringToLocalDateAndTime(String dateTime) {
    return DateFormat('dd-MMM-yyyy hh:mm a').format(DateTime.parse(dateTime));
  }

  static String dateFormatForWalletBonus(String dateTime) {
    return DateFormat('dd MMM, yyyy').format(parseIso8601ToLocal(dateTime));
  }

  static String dateTimeStringToDateTime(String dateTime) {
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(dateTime));
  }

  static String dateTimeStringToDateAndTime(String dateTime) {
    return DateFormat('hh:mm a, dd MMM yyyy').format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(dateTime));
  }

  static String refundDateTime(String dateTime) {
    return DateFormat('dd MMM yyyy').format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(dateTime));
  }

  static String estimatedDateYear(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  static String inboxLocalDateToIsoStringAMPM(DateTime dateTime) {
    return DateFormat('${_timeFormatter()} | dd-MMM-yyyy ').format(dateTime.toLocal());
  }

  static String _timeFormatter() {
    return 'hh:mm a';
    // return Get.find<SplashController>().configModel.timeformat == '24' ? 'HH:mm' : 'hh:mm a';
  }

  static bool isDateEqualToFixedDate(DateTime dateTime) {
    DateTime fixedDate = getFixedDate();
    return dateTime.year == fixedDate.year && dateTime.month == fixedDate.month && dateTime.day == fixedDate.day;
  }

  static String daysUntilFixedDate(DateTime fromDate) {
    DateTime fixedDate = getFixedDate();
    int daysDifference = fixedDate.difference(fromDate).inDays;
    if (daysDifference > 0) {
      return '$daysDifference days until 10 Jan 2025';
    } else if (daysDifference == 0) {
      return 'Today is 10 Jan 2025';
    } else {
      return '${daysDifference.abs()} days since 10 Jan 2025';
    }
  }

  static String getDateLabel(DateTime input) {
    final now = DateTime.now();
    final localDate = input.toLocal();

    if (isSameDay(localDate, now)) {
      return 'Today';
    } else if (isSameDay(localDate, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      return DateFormat('EEEE, MMMM d').format(localDate);
    }
  }

  static String formatTimeOnly(String dateTime) {
    try {
      final parsed = DateTime.parse(dateTime).toLocal();
      return DateFormat('hh:mm a').format(parsed);
    } catch (_) {
      return "";
    }
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String getDayNameForFixedDate() {
    DateTime fixedDate = getFixedDate();
    return DateFormat('EEEE').format(fixedDate); // e.g., "Friday"
  }

  static String formatTimeWithAmPm(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod; // 0 becomes 12
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  static String customTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime justNow = now.subtract(const Duration(minutes: 1));
    DateTime localDateTime = dateTime.toLocal();

    if (!localDateTime.difference(justNow).isNegative) {
      return 'just now';
    }

    String roughTimeString = DateFormat('jm').format(dateTime);

    if (localDateTime.day == now.day && localDateTime.month == now.month && localDateTime.year == now.year) {
      return roughTimeString;
    }

    DateTime yesterday = now.subtract(const Duration(days: 1));

    if (localDateTime.day == yesterday.day && localDateTime.month == now.month && localDateTime.year == now.year) {
      return 'yesterday';
    }

    if (now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat('EEEE').format(dateTime.toLocal());

      return weekday;
    }

    return localDateToIsoStringAMPM(dateTime);
  }

  static String timeAgo(String inputDate) {
    DateTime currentDate = DateTime.now();
    DateTime parsedDate = DateTime.parse(inputDate);

    Duration difference = currentDate.difference(parsedDate);
    int hoursDifference = difference.inHours;
    int minutesDifference = difference.inMinutes;
    int daysDifference = difference.inDays;

    if (daysDifference > 7) {
      // Show the date in a readable format if it's more than a week ago
      return DateFormat('MM/dd/yyyy').format(parsedDate);
    } else if (daysDifference >= 2) {
      return '$daysDifference days ago';
    } else if (daysDifference == 1) {
      return 'Yesterday';
    } else if (hoursDifference >= 1) {
      return '$hoursDifference${hoursDifference == 1 ? ' hour' : ' hours'} ago';
    } else if (minutesDifference >= 1) {
      return '$minutesDifference${minutesDifference == 1 ? ' minute' : ' minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
//endregion Date Time Helper

//region Text Size Helper
class TextSizeHelper {
  TextSizeHelper._();
  static TextStyle size28() => Theme.of(Global.navigatorKey.currentContext!).textTheme.displayLarge!;
  static TextStyle size26() => Theme.of(Global.navigatorKey.currentContext!).textTheme.displayMedium!;
  static TextStyle size24() => Theme.of(Global.navigatorKey.currentContext!).textTheme.displaySmall!;
  static TextStyle size22() => Theme.of(Global.navigatorKey.currentContext!).textTheme.headlineLarge!;
  static TextStyle size20() => Theme.of(Global.navigatorKey.currentContext!).textTheme.headlineMedium!;
  static TextStyle size18() => Theme.of(Global.navigatorKey.currentContext!).textTheme.headlineSmall!;
  static TextStyle size16() => Theme.of(Global.navigatorKey.currentContext!).textTheme.titleLarge!;
  static TextStyle size15() => Theme.of(Global.navigatorKey.currentContext!).textTheme.titleMedium!;
  static TextStyle size14() => Theme.of(Global.navigatorKey.currentContext!).textTheme.titleSmall!;
  static TextStyle size13() => Theme.of(Global.navigatorKey.currentContext!).textTheme.bodyLarge!;
  static TextStyle size12() => Theme.of(Global.navigatorKey.currentContext!).textTheme.bodyMedium!;
  static TextStyle size11() => Theme.of(Global.navigatorKey.currentContext!).textTheme.bodySmall!;
  static TextStyle size10() => Theme.of(Global.navigatorKey.currentContext!).textTheme.labelLarge!;
  static TextStyle size9() => Theme.of(Global.navigatorKey.currentContext!).textTheme.labelMedium!;
  static TextStyle size8() => Theme.of(Global.navigatorKey.currentContext!).textTheme.labelSmall!;
}

//endregion Text Size Helper
