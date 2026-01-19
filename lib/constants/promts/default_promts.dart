import 'package:flutter/material.dart';
import 'package:mood_journal/models/promt_template.dart';

const defaultPrompts = [
  PromptTemplate(
    id: 'my_day',
    backgroundColor: Color(0xFFCDEEF8),
    backgroundImage: 'assets/images/bear.png',
    title: 'My day',
    preview: 'Every thing simple to write for a day',
    contents: [
      '🌤️ Hôm nay tôi biết ơn điều gì?',
      '😊 Ai đã làm cho ngày hôm nay của tôi tốt hơn và tại sao?',
      '💗 Nhỏ nhoi thôi, tôi cảm thấy...',
    ],
  ),
  PromptTemplate(
    id: 'thankful',
    backgroundColor: Color(0xFFDFF6FF),
    backgroundImage: 'assets/images/bear_white.png',
    title: 'Thankful',
    preview: 'Express your thankful every day',
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