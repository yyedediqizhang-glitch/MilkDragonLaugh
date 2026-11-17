import 'package:intl/intl.dart';

/// Formats a [DateTime] for the given locale, e.g.
/// `Nov 17, 2026, 9:36 PM` in English or `2026年11月17日 下午9:36` in Chinese.
///
/// A utility script: the same formatting is used by the list, the detail page
/// and the settings page.
String formatDateTime(DateTime value, String localeName) {
  final DateFormat formatter = DateFormat.yMMMd(
    localeName,
  ).add_jm();
  return formatter.format(value.toLocal());
}
