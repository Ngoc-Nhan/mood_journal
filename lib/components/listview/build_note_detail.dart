// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_journal/constants/mood_default.dart';
import 'package:mood_journal/models/note_model.dart';
import 'package:mood_journal/providers/note_provider.dart';
import 'package:mood_journal/screens/note_edit/note_edit.dart';
import 'package:mood_journal/theme/app_colors.dart';
import 'package:provider/provider.dart';

class BuildNoteDetail extends StatefulWidget {
  final NoteModel note;
  const BuildNoteDetail({super.key, required this.note});

  @override
  State<BuildNoteDetail> createState() => _BuildNoteDetailState();
}

class _BuildNoteDetailState extends State<BuildNoteDetail> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final noteColor = isDark
        ? AppColors.noteColorsDark[widget.note.colorIndex]
        : AppColors.noteColors[widget.note.colorIndex];
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: noteColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          left: BorderSide(
            color: const Color.fromARGB(64, 158, 158, 158),
            width: 1,
          ),
          bottom: BorderSide(
            color: const Color.fromARGB(64, 158, 158, 158),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    NoteEditorScreen(editMode: false, note: widget.note),
              ),
            ).then((_) {
              Provider.of<NoteProvider>(context, listen: false).loadNotes();
            });
          },
          onLongPress: () {
            _showBottomSheet(context);
          },
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị giờ (Ví dụ: 14:12)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(widget.note.createdAt),
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          fontSize: 12,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 5,
                        children: [
                          if (widget.note.isPinned)
                            Icon(Icons.push_pin, size: 20, color: Colors.grey),
                          if (widget.note.isFavorite)
                            Icon(Icons.favorite, size: 20, color: Colors.red),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Mood Icon (Hiện tại là hình tròn xám theo ảnh)
                  widget.note.moodIndex != null
                      ? Icon(
                          moodIcons[widget.note.moodIndex!],
                          size: 30,
                          color: isDark
                              ? AppColors.backgroundLight
                              : AppColors.backgroundDark,
                        )
                      : Container(),

                  const SizedBox(height: 5),
                  // Tiêu đề
                  widget.note.title.isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            widget.note.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                  // Nội dung tóm tắt
                  Text(
                    widget.note.content,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (widget.note.tags.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Wrap(
                      runSpacing: 0,
                      spacing: 2,
                      children: widget.note.tags
                          .take(3)
                          .map(
                            (tag) => Chip(
                              label: Text(tag, style: TextStyle(fontSize: 11)),
                              visualDensity: VisualDensity.compact,
                            ),
                          )
                          .toList(),
                    ),
                    if (widget.note.tags.length > 3)
                      Chip(
                        label: Text(
                          '+${widget.note.tags.length - 2}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
            onPressed: () {
              Navigator.pop(context);
              Provider.of<NoteProvider>(
                context,
                listen: false,
              ).deleteNote(widget.note.id!);
            },
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
                  widget.note.isPinned
                      ? Icons.push_pin
                      : Icons.push_pin_outlined,
                ),
                title: Text(widget.note.isPinned ? 'Unpin' : 'Pin'),
                onTap: () {
                  Provider.of<NoteProvider>(
                    context,
                    listen: false,
                  ).togglePinNote(widget.note.id!);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  widget.note.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                title: Text(
                  widget.note.isFavorite
                      ? 'Remove form favorite'
                      : 'Add to favorite',
                ),
                onTap: () {
                  Provider.of<NoteProvider>(
                    context,
                    listen: false,
                  ).toggleFavoriteNote(widget.note.id!);
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
