import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../../models/journal_entry.dart';
import '../../util/app_theme.dart';
import '../../util/photo_service.dart';
import 'add_page_controller.dart';

/// Add page – also used as the edit page for the Session 2 challenge.
class AddPageView extends StatefulWidget {
  const AddPageView({super.key, this.entry});

  /// When set, the page edits this entry instead of creating a new one.
  final JournalEntry? entry;

  @override
  State<AddPageView> createState() => _AddPageViewState();
}

class _AddPageViewState extends State<AddPageView> {
  late final AddPageController _controller = AddPageController(
    entry: widget.entry,
  );

  late final TextEditingController _titleController = TextEditingController(
    text: widget.entry?.title ?? '',
  );
  late final TextEditingController _notesController = TextEditingController(
    text: widget.entry?.notes ?? '',
  );

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool isValid = _controller.validate(title: _titleController.text);

    if (!isValid) {
      // Homework: a different way of showing the error, a floating snack bar
      // instead of the alert dialog used in the workshop.
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.titleEmptyMessage),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      return;
    }

    _controller.save(
      title: _titleController.text,
      notes: _notesController.text,
    );
    Navigator.of(context).pop();
  }

  Future<void> _showSourceSheet() async {
    final AppLocalizations l10n = AppLocalizations.of(context);

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(l10n.takePhoto),
                onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(l10n.chooseFromGallery),
                onTap: () =>
                    Navigator.of(sheetContext).pop(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null || !mounted) {
      return;
    }

    final PhotoPickResult result = await _controller.pickPhoto(source);
    if (!mounted) {
      return;
    }

    switch (result.status) {
      case PhotoPickStatus.permissionDenied:
        await _showPermissionDialog(source);
      case PhotoPickStatus.failed:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.pickFailed)),
        );
      case PhotoPickStatus.success:
      case PhotoPickStatus.cancelled:
        break;
    }
  }

  Future<void> _showPermissionDialog(ImageSource source) async {
    final AppLocalizations l10n = AppLocalizations.of(context);

    final bool? goToSettings = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.permissionTitle),
          content: Text(
            source == ImageSource.camera
                ? l10n.permissionCameraBody
                : l10n.permissionGalleryBody,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.openSettings),
            ),
          ],
        );
      },
    );

    if (goToSettings == true) {
      await const PhotoService().openSettings();
    }
  }

  Widget _buildPhotoSection(AppLocalizations l10n) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (BuildContext context, Widget? child) {
        if (_controller.hasImage) {
          return Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.memory(
                  base64Decode(_controller.imageBase64!),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Material(
                  color: context.palette.ink.withValues(alpha: 0.6),
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: l10n.removePhoto,
                    onPressed: _controller.removeImage,
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }

        return OutlinedButton.icon(
          onPressed: _controller.isPicking ? null : _showSourceSheet,
          icon: _controller.isPicking
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add_a_photo_outlined),
          label: Text(l10n.addPhoto),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool isEditing = _controller.isEditing;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editEntry : l10n.newEntry),
        actions: <Widget>[
          TextButton(
            onPressed: _save,
            child: Text(
              l10n.save,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: <Widget>[
          ListenableBuilder(
            listenable: _controller,
            builder: (BuildContext context, Widget? child) {
              return TextField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                maxLength: 80,
                decoration: InputDecoration(
                  labelText: '${l10n.titleLabel} *',
                  hintText: l10n.titleHint,
                  errorText: _controller.titleError == null
                      ? null
                      : l10n.titleRequired,
                  counterText: '',
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            minLines: 5,
            maxLines: 12,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.notesLabel,
              hintText: l10n.notesHint,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.photoSection,
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
              color: context.palette.muted,
            ),
          ),
          const SizedBox(height: 10),
          _buildPhotoSection(l10n),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _save,
            icon: Icon(isEditing ? Icons.save_outlined : Icons.add_rounded),
            label: Text(isEditing ? l10n.saveChanges : l10n.addEntry),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
