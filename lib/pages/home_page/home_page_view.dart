import 'package:material_ui/material_ui.dart';

import '../../components/journal_card.dart';
import '../../models/journal_entry.dart';
import '../add_page/add_page_view.dart';
import '../detail_page/detail_page_view.dart';
import '../setting_page/setting_page_view.dart';
import 'home_page_controller.dart';

/// Home page: the list of journal entries.
class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final HomePageController _controller = HomePageController();

  @override
  void initState() {
    super.initState();
    _controller.init();
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

    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EDU SNAP'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Settings',
            onPressed: _openSettings,
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAdd,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New entry'),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (BuildContext context, Widget? child) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<JournalEntry> entries = _controller.entries;

          if (entries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.menu_book_outlined,
                      size: 56,
                      color: Color(0xFF9AA7BF),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your journal is empty',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF14223B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap "New entry" to write your first one.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF7A88A3)),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: _openAdd,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('New entry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              final JournalEntry entry = entries[index];

              return Dismissible(
                key: ValueKey<String>(entry.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) => _confirmDelete(entry),
                onDismissed: (_) => _controller.remove(entry.id),
                background: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.only(right: 24),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5484D),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                  ),
                ),
                child: JournalCard(
                  title: entry.title,
                  notes: entry.notes,
                  date: entry.updatedAt,
                  onTap: () => _openDetail(entry.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
