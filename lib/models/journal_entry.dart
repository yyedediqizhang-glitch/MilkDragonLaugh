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
    this.imageBase64,
  });

  final String id;
  final String title;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Base64 encoded image bytes, stored with the entry (not a file path, so the
  /// photo survives even if the original is deleted from the gallery).
  final String? imageBase64;

  bool get hasImage => imageBase64 != null && imageBase64!.isNotEmpty;

  JournalEntry copyWith({
    String? title,
    String? notes,
    DateTime? updatedAt,
    String? imageBase64,
    bool removeImage = false,
  }) {
    return JournalEntry(
      id: id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageBase64: removeImage ? null : (imageBase64 ?? this.imageBase64),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (imageBase64 != null) 'imageBase64': imageBase64,
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      imageBase64: json['imageBase64'] as String?,
    );
  }
}
