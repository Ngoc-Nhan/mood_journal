import 'package:flutter/material.dart';
import 'package:mood_journal/models/note_model.dart';
import 'package:intl/intl.dart';

class NoteDetailPage extends StatelessWidget {
  final NoteModel note;

  const NoteDetailPage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title ?? 'Note Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.createdAt != null)
              Text(
                'Created on: ${DateFormat.yMMMd().format(note.createdAt!)}',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              note.title ?? 'No Title',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  note.content ?? 'No content for this note.',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
