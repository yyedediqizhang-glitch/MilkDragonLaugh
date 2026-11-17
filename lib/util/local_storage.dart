import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/journal_entry.dart';

/// Thin wrapper around `shared_preferences`.
///
/// This is the only class that talks to the device storage: the journal list, the
/// selected language and the "storage used" calculation all go through here.
class LocalStorage {
  LocalStorage._();

  static final LocalStorage instance = LocalStorage._();

  static const String entriesKey = 'journal_entries_v1';
  static const String languageKey = 'language_code_v1';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  /// Returns `null` the very first time the app runs, an empty list once the
  /// user has cleared the data.
  Future<List<JournalEntry>?> loadEntries() async {
    final SharedPreferences prefs = await _prefs;
    final String? raw = prefs.getString(entriesKey);

    if (raw == null) {
      return null;
    }

    final Object? decoded = jsonDecode(raw);
    if (decoded is! List) {
      return <JournalEntry>[];
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(JournalEntry.fromJson)
        .toList();
  }

  Future<void> saveEntries(List<JournalEntry> entries) async {
    final SharedPreferences prefs = await _prefs;
    final String raw = jsonEncode(
      entries.map((JournalEntry entry) => entry.toJson()).toList(),
    );
    await prefs.setString(entriesKey, raw);
  }

  Future<String?> loadLanguageCode() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(languageKey);
  }

  Future<void> saveLanguageCode(String code) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(languageKey, code);
  }

  /// Real size of what this app stores: the journal JSON (including the base64
  /// image data) plus the saved language.
  Future<int> storageSizeBytes() async {
    final SharedPreferences prefs = await _prefs;
    int total = 0;

    final String? entries = prefs.getString(entriesKey);
    if (entries != null) {
      total += utf8.encode(entriesKey).length + utf8.encode(entries).length;
    }

    final String? language = prefs.getString(languageKey);
    if (language != null) {
      total += utf8.encode(languageKey).length + utf8.encode(language).length;
    }

    return total;
  }

  /// Wipes everything this app stored (entries, photos and preferences).
  Future<void> clearAll() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.clear();
  }
}
