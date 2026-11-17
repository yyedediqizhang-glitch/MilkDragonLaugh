import 'package:material_ui/material_ui.dart';

import '../../models/journal_entry.dart';
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
    final bool isValid = _controller.validate(title: _titleController.text);

    if (!isValid) {
      // Homework: a different way of showing the error, a floating snack bar
      // instead of the alert dialog used in the workshop.
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Please enter a title before saving.'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
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

  @override
  Widget build(BuildContext context) {
    final bool isEditing = _controller.isEditing;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit entry' : 'New entry'),
        actions: <Widget>[
          TextButton(
            onPressed: _save,
            child: const Text(
              'Save',
              style: TextStyle(fontWeight: FontWeight.w700),
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
                  labelText: 'Title *',
                  hintText: 'e.g. What I learned today',
                  errorText: _controller.titleError,
                  counterText: '',
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            minLines: 6,
            maxLines: 12,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Notes',
              hintText: 'Write anything you want to remember...',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _save,
            icon: Icon(isEditing ? Icons.save_outlined : Icons.add_rounded),
            label: Text(isEditing ? 'Save changes' : 'Add entry'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Title is required. An empty title shows an error message.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF7A88A3)),
          ),
        ],
      ),
    );
  }
}
