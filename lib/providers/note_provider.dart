import 'package:flutter/foundation.dart';
import 'package:mood_journal/models/note_model.dart';
import 'package:mood_journal/models/tag_model.dart';
import 'package:mood_journal/repository/note_repository.dart';
import 'package:intl/intl.dart';

class NoteProvider extends ChangeNotifier {
  final NoteRepository repository;
  List<NoteModel> _notes = [];
  List<TagModel> _tags = [];
  String _searchQuery = '';
  bool _isLoading = false;

  // 1. Thêm hàm Helper để nhóm dữ liệu (có thể để bên ngoài hoặc trong class)
  Map<String, List<NoteModel>> _groupNotes(List<NoteModel> allNotes) {
    Map<String, List<NoteModel>> groups = {};

    // Sắp xếp ghi chú mới nhất lên đầu trước khi nhóm
    allNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    for (var note in allNotes) {
      // Dùng định dạng ngày làm Key (VD: "15/01/2026")
      String dateKey = DateFormat('dd/MM/yyyy').format(note.createdAt);
      if (groups[dateKey] == null) groups[dateKey] = [];
      groups[dateKey]!.add(note);
    }
    return groups;
  }

  // 2. Tạo Getter để UI sử dụng. Nó sẽ tự động nhóm các ghi chú đã được filter (nếu có search)
  Map<String, List<NoteModel>> get groupedNotes {
    return _groupNotes(
      notes,
    ); // 'notes' ở đây là getter đã lọc theo searchQuery của bạn
  }

  List<NoteModel> get notes {
    List<NoteModel> filteredNotes = _notes;
    if (_searchQuery.isNotEmpty) {
      filteredNotes = _notes.where((note) {
        return note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            note.content.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    return filteredNotes;
  }

  String get searchQuery => _searchQuery;
  List<TagModel> get tags => _tags;
  bool get isLoading => _isLoading;

  NoteProvider({required this.repository}) {
    loadNotes();
    loadTags();
  }

  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();
    _notes = await repository.getAllNotes();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadTags() async {
    _tags = await repository.getAllTags();
  }

  Future<void> createNote(NoteModel note) async {
    await repository.createNote(note);
    await loadNotes();
  }

  Future<void> updateNote(NoteModel note) async {
    await repository.updateNote(note);
    await loadNotes();
  }

  Future<void> deleteNote(String id) async {
    await repository.deleteNote(id);
    await loadNotes();
  }

  Future<void> togglePinNote(String id) async {
    await repository.togglePinNote(id);
    await loadNotes();
  }

  Future<void> toggleFavoriteNote(String id) async {
    await repository.toggleFavoriteNote(id);
    await loadNotes();
  }

  Future<void> createTag(TagModel tag) async {
    await repository.createTag(tag);
    await loadTags();
  }

  Future<void> deleteTag(String id) async {
    await repository.deleteTag(id);
    await loadTags();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearchQuery() {
    _searchQuery = '';
    notifyListeners();
  }

  Future<void> getFavoriteNotes() async {
    _notes = await repository.getFavoriteNotes();
    notifyListeners();
  }

  Future<void> getNotesByDate(DateTime date) async {
    _notes = await repository.getNotesByDate(date);
    notifyListeners();
  }
}
