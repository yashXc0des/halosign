import 'package:intl/intl.dart';

/// Utility functions for date and time operations.
class DateTimeUtils {
  /// Formats a DateTime object into a readable string.
  static String formatDateTime(DateTime dateTime, {String format = "yyyy-MM-dd HH:mm:ss"}) {
    return DateFormat(format).format(dateTime);
  }

  /// Parses a string into a DateTime object.
  static DateTime? parseDateTime(String dateTimeStr, {String format = "yyyy-MM-dd HH:mm:ss"}) {
    try {
      return DateFormat(format).parse(dateTimeStr);
    } catch (e) {
      return null;
    }
  }

  /// Returns a human-readable relative time string.
  static String timeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);

    if (duration.inSeconds < 60) {
      return '${duration.inSeconds} seconds ago';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes} minutes ago';
    } else if (duration.inHours < 24) {
      return '${duration.inHours} hours ago';
    } else {
      return '${duration.inDays} days ago';
    }
  }
}
