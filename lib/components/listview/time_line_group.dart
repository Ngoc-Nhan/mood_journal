import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_journal/components/listview/build_note_detail.dart';
import 'package:mood_journal/models/note_model.dart';
import 'package:mood_journal/theme/app_colors.dart';

class TimelineGroup extends StatelessWidget {
  final String dateKey;
  final List<NoteModel> notes;

  const TimelineGroup({super.key, required this.dateKey, required this.notes});

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(dateKey);
    String day = DateFormat('dd').format(parsedDate);
    String monthYear = "thg ${parsedDate.month} ${parsedDate.year}";
    final isDark = Theme.of(context).brightness == Brightness.dark;
    notes.sort((a, b) {
      if (a.isPinned && !b.isPinned) {
        return -1; // a comes first
      } else if (!a.isPinned && b.isPinned) {
        return 1; // b comes first
      } else {
        // Both are pinned or both are unpinned, sort by date
        return b.createdAt.compareTo(a.createdAt);
      }
    });
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ngày tháng
        SizedBox(
          width: 70,
          child: Column(
            children: [
              Text(
                day,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.primary : AppColors.primary,
                ),
              ),
              Text(
                monthYear,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.primary : AppColors.primary,
                ),
              ),
            ],
          ),
        ),

        // Notes (KHÔNG Expanded)
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: notes.map((note) => BuildNoteDetail(note: note)).toList(),
          ),
        ),
      ],
    );
  }
}
