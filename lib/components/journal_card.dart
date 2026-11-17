import 'package:material_ui/material_ui.dart';

import '../../util/date_formatter.dart';

/// One row in the home page list. Reused for every journal entry.
class JournalCard extends StatelessWidget {
  const JournalCard({
    super.key,
    required this.title,
    required this.notes,
    required this.date,
    required this.onTap,
  });

  final String title;
  final String notes;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3E9F4)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF14223B),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF9AA7BF),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notes,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xFF7A88A3),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  formatDateTime(date),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFA9B4C8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
