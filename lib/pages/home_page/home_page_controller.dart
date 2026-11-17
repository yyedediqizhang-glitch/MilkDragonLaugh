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

  /// Called from `initState`: load the data once, then sort it by title.
  ///
  /// This is the lifecycle step explained in Session 2 – `initState` runs once
  /// when the page is created, so the loading and the initial sorting live here.
  Future<void> init() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _repository.sortByTitleDescending();
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
