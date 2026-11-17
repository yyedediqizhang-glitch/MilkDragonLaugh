import 'package:flutter/foundation.dart';

import '../../models/journal_entry.dart';
import '../../util/journal_repository.dart';

/// Controller of the home page (list of journal entries).
class HomePageController extends ChangeNotifier {
  HomePageController({JournalRepository? repository})
    : _repository = repository ?? JournalRepository.instance {
    _repository.addListener(_onRepositoryChanged);
  }

  final JournalRepository _repository;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  List<JournalEntry> get entries => _repository.entries;

  /// Called from `initState`: load the stored journal once, then sort it by
  /// title (Session 2 lifecycle + Session 3 local storage).
  Future<void> init() async {
    await _repository.load();
    _isLoading = false;
    notifyListeners();
  }

  void remove(String id) {
    _repository.remove(id);
  }

  void _onRepositoryChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _repository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
