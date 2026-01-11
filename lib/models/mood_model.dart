class MoodModel {
  final int id;
  final String name;
  final String icon;

  const MoodModel({required this.id, required this.name, required this.icon});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'icon': icon};
  }

  factory MoodModel.fromMap(Map<String, dynamic> map) {
    return MoodModel(id: map['id'], name: map['name'], icon: map['icon']);
  }
}
