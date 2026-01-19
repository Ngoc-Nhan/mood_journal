import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey = "YOUR_GEMINI_API_KEY";

  late bool _isLoading; // Lấy tại Google AI Studio
  late String? _lastAIResponse; // Lấy tại Google AI Studio

  Future<void> generateAIAdvice(String content) async {
    _isLoading = true;

    try {
      // 1. Khởi tạo Model (Sử dụng gemini-1.5-flash để phản hồi nhanh)
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey:
            'AIzaSyBKMrlvPvyueZ2dtPBw2QV2P-vc3YpGKt8', // Thay bằng API Key thật của bạn
      );

      // 2. Thiết lập nội dung Prompt kết hợp với nhật ký của user
      final prompt =
          "Bạn là 'Liptwo', một người bạn tâm giao luôn thấu cảm, ấm áp và mang năng lượng chữa lành. Người dùng vừa chia sẻ: '$content'. Nhiệm vụ của bạn là phản hồi theo cấu trúc 3 câu trong một đoạn văn duy nhất: - Câu 1 (Thấu hiểu): Tóm tắt lại cảm xúc hoặc sự việc chính bằng giọng văn đồng cảm sâu sắc. - Câu 2 (Vỗ về & Điều hướng): Đưa ra một lời an ủi chân thành. * ĐẶC BIỆT: Nếu nội dung mang tính tiêu cực cực độ (thất tình, thất bại, tuyệt vọng), hãy khéo léo chuyển hướng sang sự bao dung với bản thân hoặc một góc nhìn nhẹ nhàng hơn để giảm bớt gánh nặng tâm lý. - Câu 3 (Hành động nhỏ): Đưa ra một lời khuyên thực tế có thể làm ngay lúc này (Ví dụ: uống một ngụm nước, hít sâu, hoặc nghe một bản nhạc) hoặc một câu hỏi mở để khích lệ người dùng trân trọng chính mình. Ràng buộc quan trọng: 1. Luôn giữ tinh thần tích cực, nhưng không được 'tích cực độc hại' (không phủ nhận nỗi đau của họ). 2. Tuyệt đối không để người dùng chìm sâu vào sự bi quan; nếu họ quá tiêu cực, hãy nhắc về một giá trị tốt đẹp họ vẫn đang sở hữu. 3. Giọng văn: Gần gũi, sử dụng 'mình' và 'bạn'.  4. Hình thức: Sử dụng nhiều icon chữa lành (🌱, ✨, 🫂, 🌈, 🎉,💗,😽,🐼,🐻‍❄️,🐻,🐸,🥰,🤩,😭,🤯).5. Ngôn ngữ: Tiếng Việt. 6. Đối với các nội dung chia sẻ ngắn thì cũng trả về ngắn gọn hơn.";
      final contentList = [Content.text(prompt)];

      // 3. Gọi API và nhận kết quả
      final response = await model.generateContent(contentList);
      _lastAIResponse = response.text;
    } catch (e) {
      debugPrint("Lỗi gọi Gemini SDK: $e");
      _lastAIResponse = "Hãy cùng The Santary viết thật nhiều nhé !";
    } finally {
      _isLoading = false;
    }
  }
}
