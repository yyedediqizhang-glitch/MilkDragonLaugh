/// Placeholder for the shared network layer described in the workshop.
///
/// Pages and controllers should call this class instead of talking to an HTTP
/// client directly, so that authentication, headers and JSON decoding are
/// written once and reused everywhere.
class NetworkController {
  const NetworkController();

  /// Pretends to ask the server for the latest app version.
  ///
  /// The landing page could use this on start-up to show an "update available"
  /// dialog. Kept as a simple stub for Session 1.
  Future<String> fetchAppVersion() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return '1.0.0';
  }
}
