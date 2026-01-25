import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:mood_journal/components/gridview/note_card.dart';
// import 'package:mood_journal/components/listview/build_note_detail.dart';
import 'package:mood_journal/models/note_model.dart';

class TimelineGridGroup extends StatelessWidget {
  final String dateKey;
  final List<NoteModel> notes;

  const TimelineGridGroup({
    super.key,
    required this.dateKey,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    final parsedDate = DateFormat('dd/MM/yyyy').parse(dateKey);
    final day = DateFormat('dd').format(parsedDate);
    final monthYear = "thg ${parsedDate.month} ${parsedDate.year}";
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📅 HEADER NGÀY
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                day,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[300],
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  monthYear,
                  style: TextStyle(fontSize: 13, color: Colors.brown[200]),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 🧩 GRID NOTES TRONG NGÀY
          // GridView.builder(
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemCount: notes.length,
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     mainAxisSpacing: 10,
          //     crossAxisSpacing: 10,
          //     childAspectRatio: 0.85,
          //   ),
          //   itemBuilder: (context, index) {
          //     return NoteCard(note: notes[index]);
          //   },
          // ),
          MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            shrinkWrap: true, // ⚠️ BẮT BUỘC
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return NoteCard(note: notes[index]);
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
