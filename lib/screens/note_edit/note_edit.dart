import 'dart:io';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_journal/components/color_picker.dart';
import 'package:mood_journal/constants/mood_default.dart';
import 'package:mood_journal/models/note_model.dart';
import 'package:mood_journal/providers/note_provider.dart';
import 'package:mood_journal/screens/note_edit/template_question/tempalte_question.dart';
import 'package:mood_journal/theme/app_colors.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

// YouTube
import 'package:mood_journal/services/youtube_music.dart';
import 'package:mood_journal/utils/youtube_launcher.dart';

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
  int? _selectedMood;
  late DateTime _selectedDate;
  String? _backgroundImage;
  late int _selectedColorIndex;
  late bool _isFavorite;
  List<String> _tags = [];
  List<String> _attachments = [];
  String? _aiResponse;
  DateTime? _aiResponseCreatedAt;
  final _tagController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Future<List<YouTubeMusic>> _musicFuture;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    _selectedMood = widget.note?.moodIndex;
    _selectedDate = widget.note?.modifiedAt ?? DateTime.now();
    _backgroundImage = widget.note?.backgroundImage;
    _selectedColorIndex = widget.note?.colorIndex ?? 0;
    _backgroundImage = widget.note?.backgroundImage;
    _isFavorite = widget.note?.isFavorite ?? false;
    _tags = List.from(widget.note?.tags ?? []);
    _attachments = List.from(widget.note?.attachments ?? []);
    _aiResponse = widget.note?.aiResponse;
    _aiResponseCreatedAt = widget.note?.aiResponseCreatedAt;
    _musicFuture = YouTubeService.searchMusic("nhạc chill chữa lành");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<bool> hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> _saveNote() async {
    // 1. Kiểm tra nếu cả tiêu đề và nội dung đều trống thì không lưu
    if (_titleController.text.trim().isEmpty &&
        _contentController.text.trim().isEmpty) {
      Navigator.pop(context);
      return;
    }
    // setState(() {
    //   _isSaving = true;
    //   _editMode = false;
    // });
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    // final note = NoteModel(
    //   id: widget.note?.id ?? const Uuid().v4(),
    //   title: _titleController.text.trim(),
    //   content: _contentController.text.trim(),
    //   moodIndex: _selectedMood,
    //   colorIndex: _selectedColorIndex,
    //   backgroundImage: _backgroundImage,
    //   isFavorite: _isFavorite,
    //   tags: _tags,
    //   isPinned: widget.note?.isPinned ?? false,
    //   attachments: _attachments,
    //   createdAt: _selectedDate,
    //   modifiedAt: _selectedDate, // Luôn cập nhật thời gian sửa
    // );

    try {
      if (widget.note == null && _aiResponse == null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: Center(
              child: CircularProgressIndicator(),

              // Text(
              //   'Đang lưu và chờ phản hồi từ AI...',
              //   style: TextStyle(fontSize: 16),
              // ),
            ),
          ),
        );

        // 1. Gọi SDK để lấy phản hồi AI
        await noteProvider.generateAIAdvice(_contentController.text.trim());

        if (mounted) {
          Navigator.pop(context); // Tắt Loading

          // 2. Lấy dữ liệu từ Provider sau khi gọi xong
          _aiResponse = noteProvider.lastAIResponse;
          if (_aiResponse != null) {
            _aiResponseCreatedAt =
                DateTime.now(); // Ghi nhận thời gian tạo AI response
            await _showAIResultPopup(context, _aiResponse!);
          }
        }
      }
      final note = NoteModel(
        id: widget.note?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        moodIndex: _selectedMood,
        colorIndex: _selectedColorIndex,
        backgroundImage: _backgroundImage,
        isFavorite: _isFavorite,
        tags: _tags,
        isPinned: widget.note?.isPinned ?? false,
        attachments: _attachments,
        createdAt: _selectedDate,
        modifiedAt: _selectedDate,
        // Gán giá trị AI vào đây để lưu xuống DB
        aiResponse: _aiResponse ?? widget.note?.aiResponse,
        aiResponseCreatedAt:
            _aiResponseCreatedAt ?? widget.note?.aiResponseCreatedAt,
      );
      if (widget.note == null) {
        await noteProvider.createNote(note);
      } else {
        await noteProvider.updateNote(note);
      }

      // Thoát màn hình sau khi hoàn tất
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            _editMode ? {await _saveNote()} : Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showAIResultPopup(
                context,
                widget.note?.aiResponse ??
                    'Mình luôn lắm nghe, hãy viết thêm nhiều nhé',
              );
            },
            icon: Icon(Icons.message),
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
          // IconButton(onPressed: _pickImage, icon: Icon(Icons.image_outlined)),
          IconButton(
            onPressed: () {
              _showOptionsMenu();
            },
            icon: Icon(Icons.more_vert),
          ),

          IconButton(
            // onPressed: () {
            //   setState(() {
            //     _editMode = !_editMode;
            //   });
            //   _editMode ? null : _saveNote();
            // },
            onPressed: () async {
              if (_editMode) {
                await _saveNote();
                // Không cần setState ở đây vì _saveNote sẽ đóng màn hình
              } else {
                setState(() {
                  _editMode = true;
                });
              }
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
            if (_backgroundImage != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  _backgroundImage!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            // Display date
            _editMode
                ? GestureDetector(
                    onTap: _pickDateTime,
                    child: Row(
                      children: [
                        Text(
                          DateFormat(
                            "d 'thg' M,  yyyy, HH:mm",
                          ).format(_selectedDate),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, size: 18),
                      ],
                    ),
                  )
                : Text(
                    DateFormat("d 'thg' M,  yyyy, HH:mm").format(_selectedDate),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

            //mood selecter
            // Trong Column của build()
            _editMode
                ? _buildMoodPicker(context) // Chế độ chỉnh sửa: Có thể nhấn
                : _selectedMood != null
                ? _buildMoodDisplay()
                : const SizedBox.shrink(), // Chế độ xem: Chỉ hiện icon

            const SizedBox(height: 16),
            // const SizedBox(height: 16),
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
                          GestureDetector(
                            onTap: () =>
                                _openImage(context, _attachments[index]),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_attachments[index]),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                cacheWidth: 200,
                              ),
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

  void _openImage(BuildContext context, String filePath) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      pageBuilder: (_, __, ___) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black26),
              ),
              Center(
                child: Image.file(
                  File(filePath),

                  width: 300,
                  fit: BoxFit.contain,
                  // alignment: Alignment.topCenter,
                  cacheWidth: 200,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoodDisplay() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        // Mặc định là icon neutral nếu moodIndex chưa được chọn (null)
        moodIcons[widget.note?.moodIndex ?? _selectedMood ?? 2],
        size: 30,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildMoodPicker(BuildContext context) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            showPopover(
              context: context,
              direction: PopoverDirection.bottom,
              width: 300,
              height: 100,
              arrowHeight: 10,
              backgroundColor: Colors.white,
              bodyBuilder: (context) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Your mood in this moment?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(moodIcons.length, (index) {
                      return IconButton(
                        icon: Icon(
                          moodIcons[index],
                          color: _selectedMood == index
                              ? Colors.blue
                              : Colors.black54,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedMood = index;
                          });
                          Navigator.pop(context);
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E0E0), // Màu hồng nhạt như ảnh mẫu
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              moodIcons[_selectedMood ?? 2], // Hiển thị mood đang chọn
              size: 30,
            ),
          ),
        );
      },
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final noteColor = isDark
        ? AppColors.noteColorsDark[_selectedColorIndex]
        : AppColors.noteColors[_selectedColorIndex];
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: _editMode
          ? Container(
              key: const ValueKey('editBar'),
              height: 60,
              color: isDark
                  ? AppColors.backgroundDark
                  : AppColors.backgroundLight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.lightbulb),
                    onPressed: () {
                      _goToTemplatePage();
                    },
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     _showColorPicker();
                  //   },
                  //   icon: const Icon(Icons.image_outlined),
                  // ),
                  IconButton(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image_outlined),
                  ),
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
              ).deleteNote(widget.note?.id ?? '');
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
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
                  _showDeleteConfirmationDialog(context);
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

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );

    if (time == null) return;

    setState(() {
      _selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  // void _showIconResponeDialog(BuildContext context) {
  // Future<void> _showAIResultPopup(BuildContext context, String response) async {
  //   await showDialog(
  //     context: context,
  //     builder: (context) => Dialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Stack(
  //             children: [
  //               // Ảnh minh họa phía trên (Sliver-like)
  //               ClipRRect(
  //                 borderRadius: const BorderRadius.vertical(
  //                   top: Radius.circular(20),
  //                 ),
  //                 child: Image.asset(
  //                   'assets/images/bear.png', // Thay bằng ảnh của bạn
  //                   height: 150,
  //                   width: double.infinity,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               Positioned(
  //                 right: 8,
  //                 top: 8,
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: const CircleAvatar(
  //                     backgroundColor: Colors.black26,
  //                     child: Icon(Icons.close, color: Colors.white),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // Avatar nhân vật AI
  //                 Column(
  //                   children: [
  //                     const Text(
  //                       "Liptwo",
  //                       style: TextStyle(
  //                         color: Colors.redAccent,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     Image.asset('assets/images/shinba.png', width: 50),
  //                   ],
  //                 ),
  //                 const SizedBox(width: 12),
  //                 // Nội dung phản hồi
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const SizedBox(height: 4),
  //                       Text(
  //                         response,
  //                         style: const TextStyle(fontSize: 14, height: 1.4),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );

  //   Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: [
  //       Text('Hãy thưởng thức bản nhạc phù hợp với tâm trạng của bạn!'),
  //     ],
  //   );
  // }
  Future<void> _showAIResultPopup(BuildContext context, String response) async {
    final online = await hasInternet();
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final height = MediaQuery.of(context).size.height;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            height: height * 0.8, // 🔒 giới hạn chiều cao
            child: Column(
              children: [
                // ===== HEADER =====
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Image.asset(
                        'assets/images/bear.png',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          backgroundColor: Colors.black26,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),

                // ===== BODY (SCROLL) =====
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (online)
                          // AI MESSAGE
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    "Liptwo",
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/shinba.png',
                                    width: 50,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  response,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 20),

                        // 🎧 MUSIC TITLE
                        const Text(
                          '🎧 Nhạc gợi ý cho tâm trạng của bạn',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),

                        // 🎶 MUSIC LIST
                        FutureBuilder<List<YouTubeMusic>>(
                          future: _musicFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(12),
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Text("Lỗi tải nhạc: ${snapshot.error}");
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text(
                                "Không tìm thấy nhạc phù hợp 🌱",
                              );
                            }

                            final musics = snapshot.data!;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: musics.length,
                              itemBuilder: (context, index) {
                                final music = musics[index];

                                return InkWell(
                                  onTap: () => openYoutubeVideo(music.videoId),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            music.thumbnail,
                                            width: 64,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            music.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.play_circle_fill,
                                          color: Colors.redAccent,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // void _showMoodPicker() {
  //   showAboutDialog(
  //     context: context,
  //     // backgroundColor: Colors.transparent,
  //     children: [
  //       Center(
  //         child: Container(
  //           width: 300,
  //           padding: const EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(16),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Text(
  //                 "Your mood in this moment?",
  //                 style: TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //               const SizedBox(height: 12),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: List.generate(5, (index) {
  //                   final icons = [
  //                     Icons.sentiment_very_dissatisfied,
  //                     Icons.sentiment_dissatisfied,
  //                     Icons.sentiment_neutral,
  //                     Icons.sentiment_satisfied,
  //                     Icons.sentiment_very_satisfied,
  //                   ];

  //                   return IconButton(
  //                     icon: Icon(
  //                       icons[index],
  //                       size: 28,
  //                       color: _selectedMood == index
  //                           ? Colors.orange
  //                           : Colors.grey,
  //                     ),
  //                     onPressed: () {
  //                       setState(() => _selectedMood = index);
  //                       Navigator.pop(context);
  //                     },
  //                   );
  //                 }),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
