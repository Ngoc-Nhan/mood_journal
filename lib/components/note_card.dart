import 'package:flutter/material.dart';
import 'package:mood_journal/models/note_model.dart';
import 'package:mood_journal/providers/note_provider.dart';
import 'package:mood_journal/screens/note_edit/note_edit.dart';
import 'package:mood_journal/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final noteColor = isDark
        ? AppColors.noteColorsDark[note.colorIndex]
        : Colors.white;
    return Card(
      color: noteColor,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NoteEditorScreen(editMode: false, note: note),
            ),
          ).then((_) {
            Provider.of<NoteProvider>(context, listen: false).loadNotes();
          });
        },
        onLongPress: () {
          _showBottomSheet(context);
        },

        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  note.title.isEmpty
                      ? Container()
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              note.title,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                  if (note.isPinned)
                    Icon(Icons.push_pin, size: 20, color: Colors.grey),
                  if (note.isFavorite)
                    Icon(Icons.favorite, size: 20, color: Colors.red),
                ],
              ),
              if (note.content.isNotEmpty) ...[
                SizedBox(height: 8),
                Text(
                  note.content,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (note.tags.isNotEmpty) ...[
                SizedBox(height: 8),
                Wrap(
                  runSpacing: 6,
                  spacing: 6,
                  children: note.tags
                      .take(3)
                      .map(
                        (tag) => Chip(
                          label: Text(tag, style: TextStyle(fontSize: 11)),
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                      .toList(),
                ),
              ],
              SizedBox(height: 8),
              Text(
                DateFormat('MMM dd, yyyy "s hh:mm a').format(note.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getTextColorForBackground(noteColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTextColorForBackground(Color noteColor) {
    final luminance = noteColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Note'),
        content: Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Provider.of<NoteProvider>(
              context,
              listen: false,
            ).deleteNote(note.id!),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                ),
                title: Text(note.isPinned ? 'Unpin' : 'Pin'),
                onTap: () {
                  Provider.of<NoteProvider>(
                    context,
                    listen: false,
                  ).togglePinNote(note.id!);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  note.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                title: Text(
                  note.isFavorite ? 'Remove form favorite' : 'Add to favorite',
                ),
                onTap: () {
                  Provider.of<NoteProvider>(
                    context,
                    listen: false,
                  ).toggleFavoriteNote(note.id!);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmationDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
