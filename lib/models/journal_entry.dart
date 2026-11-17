/// A single journal entry: the model of this app.
///
/// Models only hold data: no widgets, no network calls.
class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.title,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalEntry copyWith({String? title, String? notes, DateTime? updatedAt}) {
    return JournalEntry(
      id: id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
