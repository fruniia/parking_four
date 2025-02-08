import 'package:intl/intl.dart';

DateTime convertUtcToLocalTime(DateTime utcDateTime) {
  return utcDateTime.toLocal();
}

String formatTime(DateTime? time) {
  if (time == null) {
    return 'No time available';
  }
  DateTime formattedLocalTime = convertUtcToLocalTime(time);
  return DateFormat('HH:mm:ss').format(formattedLocalTime);
}

String formatDate(DateTime? eventDate) {
  if (eventDate == null) {
    return 'No date available';
  }
  DateTime formattedLocalTime = convertUtcToLocalTime(eventDate);
  return DateFormat('yyyy-MM-dd').format(formattedLocalTime);
}

String formatDateAndTime(DateTime? eventDateTime) {
  if (eventDateTime == null) {
    return 'No date and time available';
  }
  DateTime formattedLocalTime = convertUtcToLocalTime(eventDateTime);
  return DateFormat('yyyy-MM-dd HH:mm').format(formattedLocalTime);
}
