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
  PromptTemplate(
    id: 'self_reflection',
    backgroundColor: Color(0xFFFFF3E0),
    backgroundImage: 'assets/images/bear.png',
    title: 'Self Reflection',
    preview: 'Reflect on yourself and your feelings',
    contents: [
      '📝 Hôm nay tôi học được gì về bản thân mình?',
      '🌱 Một hành động nhỏ của tôi hôm nay mang ý nghĩa gì?',
      '💭 Tôi có thể cải thiện điều gì vào ngày mai?',
    ],
  ),
  PromptTemplate(
    id: 'mood_check',
    backgroundColor: Color(0xFFE8F5E9),
    backgroundImage: 'assets/images/theme1.png',
    title: 'Mood Check',
    preview: 'Notice your emotions',
    contents: [
      '🎈 Tôi cảm thấy thế nào ngay bây giờ?',
      '💬 Tại sao tôi cảm thấy như vậy?',
      '🌈 Tôi muốn cảm xúc này dẫn tôi đến đâu?',
    ],
  ),
  PromptTemplate(
    id: 'gratitude_small',
    backgroundColor: Color(0xFFFFEBEE),
    backgroundImage: 'assets/images/theme2.png',
    title: 'Little Gratitude',
    preview: 'Focus on small things you appreciate',
    contents: [
      '☕ Một điều nhỏ nhưng làm tôi hạnh phúc hôm nay',
      '👋 Ai đã khiến tôi cười?',
      '🌟 Một khoảnh khắc đơn giản nhưng đáng nhớ',
    ],
  ),
  PromptTemplate(
    id: 'goal_setting',
    backgroundColor: Color(0xFFE3F2FD),
    backgroundImage: 'assets/images/theme3.png',
    title: 'Daily Goals',
    preview: 'Set simple goals for today',
    contents: [
      '🎯 Mục tiêu quan trọng nhất hôm nay là gì?',
      '📌 Tôi cần tập trung vào điều gì?',
      '✅ Một việc nhỏ tôi muốn hoàn thành hôm nay',
    ],
  ),
  PromptTemplate(
    id: 'self_love',
    backgroundColor: Color(0xFFF3E5F5),
    backgroundImage: 'assets/images/theme6.png',
    title: 'Self Love',
    preview: 'Express love for yourself',
    contents: [
      '💖 Tôi yêu bản thân mình ở điểm nào nhất?',
      '🌸 Một việc tốt tôi đã làm cho chính mình hôm nay',
      '💡 Tôi tự nhủ điều gì để cảm thấy tự tin hơn?',
    ],
  ),
  PromptTemplate(
    id: 'mindfulness',
    backgroundColor: Color(0xFFE0F7FA),
    backgroundImage: 'assets/images/theme7.png',
    title: 'Mindfulness',
    preview: 'Be present in the moment',
    contents: [
      '🌬️ Tôi đang chú ý đến điều gì ngay lúc này?',
      '🕊️ Một âm thanh hoặc mùi hương khiến tôi bình yên',
      '💭 Tôi có thể thở sâu và thư giãn thế nào?',
    ],
  ),
  PromptTemplate(
    id: 'positivity',
    backgroundColor: Color(0xFFFFF9C4),
    backgroundImage: 'assets/images/theme8.png',
    title: 'Positive Vibes',
    preview: 'Focus on the positive things',
    contents: [
      '🌞 Một điều tốt đã xảy ra hôm nay',
      '💫 Một lời khen hay sự khích lệ tôi nhận được',
      '🌻 Một điều tôi mong muốn cho ngày mai',
    ],
  ),
  PromptTemplate(
    id: 'learning',
    backgroundColor: Color(0xFFD1C4E9),
    backgroundImage: 'assets/images/theme9.png',
    title: 'Learning',
    preview: 'Reflect on your lessons',
    contents: [
      '📚 Hôm nay tôi học được điều gì mới?',
      '💡 Một sai lầm tôi rút ra bài học',
      '🧠 Một kỹ năng hoặc kiến thức tôi muốn phát triển',
    ],
  ),
  PromptTemplate(
    id: 'connection',
    backgroundColor: Color(0xFFFFE0B2),
    backgroundImage: 'assets/images/theme10.gif',
    title: 'Connection',
    preview: 'Think about your relationships',
    contents: [
      '🤝 Ai làm tôi cảm thấy kết nối hôm nay?',
      '💬 Tôi đã nói lời gì ý nghĩa với người khác?',
      '💗 Một hành động nhỏ tôi dành cho người thân',
    ],
  ),
  PromptTemplate(
    id: 'joy_moments',
    backgroundColor: Color(0xFFC8E6C9),
    backgroundImage: 'assets/images/theme11.gif',
    title: 'Joyful Moments',
    preview: 'Notice what brings you joy',
    contents: [
      '😄 Khoảnh khắc nào khiến tôi mỉm cười hôm nay?',
      '🎶 Một điều đơn giản nhưng làm tôi vui',
      '🌈 Tôi có thể tạo thêm niềm vui như thế nào?',
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