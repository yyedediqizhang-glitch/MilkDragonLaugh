/// A single snap (note / task) shown on the home page.
///
/// Models only hold data: no widgets, no network calls.
class SnapItem {
  const SnapItem({
    required this.id,
    required this.title,
    required this.createdAt,
    this.note = '',
    this.isDone = false,
  });

  final String id;
  final String title;
  final String note;
  final DateTime createdAt;
  final bool isDone;

  SnapItem copyWith({String? title, String? note, bool? isDone}) {
    return SnapItem(
      id: id,
      title: title ?? this.title,
      note: note ?? this.note,
      createdAt: createdAt,
      isDone: isDone ?? this.isDone,
    );
  }
}
