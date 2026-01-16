class PromptTemplate {
  final String id;
  final String color;
  final String background;
  final String title;
  final List<String> contents;

  const PromptTemplate({
    required this.id,
    required this.color,
    required this.background,
    required this.title,
    required this.contents,
  });
}
