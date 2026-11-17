import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/journal_entry.dart';
import 'local_storage.dart';

/// In-memory journal shared by every page, mirrored into local storage.
///
/// Controllers talk to this repository instead of owning duplicate lists, so an
/// entry created on the add page shows up on the home page, the detail page and
/// survives an app restart (Session 3).
class JournalRepository extends ChangeNotifier {
  JournalRepository._();

  static final JournalRepository instance = JournalRepository._();

  final List<JournalEntry> _entries = <JournalEntry>[];

  List<JournalEntry> get entries => List<JournalEntry>.unmodifiable(_entries);

  /// Loads the journal from local storage.
  ///
  /// A fresh install starts with an empty journal, as requested in Session 3:
  /// the home page then shows the "journal is empty" hint.
  Future<void> load() async {
    final List<JournalEntry>? stored = await LocalStorage.instance
        .loadEntries();

    _entries
      ..clear()
      ..addAll(stored ?? const <JournalEntry>[]);

    sortByTitleDescending();
  }

  static List<JournalEntry> _seedEntries() {
    final DateTime now = DateTime.now();

    return <JournalEntry>[
      JournalEntry(
        id: 'seed-1',
        title: 'Welcome to EDU SNAP',
        notes:
            'This is a demo entry. Tap it to open the detail page, swipe it to '
            'delete it, or use the pencil to edit it.',
        createdAt: now,
        updatedAt: now,
      ),
      JournalEntry(
        id: 'seed-2',
        title: 'Session 3 notes',
        notes:
            'Camera and gallery permissions, local storage with '
            'shared_preferences, and multi-language support.',
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  JournalEntry? findById(String id) {
    for (final JournalEntry entry in _entries) {
      if (entry.id == id) {
        return entry;
      }
    }
    return null;
  }

  /// Sorts by title in descending order.
  ///
  /// Called once when the home page is created (initState) and again after an
  /// entry is created or updated.
  void sortByTitleDescending() {
    _entries.sort(
      (JournalEntry a, JournalEntry b) =>
          b.title.toLowerCase().compareTo(a.title.toLowerCase()),
    );
    notifyListeners();
  }

  void add({
    required String title,
    required String notes,
    String? imageBase64,
  }) {
    final DateTime now = DateTime.now();

    _entries.add(
      JournalEntry(
        id: now.microsecondsSinceEpoch.toString(),
        title: title.trim(),
        notes: notes.trim(),
        createdAt: now,
        updatedAt: now,
        imageBase64: imageBase64,
      ),
    );

    sortByTitleDescending();
    unawaited(_persist());
  }

  void update(
    String id, {
    required String title,
    required String notes,
    String? imageBase64,
    bool removeImage = false,
  }) {
    final int index = _entries.indexWhere(
      (JournalEntry entry) => entry.id == id,
    );
    if (index == -1) {
      return;
    }

    _entries[index] = _entries[index].copyWith(
      title: title.trim(),
      notes: notes.trim(),
      updatedAt: DateTime.now(),
      imageBase64: imageBase64,
      removeImage: removeImage,
    );

    sortByTitleDescending();
    unawaited(_persist());
  }

  void remove(String id) {
    _entries.removeWhere((JournalEntry entry) => entry.id == id);
    notifyListeners();
    unawaited(_persist());
  }

  /// Deletes every entry, photo and preference stored by the app.
  Future<void> clearAll() async {
    _entries.clear();
    await LocalStorage.instance.clearAll();
    notifyListeners();
  }

  Future<void> _persist() => LocalStorage.instance.saveEntries(_entries);

  /// Restores the demo data so widget tests start from a known state.
  @visibleForTesting
  Future<void> reset() async {
    _entries
      ..clear()
      ..addAll(_seedEntries());
    sortByTitleDescending();
    await _persist();
  }
}
