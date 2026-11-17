import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Result of a photo picking attempt.
enum PhotoPickStatus { success, permissionDenied, cancelled, failed }

class PhotoPickResult {
  const PhotoPickResult(this.status, [this.base64]);

  final PhotoPickStatus status;

  /// Base64 encoded bytes of the picked image, ready to be stored.
  final String? base64;
}

/// Wraps `image_picker` + `permission_handler`.
///
/// Permissions are checked *before* opening the camera / gallery, and a denied
/// permission is reported back so the UI can explain it and offer the system
/// settings.
class PhotoService {
  const PhotoService();

  Future<PhotoPickResult> pick(ImageSource source) async {
    // The permission plugin only makes sense on Android and iOS; on the web the
    // browser shows its own picker.
    if (!kIsWeb) {
      final Permission permission = source == ImageSource.camera
          ? Permission.camera
          : Permission.photos;

      PermissionStatus status = await permission.status;
      if (!status.isGranted) {
        status = await permission.request();
      }

      if (!status.isGranted) {
        return const PhotoPickResult(PhotoPickStatus.permissionDenied);
      }
    }

    try {
      final XFile? file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 82,
      );

      if (file == null) {
        return const PhotoPickResult(PhotoPickStatus.cancelled);
      }

      final Uint8List bytes = await file.readAsBytes();
      return PhotoPickResult(PhotoPickStatus.success, base64Encode(bytes));
    } catch (_) {
      return const PhotoPickResult(PhotoPickStatus.failed);
    }
  }

  /// Opens the system settings page for this app (used after a denial).
  Future<void> openSettings() => openAppSettings();
}
