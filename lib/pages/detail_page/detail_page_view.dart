import 'dart:convert';

import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
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
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.deleteEntryTitle),
          content: Text(l10n.deleteEntryBody(entry.title)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.delete),
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
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String localeName = Localizations.localeOf(context).toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.entryLabel),
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
                    tooltip: l10n.edit,
                    onPressed: () => _openEdit(entry),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    tooltip: l10n.delete,
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
            return Center(child: Text(l10n.emptyTitle));
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
                l10n.createdOn(formatDateTime(entry.createdAt, localeName)),
                style: const TextStyle(fontSize: 12, color: Color(0xFF7A88A3)),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.updatedOn(formatDateTime(entry.updatedAt, localeName)),
                style: const TextStyle(fontSize: 12, color: Color(0xFF7A88A3)),
              ),
              if (entry.hasImage) ...<Widget>[
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.memory(
                    base64Decode(entry.imageBase64!),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    gaplessPlayback: true,
                  ),
                ),
              ],
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE3E9F4)),
                ),
                child: Text(
                  entry.notes.isEmpty ? l10n.noNotes : entry.notes,
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
                label: Text(l10n.editThisEntry),
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
