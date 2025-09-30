class DateTimeHelper {
  static String nowUtcIso() {
    return DateTime.now().toUtc().toIso8601String();
  }

  static DateTime fromIsoToLocal(String isoString) {
    return DateTime.parse(isoString).toLocal();
  }

  static String toUtcIso(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }

  static String currentTimeZoneOffset() {
    final offset = DateTime.now().timeZoneOffset;
    final hours = offset.inHours;
    final minutes = offset.inMinutes.remainder(60);
    final sign = hours >= 0 ? '+' : '-';
    return '$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  static String currentTimeZoneName() {
    return DateTime.now().timeZoneName;
  }

  static DateTime toUtcDateTime(DateTime dateTime) {
    return dateTime.toUtc();
  }

  static DateTime toLocalDateTime(DateTime dateTime) {
    return dateTime.toLocal();
  }
}
