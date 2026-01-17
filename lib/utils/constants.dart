import 'package:intl/intl.dart';

class AppConstants {
  static const databaseName = 'mood_journal.db';
  static const int databaseVersion = 1;

  static const String tableNotes = 'notes';
  static const String tableNotesTags = 'note_tags';
  static const String tableTags = 'tags';
}

class DateUtils {
  static String formatFullDate(DateTime date) {
    return DateFormat("d 'thg' M, yyyy, HH:mm").format(date);
  }
}
