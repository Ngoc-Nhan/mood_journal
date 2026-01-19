import 'package:mood_journal/db/database_helper.dart';
import 'package:mood_journal/models/note_model.dart';
import 'package:mood_journal/models/tag_model.dart';
import 'package:uuid/uuid.dart';

class NoteRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();

  Future<String> createNote(NoteModel note) async {
    final noteWithId = note.copyWith(
      id: note.id ?? _uuid.v4(),
      modifiedAt: DateTime.now(),
    );
    return await _dbHelper.insertNote(noteWithId);
  }

  Future<List<NoteModel>> getAllNotes() async {
    return await _dbHelper.getAllNotes();
  }

  Future<NoteModel?> getNote(String id) async {
    return await _dbHelper.getNote(id);
  }

  Future<void> updateNote(NoteModel note) async {
    final updateNote = note.copyWith(modifiedAt: DateTime.now());
    await _dbHelper.updateNote(updateNote);
  }

  Future<void> deleteNote(String id) async {
    await _dbHelper.deleteNote(id);
  }

  Future<List<NoteModel>> searchNotes(String query) async {
    return await _dbHelper.searchNotes(query);
  }

  Future<List<NoteModel>> getNotesByDate(DateTime date) async {
    return await _dbHelper.getNotesByDate(date);
  }

  Future<void> togglePinNote(String id) async {
    final note = await getNote(id);
    if (note != null) {
      await updateNote(note.copyWith(isPinned: !note.isPinned));
    }
  }

  Future<void> toggleFavoriteNote(String id) async {
    final note = await getNote(id);
    if (note != null) {
      await updateNote(note.copyWith(isFavorite: !note.isFavorite));
    }
  }

  Future<String> createTag(TagModel tag) async {
    final tagWithId = tag.copyWith(id: tag.id ?? _uuid.v4());
    return await _dbHelper.insertTag(tagWithId);
  }

  Future<List<TagModel>> getAllTags() async {
    return await _dbHelper.getAllTags();
  }

  Future<void> deleteTag(String id) async {
    await _dbHelper.delelteTag(id);
  }

  Future<List<NoteModel>> getFavoriteNotes() async {
    return await _dbHelper.getFavoriteNotes();
  }
}
