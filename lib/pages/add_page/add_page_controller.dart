import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/journal_entry.dart';
import '../../util/journal_repository.dart';
import '../../util/photo_service.dart';

/// Controller of the add page.
///
/// The same page is reused for editing: when [entry] is not null the fields are
/// pre-filled and saving updates the existing entry instead of creating one.
class AddPageController extends ChangeNotifier {
  AddPageController({this.entry}) : _imageBase64 = entry?.imageBase64;

  final JournalEntry? entry;

  String? _titleError;
  String? _imageBase64;
  bool _isPicking = false;

  bool get isEditing => entry != null;

  String? get titleError => _titleError;

  String? get imageBase64 => _imageBase64;

  bool get hasImage => _imageBase64 != null && _imageBase64!.isNotEmpty;

  bool get isPicking => _isPicking;

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

  /// Asks the service for camera / gallery permission, then picks an image.
  Future<PhotoPickResult> pickPhoto(ImageSource source) async {
    _isPicking = true;
    notifyListeners();

    final PhotoPickResult result = await const PhotoService().pick(source);

    if (result.status == PhotoPickStatus.success) {
      _imageBase64 = result.base64;
    }

    _isPicking = false;
    notifyListeners();
    return result;
  }

  void removeImage() {
    _imageBase64 = null;
    notifyListeners();
  }

  /// Creates the entry, or updates it when the page is in edit mode.
  void save({required String title, required String notes}) {
    final JournalRepository repository = JournalRepository.instance;

    if (entry == null) {
      repository.add(title: title, notes: notes, imageBase64: _imageBase64);
    } else {
      repository.update(
        entry!.id,
        title: title,
        notes: notes,
        imageBase64: _imageBase64,
        removeImage: _imageBase64 == null,
      );
    }
  }
}
