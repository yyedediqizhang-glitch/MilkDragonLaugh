import 'package:flutter/foundation.dart';

import '../../models/journal_entry.dart';
import '../../util/journal_repository.dart';

/// Controller of the add page.
///
/// The same page is reused for editing: when [entry] is not null the fields are
/// pre-filled and saving updates the existing entry instead of creating one.
class AddPageController extends ChangeNotifier {
  AddPageController({this.entry});

  final JournalEntry? entry;

  String? _titleError;

  bool get isEditing => entry != null;

  String? get titleError => _titleError;

  /// Required-field validation, triggered by the Save button.
  bool validate({required String title}) {
    if (title.trim().isEmpty) {
      _titleError = 'Title is required';
      notifyListeners();
      return false;
    }

    _titleError = null;
    notifyListeners();
    return true;
  }

  /// Creates the entry, or updates it when the page is in edit mode.
  void save({required String title, required String notes}) {
    final JournalRepository repository = JournalRepository.instance;

    if (entry == null) {
      repository.add(title: title, notes: notes);
    } else {
      repository.update(entry!.id, title: title, notes: notes);
    }
  }
}
