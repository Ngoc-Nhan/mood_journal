import 'package:mood_journal/models/note_model.dart';
import 'package:mood_journal/models/tag_model.dart';
import 'package:mood_journal/utils/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(AppConstants.databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${AppConstants.tableNotes} (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      mood_index INTEGER,
      tags TEXT,
      color_index INTEGER DEFAULT 0,
      is_pinned INTEGER DEFAULT 0,
      is_favorite INTEGER DEFAULT 0,
      created_at TEXT NOT NULL,
      modified_at TEXT NOT NULL,
      attachments TEXT,
      content_json TEXT,
      ai_response TEXT,
      ai_response_created_at TEXT,
      is_deleted INTEGER DEFAULT 0
    )
    ''');

    await db.execute('''
    CREATE TABLE ${AppConstants.tableTags} (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    color_index INTEGER DEFAULT 0
    )
    ''');

    await db.execute('''
    CREATE INDEX idx_notes_modified_at ON ${AppConstants.tableNotes}(modified_at DESC)
    ''');
    await db.execute('''
    CREATE INDEX idx_notes_pinned ON ${AppConstants.tableNotes}(is_pinned DESC)
    ''');
  }

  Future<String> insertNote(NoteModel note) async {
    final db = await database;
    await db.insert(
      AppConstants.tableNotes,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return note.id!;
  }

  Future<List<NoteModel>> getAllNotes() async {
    final db = await database;
    final result = await db.query(
      AppConstants.tableNotes,
      orderBy: 'is_pinned, modified_at DESC',
    );
    return result.map((map) => NoteModel.fromMap(map)).toList();
  }

  Future<NoteModel?> getNote(String id) async {
    final db = await database;
    final result = await db.query(
      AppConstants.tableNotes,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return NoteModel.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateNote(NoteModel note) async {
    final db = await database;
    return await db.update(
      AppConstants.tableNotes,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(String id) async {
    final db = await database;
    return await db.delete(
      AppConstants.tableNotes,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<NoteModel>> searchNotes(String query) async {
    final db = await database;
    final result = await db.query(
      AppConstants.tableNotes,
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query', '%$query'],
      orderBy: 'is_pinned DESC, modified_at DESC',
    );
    return result.map((map) => NoteModel.fromMap(map)).toList();
  }

  Future<List<NoteModel>> getNotesByDate(DateTime date) async {
    final db = await database;

    final start = DateTime(date.year, date.month, date.day).toUtc();
    final end = start.add(const Duration(days: 1));

    final result = await db.query(
      'notes',
      where: 'modified_at >= ? AND modified_at < ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'modified_at DESC',
    );

    return result.map(NoteModel.fromMap).toList();
  }

  Future<List<NoteModel>> getFavoriteNotes() async {
    final db = await database;
    final result = await db.query(
      AppConstants.tableNotes,
      where: 'is_favorite = ?',
      whereArgs: [1],
      orderBy: 'modified_at DESC',
    );
    return result.map((map) => NoteModel.fromMap(map)).toList();
  }

  Future<String> insertTag(TagModel tag) async {
    final db = await database;
    await db.insert(
      AppConstants.tableTags,
      tag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return tag.id!;
  }

  Future<List<TagModel>> getAllTags() async {
    final db = await database;
    final result = await db.query(AppConstants.tableTags);
    return result.map((map) => TagModel.fromMap(map)).toList();
  }

  Future<int> delelteTag(String id) async {
    final db = await database;
    return await db.delete(
      AppConstants.tableTags,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
