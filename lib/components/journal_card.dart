import 'dart:convert';

import 'package:material_ui/material_ui.dart';

import '../../util/app_theme.dart';
import '../../util/date_formatter.dart';

/// One row in the home page list. Reused for every journal entry.
class JournalCard extends StatelessWidget {
  const JournalCard({
    super.key,
    required this.title,
    required this.notes,
    required this.date,
    required this.localeName,
    required this.onTap,
    this.imageBase64,
    this.selected = false,
  });

  final String title;
  final String notes;
  final DateTime date;
  final String localeName;
  final VoidCallback onTap;
  final String? imageBase64;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: selected
            ? palette.surface.withValues(alpha: 0.35)
            : palette.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? palette.secondary : palette.border,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (imageBase64 != null && imageBase64!.isNotEmpty) ...<Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      base64Decode(imageBase64!),
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: palette.ink,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: palette.muted,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notes,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: palette.muted,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        formatDateTime(date, localeName),
                        style: TextStyle(
                          fontSize: 11,
                          color: palette.muted.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
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
