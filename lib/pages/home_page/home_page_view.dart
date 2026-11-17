import 'package:material_ui/material_ui.dart';

import '../../components/journal_card.dart';
import '../../l10n/app_localizations.dart';
import '../../models/journal_entry.dart';
import '../../util/app_theme.dart';
import '../../util/duo_layout_service.dart';
import '../add_page/add_page_view.dart';
import '../detail_page/detail_page_view.dart';
import '../setting_page/setting_page_view.dart';
import 'home_page_controller.dart';

/// Home page: the list of journal entries.
///
/// On an iPhone Duo that is fully open (or on a wide window) it turns into a
/// two-pane layout: list on the left, detail on the right.
class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final HomePageController _controller = HomePageController();

  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _controller.init();
    DuoLayoutService.instance.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openDetail(String id) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => DetailPageView(entryId: id)),
    );
  }

  Future<void> _openAdd() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const AddPageView()),
    );
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SettingPageView()),
    );
  }

  Future<bool> _confirmDelete(JournalEntry entry) async {
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

    return confirmed ?? false;
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    final AppPalette palette = context.palette;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.menu_book_outlined, size: 56, color: palette.muted),
            const SizedBox(height: 16),
            Text(
              l10n.emptyTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: palette.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptyHint,
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.muted),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _openAdd,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.newEntry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(String localeName, List<JournalEntry> entries, {required bool twoPanes}) {
    final AppPalette palette = context.palette;

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20, 8, 20, twoPanes ? 96 : 96),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        final JournalEntry entry = entries[index];

        return Dismissible(
          key: ValueKey<String>(entry.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) => _confirmDelete(entry),
          onDismissed: (_) {
            if (_selectedId == entry.id) {
              setState(() => _selectedId = null);
            }
            _controller.remove(entry.id);
          },
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.only(right: 24),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: palette.danger,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
          ),
          child: JournalCard(
            title: entry.title,
            notes: entry.notes,
            date: entry.updatedAt,
            localeName: localeName,
            imageBase64: entry.imageBase64,
            selected: twoPanes && entry.id == _selectedId,
            onTap: () {
              if (twoPanes) {
                setState(() => _selectedId = entry.id);
              } else {
                _openDetail(entry.id);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildDetailPane(
    AppLocalizations l10n,
    List<JournalEntry> entries,
  ) {
    final AppPalette palette = context.palette;
    final bool stillThere = entries.any(
      (JournalEntry entry) => entry.id == _selectedId,
    );

    if (_selectedId == null || !stillThere) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.vertical_split_rounded, size: 48, color: palette.muted),
              const SizedBox(height: 12),
              Text(
                l10n.emptyHint,
                textAlign: TextAlign.center,
                style: TextStyle(color: palette.muted),
              ),
            ],
          ),
        ),
      );
    }

    return DetailPageView(
      key: ValueKey<String>(_selectedId!),
      entryId: _selectedId!,
      embedded: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String localeName = Localizations.localeOf(context).toString();
    final bool twoPanes = DuoLayoutService.instance.wantsTwoPanes(
      MediaQuery.sizeOf(context),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: <Widget>[
          IconButton(
            tooltip: l10n.settingsTitle,
            onPressed: _openSettings,
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAdd,
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.newEntry),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge(<Listenable>[
          _controller,
          DuoLayoutService.instance,
        ]),
        builder: (BuildContext context, Widget? child) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<JournalEntry> entries = _controller.entries;

          if (entries.isEmpty) {
            return _buildEmptyState(l10n);
          }

          if (twoPanes) {
            return Row(
              children: <Widget>[
                SizedBox(
                  width: 380,
                  child: _buildList(
                    localeName,
                    entries,
                    twoPanes: true,
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: _buildDetailPane(l10n, entries)),
              ],
            );
          }

          return _buildList(localeName, entries, twoPanes: false);
        },
      ),
    );
  }
}
