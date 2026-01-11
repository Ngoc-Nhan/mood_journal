import 'package:mood_journal/models/promt_template.dart';

const defaultPrompts = [
  PromptTemplate(
    id: 'my_day',
    title: 'My day',
    contents: [
      '🌤️ Hôm nay tôi biết ơn điều gì?',
      '😊 Ai đã làm cho ngày hôm nay của tôi tốt hơn và tại sao',
      '💗 Nhỏ nho, tôi cảm thấy ...',
    ],
  ),
  PromptTemplate(
    id: 'thankful',
    title: 'Thankful',
    contents: [
      '🙏 Điều gì khiến tôi biết ơn hôm nay?',
      '✨ Một khoảnh khắc nhỏ làm tôi mỉm cười',
    ],
  ),
];


// Add
// void addPromptToEditor(
//   PromptTemplate template,
//   RichTextController controller,
// ) {
//   final text = template.contents.join('\n');
//   controller.insertText('\n$text\n');
// }