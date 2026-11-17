import 'dart:convert';

import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../../models/journal_entry.dart';
import '../../util/app_theme.dart';
import '../../util/date_formatter.dart';
import '../../util/duo_layout_service.dart';
import '../add_page/add_page_view.dart';
import 'detail_page_controller.dart';

/// Detail page: shows one journal entry, and offers edit / delete.
///
/// On an iPhone Duo the Back action moves to the native side rail and the
/// Flutter AppBar arrow is hidden. When [embedded] is true the page is shown
/// inside the home page's right pane instead of as its own route.
class DetailPageView extends StatefulWidget {
  const DetailPageView({
    super.key,
    required this.entryId,
    this.embedded = false,
  });

  final String entryId;
  final bool embedded;

  @override
  State<DetailPageView> createState() => _DetailPageViewState();
}

class _DetailPageViewState extends State<DetailPageView> {
  late final DetailPageController _controller = DetailPageController(
    entryId: widget.entryId,
  );

  bool _railVisible = false;

  @override
  void initState() {
    super.initState();
    if (!widget.embedded) {
      _useNativeRailBack();
    }
  }

  Future<void> _useNativeRailBack() async {
    DuoLayoutService.instance.setBackHandler(() {
      if (!mounted) {
        return;
      }
      Navigator.of(context).maybePop();
    });

    final bool shown = await DuoLayoutService.instance.enableRailBack();
    if (mounted && shown != _railVisible) {
      setState(() => _railVisible = shown);
    }
  }

  @override
  void dispose() {
    if (!widget.embedded) {
      DuoLayoutService.instance.setBackHandler(null);
      DuoLayoutService.instance.disableRailBack();
    }
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
    final AppPalette palette = context.palette;
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
              style: FilledButton.styleFrom(backgroundColor: palette.danger),
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
    if (!widget.embedded) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String localeName = Localizations.localeOf(context).toString();
    final AppPalette palette = context.palette;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.entryLabel),
        automaticallyImplyLeading: !_railVisible,
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
            return Center(
              child: Text(l10n.emptyTitle, style: TextStyle(color: palette.muted)),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: <Widget>[
              Text(
                entry.title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  color: palette.ink,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.createdOn(formatDateTime(entry.createdAt, localeName)),
                style: TextStyle(fontSize: 12, color: palette.muted),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.updatedOn(formatDateTime(entry.updatedAt, localeName)),
                style: TextStyle(fontSize: 12, color: palette.muted),
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
                  color: palette.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: palette.border),
                ),
                child: Text(
                  entry.notes.isEmpty ? l10n.noNotes : entry.notes,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: palette.ink,
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
