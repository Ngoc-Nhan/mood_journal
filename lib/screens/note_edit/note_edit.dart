import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mood_journal/models/note_model.dart';
import 'package:mood_journal/providers/note_provider.dart';
import 'package:mood_journal/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

class NoteEditorScreen extends StatefulWidget {
  final NoteModel? note;
  final bool editMode;
  const NoteEditorScreen({
    super.key,
    required this.note,
    required this.editMode,
  });

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late bool _editMode = widget.editMode;
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late int _selectedColorIndex;
  late bool _isFavorite;
  List<String> _tags = [];
  List<String> _attachments = [];
  final _tagController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    _selectedColorIndex = widget.note?.colorIndex ?? 0;
    _isFavorite = widget.note?.isFavorite ?? false;
    _tags = List.from(widget.note?.tags ?? []);
    _attachments = List.from(widget.note?.attachments ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        _attachments.isEmpty) {
      final note = NoteModel(
        id: widget.note?.id ?? Uuid().v4(),
        title: _titleController.text,
        content: _contentController.text,
        colorIndex: _selectedColorIndex,
        isFavorite: _isFavorite,
        tags: _tags,
        isPinned: widget.note?.isPinned ?? false,
        attachments: _attachments,
        createdAt: widget.note?.createdAt ?? DateTime.now(),
        modifiedAt: widget.note?.modifiedAt ?? DateTime.now(),
      );
      if (widget.note == null) {
        await noteProvider.createNote(note);
      } else {
        await noteProvider.updateNote(note);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _attachments.add(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final noteColor = isDark
        ? AppColors.noteColorsDark[_selectedColorIndex]
        : AppColors.noteColors[_selectedColorIndex];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await _saveNote();
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: noteColor,
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
            icon: _isFavorite
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border),
          ),
          IconButton(onPressed: _pickImage, icon: Icon(Icons.image_outlined)),
          IconButton(
            onPressed: () {
              // _showOptionsMenu,
            },
            icon: Icon(Icons.more_vert),
          ),

          IconButton(
            onPressed: () {
              setState(() {
                _editMode = !_editMode;
              });
            },
            icon: Icon(_editMode ? Icons.save : Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _editMode
                ? TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.headlineMedium,
                  )
                : (_titleController
                          .text
                          .isNotEmpty // Kiểm tra nếu text không rỗng
                      ? Text(
                          _titleController.text,
                          style: Theme.of(context).textTheme.headlineMedium,
                        )
                      : const SizedBox.shrink()), // Nếu rỗng thì không hiển thị gì
            const SizedBox(height: 8),
            if (_tags.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.map((tag) {
                  return _editMode
                      ? Chip(
                          label: Text(tag),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              _tags.remove(tag);
                            });
                          },
                        )
                      : Chip(label: Text(tag));
                }).toList(),
              ),
            ],

            if (_attachments.isNotEmpty) ...[
              SizedBox(
                height: 16,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsetsGeometry.only(right: 8),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_attachments[index]),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _attachments.removeAt(index);
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
            SizedBox(height: 16),
            _editMode
                ? TextField(
                    controller: _contentController,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Write something...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                  )
                : Text(
                    _contentController.text,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker() {
    _showModalBottomSheet(
      context: context,
    )
  }
}
