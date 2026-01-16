import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mood_journal/components/color_picker.dart';
import 'package:mood_journal/models/note_model.dart';
import 'package:mood_journal/providers/note_provider.dart';
import 'package:mood_journal/screens/note_edit/template_question/tempalte_question.dart';
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
  String? _backgroundImage;
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
    _backgroundImage = widget.note?.backgroundImage;
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
    // 1. Kiểm tra nếu cả tiêu đề và nội dung đều trống thì không lưu
    if (_titleController.text.trim().isEmpty &&
        _contentController.text.trim().isEmpty) {
      Navigator.pop(context);
      return;
    }

    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    final note = NoteModel(
      id: widget.note?.id ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      colorIndex: _selectedColorIndex,
      backgroundImage: _backgroundImage,
      isFavorite: _isFavorite,
      tags: _tags,
      isPinned: widget.note?.isPinned ?? false,
      attachments: _attachments,
      createdAt: widget.note?.createdAt ?? DateTime.now(),
      modifiedAt: DateTime.now(), // Luôn cập nhật thời gian sửa
    );

    try {
      if (widget.note == null) {
        await noteProvider.createNote(note);
      } else {
        await noteProvider.updateNote(note);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      // Xử lý lỗi nếu database có vấn đề
      debugPrint("Error saving note: $e");
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
            onTap: () {
              _showColorPicker();
            },
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
              _showOptionsMenu();
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
            const SizedBox(height: 8),
            if (_attachments.isNotEmpty) ...[
              SizedBox(
                height: 100,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _attachments.length,
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
                              cacheWidth: 200,
                            ),
                          ),
                          _editMode
                              ? Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _attachments.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          71,
                                          255,
                                          248,
                                          248,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: const Color.fromARGB(
                                          255,
                                          0,
                                          0,
                                          0,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
      bottomSheet: _buildBottomBar(),
    );
  }

  void _goToTemplatePage() async {
    // Chờ đợi kết quả trả về từ trang Template
    final String? selectedTemplate = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TemplateQuestionScreen()),
    );

    // Nếu có dữ liệu trả về, điền vào TextField
    if (selectedTemplate != null && mounted) {
      setState(() {
        // Thêm vào cuối nội dung hiện tại
        _contentController.text += "\n$selectedTemplate";
      });
    }
  }

  Widget? _buildBottomBar() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: _editMode
          ? Container(
              key: const ValueKey('editBar'),
              height: 60,
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _showColorPicker();
                    },
                    icon: const Icon(Icons.image_outlined),
                  ),

                  IconButton(
                    icon: Icon(Icons.list_alt_outlined),
                    onPressed: () {
                      _goToTemplatePage();
                    },
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ColorPickerWidget(
        onColorSelected: (index) {
          setState(() {
            _selectedColorIndex = index;
          });
          Navigator.pop(context);
        },
        selectedColorIndex: _selectedColorIndex,
      ),
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.label_outline),
              title: Text('Add tag'),
              onTap: () {
                Navigator.pop(context);
                _showAddTagDialog();
              },
            ),
            if (widget.note != null)
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showAddTagDialog();
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showAddTagDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add tag'),
        content: TextField(
          controller: _tagController,
          decoration: InputDecoration(hintText: 'Enter tag name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => {Navigator.pop(context)},
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_tagController.text.isNotEmpty) {
                setState(() {
                  _tags.add(_tagController.text);
                });
                _tagController.clear();
              }
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
