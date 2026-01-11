class NoteModel {
  final String? id;
  final String title;
  final String content;
  final int? moodIndex;
  final List<String> tags;
  final int colorIndex;
  final String? backgroundImage;
  final bool isPinned;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final List<String> attachments;
  final String? contentJson;
  final bool isDeleted;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    this.moodIndex,
    this.tags = const [],
    this.colorIndex = 0,
    this.backgroundImage,
    this.isPinned = false,
    this.isFavorite = false,
    DateTime? createdAt,
    DateTime? modifiedAt,
    this.attachments = const [],
    this.contentJson,
    this.isDeleted = false,
  }) : createdAt = createdAt ?? DateTime.now(),
       modifiedAt = modifiedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'mood_index': moodIndex,
      'tags': tags,
    };
  }
}
