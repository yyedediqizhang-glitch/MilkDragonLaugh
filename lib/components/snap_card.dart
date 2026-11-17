import 'package:material_ui/material_ui.dart';

/// One row/card on the home page, reused for every snap in the list.
class SnapCard extends StatelessWidget {
  const SnapCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isDone,
    required this.onToggle,
    required this.onDelete,
  });

  final String title;
  final String subtitle;
  final bool isDone;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3E9F4)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        leading: Checkbox(
          value: isDone,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF14223B),
            decoration: isDone ? TextDecoration.lineThrough : null,
            decorationColor: const Color(0xFF9AA7BF),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xFF7A88A3)),
          ),
        ),
        trailing: IconButton(
          tooltip: 'Delete',
          icon: const Icon(Icons.delete_outline, color: Color(0xFF9AA7BF)),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
