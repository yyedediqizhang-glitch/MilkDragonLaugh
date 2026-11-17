/// Small shared helpers, the "util" layer of this MVC project.
library;

const List<String> _months = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Formats a [DateTime] into something readable, e.g. `Oct 27, 2026 · 6:16 PM`.
///
/// The workshop used this as the example of a util script: a tiny function that
/// would otherwise be duplicated in several pages.
String formatDateTime(DateTime value) {
  final DateTime local = value.toLocal();
  final int hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final String minute = local.minute.toString().padLeft(2, '0');
  final String period = local.hour < 12 ? 'AM' : 'PM';

  return '${_months[local.month - 1]} ${local.day}, ${local.year} '
      '· $hour12:$minute $period';
}

/// Formats [DateTime] into a short time only string, e.g. `6:16 PM`.
String formatTime(DateTime value) {
  final DateTime local = value.toLocal();
  final int hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final String minute = local.minute.toString().padLeft(2, '0');
  final String period = local.hour < 12 ? 'AM' : 'PM';
  return '$hour12:$minute $period';
}
