import 'package:flutter/foundation.dart';

import '../models/journal_entry.dart';

/// In-memory data source shared by every page.
///
/// Controllers talk to this repository instead of owning duplicate lists, so a
/// new entry added on the add page shows up on the home page and on the detail
/// page without any manual wiring.
class JournalRepository extends ChangeNotifier {
  JournalRepository._();

  static final JournalRepository instance = JournalRepository._();

  final List<JournalEntry> _entries = _seedEntries();

  List<JournalEntry> get entries => List<JournalEntry>.unmodifiable(_entries);

  static List<JournalEntry> _seedEntries() {
    final DateTime now = DateTime.now();

    return <JournalEntry>[
      JournalEntry(
        id: 'seed-1',
        title: 'Welcome to EDU SNAP',
        notes:
            'This is a demo journal entry. Tap it to open the detail page, or '
            'swipe it to the left to delete it.',
        createdAt: now,
        updatedAt: now,
      ),
      JournalEntry(
        id: 'seed-2',
        title: 'Session 1 recap',
        notes:
            'Set up Flutter, created the EDU SNAP project and organised the '
            'MVC folders: models, components, pages and util.',
        createdAt: now,
        updatedAt: now,
      ),
      JournalEntry(
        id: 'seed-3',
        title: 'Ideas for the journal app',
        notes:
            'Add an edit button, a settings page, and later on local storage '
            'so the entries survive an app restart.',
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

  void add({required String title, required String notes}) {
    final DateTime now = DateTime.now();

    _entries.add(
      JournalEntry(
        id: now.microsecondsSinceEpoch.toString(),
        title: title.trim(),
        notes: notes.trim(),
        createdAt: now,
        updatedAt: now,
      ),
    );

    sortByTitleDescending();
  }

  void update(String id, {required String title, required String notes}) {
    final int index = _entries.indexWhere((JournalEntry entry) => entry.id == id);
    if (index == -1) {
      return;
    }

    _entries[index] = _entries[index].copyWith(
      title: title.trim(),
      notes: notes.trim(),
      updatedAt: DateTime.now(),
    );

    sortByTitleDescending();
  }

  void remove(String id) {
    _entries.removeWhere((JournalEntry entry) => entry.id == id);
    notifyListeners();
  }

  /// Restores the demo data so widget tests start from a known state.
  @visibleForTesting
  void reset() {
    _entries
      ..clear()
      ..addAll(_seedEntries());
    sortByTitleDescending();
  }
}
