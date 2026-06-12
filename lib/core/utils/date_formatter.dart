import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final _dateFormatter = DateFormat('dd MMM yyyy');
  static final _timeFormatter = DateFormat('hh:mm a');
  static final _monthFormatter = DateFormat('MMMM yyyy');
  static final _shortDateFormatter = DateFormat('dd MMM');

  static String formatDate(DateTime date) => _dateFormatter.format(date);
  static String formatTime(DateTime date) => _timeFormatter.format(date);
  static String formatMonth(DateTime date) => _monthFormatter.format(date);
  static String formatShort(DateTime date) => _shortDateFormatter.format(date);

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return formatShort(date);
  }
}
