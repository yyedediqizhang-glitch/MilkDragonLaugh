import 'package:material_ui/material_ui.dart';

import '../../components/snap_card.dart';
import '../../models/snap_item.dart';
import '../../util/date_formatter.dart';
import 'home_page_controller.dart';

/// Home page: a simple, working list of snaps that shows the MVC flow
/// view -> controller -> model.
class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final HomePageController _controller = HomePageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showAddDialog() async {
    final TextEditingController textController = TextEditingController();

    final String? title = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('New snap'),
          content: TextField(
            controller: textController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'e.g. Finish the Session 1 challenge',
            ),
            onSubmitted: (String value) =>
                Navigator.of(dialogContext).pop(value),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(textController.text),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    textController.dispose();

    if (!mounted || title == null) {
      return;
    }

    _controller.add(title);
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'EDU SNAP',
      applicationVersion: '1.0.0',
      children: const <Widget>[
        Text(
          'A Flutter workshop demo built with the MVC structure: '
          'models, components, pages and util.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EDU SNAP'),
        actions: <Widget>[
          IconButton(
            tooltip: 'About',
            onPressed: _showAbout,
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add snap'),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (BuildContext context, Widget? child) {
          final List<SnapItem> items = _controller.items;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
            children: <Widget>[
              const Text(
                'Hi, Ricardo',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14223B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                formatDateTime(DateTime.now()),
                style: const TextStyle(fontSize: 13, color: Color(0xFF7A88A3)),
              ),
              const SizedBox(height: 18),
              Row(
                children: <Widget>[
                  _StatChip(
                    label: '${_controller.totalCount} snaps',
                    icon: Icons.auto_awesome_rounded,
                  ),
                  const SizedBox(width: 10),
                  _StatChip(
                    label: '${_controller.doneCount} done',
                    icon: Icons.check_circle_outline_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 22),
              if (items.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE3E9F4)),
                  ),
                  child: const Text(
                    'No snaps yet. Tap "Add snap" to create your first one.',
                    style: TextStyle(color: Color(0xFF7A88A3)),
                  ),
                )
              else
                ...items.map(
                  (SnapItem item) => SnapCard(
                    title: item.title,
                    subtitle:
                        '${item.note} · ${formatTime(item.createdAt)}',
                    isDone: item.isDone,
                    onToggle: () => _controller.toggle(item.id),
                    onDelete: () => _controller.remove(item.id),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE3E9F4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: const Color(0xFF2F6FED)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF14223B),
            ),
          ),
        ],
      ),
    );
  }
}
