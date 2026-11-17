import 'package:flutter/foundation.dart';

/// Controller of the settings page.
///
/// Settings are intentionally minimal in Session 2 – the workshop fills this
/// page in during the later sessions.
class SettingPageController extends ChangeNotifier {
  static const String appVersion = '1.0.0';

  String get appName => 'EDU SNAP';

  String get buildInfo => 'Session 2 · lifecycle, list, add, detail';
}
