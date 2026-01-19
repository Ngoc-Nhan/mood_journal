import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey = "YOUR_GEMINI_API_KEY"; // Lấy tại Google AI Studio

  Future<String> getPsychologyFeedback(String userNote) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash', // Hoặc gemini-1.5-pro
        apiKey: apiKey,
      );

      // Thiết lập prompt để Gemini phản hồi như một chuyên gia
      final prompt = [
        Content.text(
          "Bạn là một chuyên gia tâm lý thấu cảm. Người dùng vừa viết một ghi chú như sau: '$userNote'. "
          "Hãy đưa ra một lời phản hồi ngắn gọn (dưới 100 chữ), mang tính an ủi, khích lệ và đưa ra một lời khuyên nhỏ về tâm trạng này.",
        ),
      ];

      final response = await model.generateContent(prompt);
      return response.text ??
          "Mình luôn lắng nghe bạn, hãy tiếp tục chia sẻ nhé.";
    } catch (e) {
      return "Ghi chú đã được lưu. Chúc bạn một ngày bình yên!";
    }
  }
}
