import 'package:flutter/foundation.dart';
import 'package:mood_journal/models/note_model.dart';
import 'package:mood_journal/models/tag_model.dart';
import 'package:mood_journal/repository/note_repository.dart';

class NoteProvider extends ChangeNotifier {
  final NoteRepository repository;
  List<NoteModel> _notes = [];
  List<TagModel> _tags = [];
  String _searchQuery = '';
  bool _isLoading = false;

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
