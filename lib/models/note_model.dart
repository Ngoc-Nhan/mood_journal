import 'dart:convert';

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
  final String? mood;

  // 🔥 AI response
  final String? aiResponse;
  final DateTime? aiResponseCreatedAt;

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

    // 🔥 AI
    this.aiResponse,
    this.aiResponseCreatedAt, this.mood,
  }) : createdAt = createdAt ?? DateTime.now(),
       modifiedAt = modifiedAt ?? DateTime.now();

  // =======================
  // SQLite
  // =======================

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'mood_index': moodIndex,
      'tags': jsonEncode(tags),
      'color_index': colorIndex,
      'background_image': backgroundImage,
      'is_pinned': isPinned ? 1 : 0,
      'is_favorite': isFavorite ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'modified_at': modifiedAt.toIso8601String(),
      'attachments': jsonEncode(attachments),
      'content_json': contentJson,
      'is_deleted': isDeleted ? 1 : 0,

      // 🔥 AI
      'ai_response': aiResponse,
      'ai_response_created_at': aiResponseCreatedAt?.toIso8601String(),
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      moodIndex: map['mood_index'],
      tags: map['tags'] != null
          ? List<String>.from(jsonDecode(map['tags']))
          : [],
      colorIndex: map['color_index'] ?? 0,
      backgroundImage: map['background_image'],
      isPinned: map['is_pinned'] == 1,
      isFavorite: map['is_favorite'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      modifiedAt: DateTime.parse(map['modified_at']),
      attachments: map['attachments'] != null
          ? List<String>.from(jsonDecode(map['attachments']))
          : [],
      contentJson: map['content_json'],
      isDeleted: map['is_deleted'] == 1,

      // 🔥 AI
      aiResponse: map['ai_response'],
      aiResponseCreatedAt: map['ai_response_created_at'] != null
          ? DateTime.parse(map['ai_response_created_at'])
          : null,
    );
  }

  // =======================
  // Copy
  // =======================

  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    int? moodIndex,
    List<String>? tags,
    int? colorIndex,
    String? backgroundImage,
    bool? isPinned,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? modifiedAt,
    List<String>? attachments,
    String? contentJson,
    bool? isDeleted,

    // 🔥 AI
    String? aiResponse,
    DateTime? aiResponseCreatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      moodIndex: moodIndex ?? this.moodIndex,
      tags: tags ?? this.tags,
      colorIndex: colorIndex ?? this.colorIndex,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      attachments: attachments ?? this.attachments,
      contentJson: contentJson ?? this.contentJson,
      isDeleted: isDeleted ?? this.isDeleted,

      // 🔥 AI
      aiResponse: aiResponse ?? this.aiResponse,
      aiResponseCreatedAt: aiResponseCreatedAt ?? this.aiResponseCreatedAt,
    );
  }

  // =======================
  // JSON (API / Sync)
  // =======================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'moodIndex': moodIndex,
      'tags': tags,
      'colorIndex': colorIndex,
      'backgroundImage': backgroundImage,
      'isPinned': isPinned,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'attachments': attachments,
      'contentJson': contentJson,
      'isDeleted': isDeleted,

      // 🔥 AI
      'aiResponse': aiResponse,
      'aiResponseCreatedAt': aiResponseCreatedAt?.toIso8601String(),
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      moodIndex: json['moodIndex'],
      tags: List<String>.from(json['tags'] ?? []),
      colorIndex: json['colorIndex'] ?? 0,
      isPinned: json['isPinned'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: DateTime.parse(json['modifiedAt']),
      attachments: List<String>.from(json['attachments'] ?? []),
      contentJson: json['contentJson'],
      isDeleted: json['isDeleted'] ?? false,

      // 🔥 AI
      aiResponse: json['aiResponse'],
      aiResponseCreatedAt: json['aiResponseCreatedAt'] != null
          ? DateTime.parse(json['aiResponseCreatedAt'])
          : null,
    );
  }
}
