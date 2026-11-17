import 'package:flutter/foundation.dart';

import '../../models/snap_item.dart';

/// Controller of the home page: owns the list of snaps and all its operations.
class HomePageController extends ChangeNotifier {
  HomePageController({List<SnapItem>? items})
    : _items = List<SnapItem>.of(items ?? _seedItems());

  final List<SnapItem> _items;

  List<SnapItem> get items => List<SnapItem>.unmodifiable(_items);

  int get totalCount => _items.length;

  int get doneCount => _items.where((SnapItem item) => item.isDone).length;

  static List<SnapItem> _seedItems() {
    final DateTime now = DateTime.now();

    return <SnapItem>[
      SnapItem(
        id: 'seed-1',
        title: 'Flutter workshop · Session 1',
        note: 'Set up the project and the MVC folders',
        createdAt: now,
      ),
      SnapItem(
        id: 'seed-2',
        title: 'Push the project to GitHub',
        note: 'Commit inside the cloned repository',
        createdAt: now,
        isDone: true,
      ),
      SnapItem(
        id: 'seed-3',
        title: 'Explore the landing page',
        note: 'Try the Get Started button',
        createdAt: now,
      ),
    ];
  }

  void add(String title) {
    final String trimmed = title.trim();
    if (trimmed.isEmpty) {
      return;
    }

    _items.insert(
      0,
      SnapItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: trimmed,
        note: 'Added just now',
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void toggle(String id) {
    final int index = _items.indexWhere((SnapItem item) => item.id == id);
    if (index == -1) {
      return;
    }

    _items[index] = _items[index].copyWith(isDone: !_items[index].isDone);
    notifyListeners();
  }

  void remove(String id) {
    _items.removeWhere((SnapItem item) => item.id == id);
    notifyListeners();
  }
}
