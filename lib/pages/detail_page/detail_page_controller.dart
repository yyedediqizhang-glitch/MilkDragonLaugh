import 'package:flutter/foundation.dart';

import '../../models/journal_entry.dart';
import '../../util/journal_repository.dart';

/// Controller of the detail page: watches one entry in the repository.
class DetailPageController extends ChangeNotifier {
  DetailPageController({required this.entryId}) {
    JournalRepository.instance.addListener(_onRepositoryChanged);
  }

  final String entryId;

  JournalEntry? get entry => JournalRepository.instance.findById(entryId);

  void remove() {
    JournalRepository.instance.remove(entryId);
  }

  void _onRepositoryChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    JournalRepository.instance.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
