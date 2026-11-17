import 'package:material_ui/material_ui.dart';

import '../../models/journal_entry.dart';
import '../../util/date_formatter.dart';
import '../add_page/add_page_view.dart';
import 'detail_page_controller.dart';

/// Detail page: shows one journal entry, and offers edit / delete.
class DetailPageView extends StatefulWidget {
  const DetailPageView({super.key, required this.entryId});

  final String entryId;

  @override
  State<DetailPageView> createState() => _DetailPageViewState();
}

class _DetailPageViewState extends State<DetailPageView> {
  late final DetailPageController _controller = DetailPageController(
    entryId: widget.entryId,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openEdit(JournalEntry entry) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => AddPageView(entry: entry)),
    );
  }

  Future<void> _confirmDelete(JournalEntry entry) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete entry?'),
          content: Text('"${entry.title}" will be removed from your journal.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    _controller.remove();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry'),
        actions: <Widget>[
          ListenableBuilder(
            listenable: _controller,
            builder: (BuildContext context, Widget? child) {
              final JournalEntry? entry = _controller.entry;
              if (entry == null) {
                return const SizedBox.shrink();
              }

              return Row(
                children: <Widget>[
                  IconButton(
                    tooltip: 'Edit',
                    onPressed: () => _openEdit(entry),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    tooltip: 'Delete',
                    onPressed: () => _confirmDelete(entry),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (BuildContext context, Widget? child) {
          final JournalEntry? entry = _controller.entry;

          if (entry == null) {
            return const Center(child: Text('This entry was deleted.'));
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: <Widget>[
              Text(
                entry.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  color: Color(0xFF14223B),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Created ${formatDateTime(entry.createdAt)}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF7A88A3)),
              ),
              const SizedBox(height: 4),
              Text(
                'Updated ${formatDateTime(entry.updatedAt)}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF7A88A3)),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE3E9F4)),
                ),
                child: Text(
                  entry.notes.isEmpty ? 'No notes yet.' : entry.notes,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Color(0xFF14223B),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => _openEdit(entry),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit this entry'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
