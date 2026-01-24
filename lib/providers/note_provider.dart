import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mood_journal/models/note_model.dart';
import 'package:mood_journal/models/tag_model.dart';
import 'package:mood_journal/repository/note_repository.dart';
import 'package:intl/intl.dart';

class NoteProvider extends ChangeNotifier {
  final NoteRepository repository;
  List<NoteModel> _notes = [];
  List<TagModel> _tags = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String? _lastAIResponse;
  String? get lastAIResponse => _lastAIResponse;

  // For Insights
  String? _insightsSummary;
  String? get insightsSummary => _insightsSummary;
  bool _isGeneratingInsights = false;
  bool get isGeneratingInsights => _isGeneratingInsights;

  // Hàm gọi AI trực tiếp từ App
  Future<void> generateAIAdvice(String content) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Khởi tạo Model (Sử dụng gemini-1.5-flash để phản hồi nhanh)
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: '${dotenv.env['GEMINI_API_KEY']}',
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
      _lastAIResponse = "Mình luôn lắng nghe bạn, hãy tiếp tục chia sẻ nhé.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  final Map<int, String> _moodMap = {
    4: 'Vui vẻ',
    3: 'Hào hứng',
    2: 'Buồn',
    1: 'Tức giận',
    0: 'Lo lắng',
  };
  Future<void> generateInsightsSummary() async {
    if (_isGeneratingInsights) return;

    _isGeneratingInsights = true;
    _insightsSummary =
        "Chào bạn mới! Hãy bắt đầu hành trình ghi lại cảm xúc của mình để Liptwo có thể đồng hành cùng bạn nhé. 🌱";
    notifyListeners();

    try {
      if (_notes.isEmpty) {
        _insightsSummary =
            "Chào bạn mới! Hãy bắt đầu hành trình ghi lại cảm xúc của mình để Liptwo có thể đồng hành cùng bạn nhé. 🌱";
        _isGeneratingInsights = false;
        notifyListeners();
        return;
      }

      // Data preparation
      final totalNotes = _notes.length;
      final moodCounts = <int, int>{};
      for (var note in _notes) {
        if (note.moodIndex != null) {
          moodCounts[note.moodIndex!] = (moodCounts[note.moodIndex!] ?? 0) + 1;
        }
      }

      String moodSummary = "chưa có dữ liệu";
      if (moodCounts.isNotEmpty) {
        final sortedMoods = moodCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final mostCommonMoodName =
            _moodMap[sortedMoods.first.key] ?? "không xác định";
        moodSummary =
            "Trong $totalNotes ghi chú, bạn có vẻ thường cảm thấy '$mostCommonMoodName' nhất.";
      }

      final lastNoteDate = _notes.first.createdAt;
      final daysSinceLastNote = DateTime.now().difference(lastNoteDate).inDays;
      String lastEntrySummary = "Hôm nay bạn đã ghi chú rồi, tuyệt vời!";
      if (daysSinceLastNote > 0) {
        lastEntrySummary =
            "Đã $daysSinceLastNote ngày rồi bạn chưa viết đó, Liptwo nhớ bạn.";
      }

      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: '${dotenv.env['GEMINI_API_KEY']}',
      );

      final prompt =
          "Bạn là 'Liptwo', một người bạn tâm giao luôn thấu cảm và tinh tế. Dựa vào các số liệu sau đây về người dùng, hãy đưa ra một lời nhận xét ngắn gọn (khoảng 2-3 câu) thật ý nghĩa, ấm áp và mang tính cá nhân hóa để hiển thị trên màn hình Insight của họ. Hãy linh hoạt thay đổi văn phong dựa trên dữ liệu."
          "\n\n**Dữ liệu:**"
          "\n- **Tổng số ghi chú:** $totalNotes"
          "\n- **Thống kê tâm trạng:** $moodSummary"
          "\n- **Lần cuối ghi chú:** $lastEntrySummary"
          "\n\n**Nhiệm vụ của bạn:**"
          "\n1. **Nếu người dùng viết đều đặn (dưới 2 ngày chưa viết):** Khen ngợi sự chăm chỉ của họ. Dựa vào tâm trạng chủ đạo để đưa ra lời động viên hoặc chia vui. Ví dụ: 'Bạn thật tuyệt vời khi giữ thói quen viết mỗi ngày! Nhìn lại, Liptwo thấy bạn đã có nhiều khoảnh khắc vui vẻ đó. ✨'"
          "\n2. **Nếu người dùng đã lâu không viết (từ 2 ngày trở lên):** Nhẹ nhàng nhắc nhở và khuyến khích họ quay lại. Ví dụ: 'Đã $daysSinceLastNote ngày rồi chúng ta chưa trò chuyện. Liptwo nhớ những câu chuyện của bạn, hôm nay bạn cảm thấy thế nào?'"
          "\n3. **Nếu họ là người mới (dưới 5 ghi chú):** Chào mừng và khuyến khích họ bắt đầu hành trình. Ví dụ: 'Chào mừng bạn đến với góc nhỏ của chúng mình! Thật tuyệt khi bạn đã bắt đầu ghi lại những cảm xúc đầu tiên. 🌱'"
          "\n\n**Yêu cầu:**"
          "\n- Giọng văn: Luôn gần gũi, ấm áp, không sáo rỗng."
          "\n- Ngôn ngữ: Tiếng Việt."
          "\n- Sử dụng icon phù hợp. ✨🫂🌱"
          "\n\n**Hãy tạo ra một phản hồi duy nhất cho phần Tip Card ngay bây giờ.**";

      final response = await model.generateContent([Content.text(prompt)]);
      _insightsSummary = response.text;
    } catch (e) {
      debugPrint("Lỗi tạo insight Gemini: $e");
      // _insightsSummary =
      //     "Có lỗi nhỏ xảy ra khi Liptwo đang viết. Bạn thử lại sau nhé.";
    } finally {
      _isGeneratingInsights = false;
      notifyListeners();
    }
  }

  // 1. Thêm hàm Helper để nhóm dữ liệu (có thể để bên ngoài hoặc trong class)
  Map<String, List<NoteModel>> _groupNotes(List<NoteModel> allNotes) {
    Map<String, List<NoteModel>> groups = {};

    // Sắp xếp ghi chú mới nhất lên đầu trước khi nhóm
    // allNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    // allNotes.sort((a, b) {
    //   if (a.isPinned && !b.isPinned) {
    //     return -1; // a comes first
    //   } else if (!a.isPinned && b.isPinned) {
    //     return 1; // b comes first
    //   } else {
    //     // Both are pinned or both are unpinned, sort by date
    //     return b.createdAt.compareTo(a.createdAt);
    //   }
    // });

    for (var note in allNotes) {
      // Dùng định dạng ngày làm Key (VD: "15/01/2026")
      String dateKey = DateFormat('dd/MM/yyyy').format(note.createdAt);
      if (groups[dateKey] == null) groups[dateKey] = [];
      groups[dateKey]!.add(note);
    }
    return groups;
  }

  // 2. Tạo Getter để UI sử dụng. Nó sẽ tự động nhóm các ghi chú đã được filter (nếu có search)
  Map<String, List<NoteModel>> get groupedNotes {
    return _groupNotes(
      notes,
    ); // 'notes' ở đây là getter đã lọc theo searchQuery của bạn
  }

  List<NoteModel> get notes {
    List<NoteModel> filteredNotes = _notes;
    if (_searchQuery.isNotEmpty) {
      filteredNotes = _notes.where((note) {
        return note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            note.content.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // //     // Sort by isPinned (true comes first), then by createdAt (newest first)
    // filteredNotes.sort((a, b) {
    //   if (a.isPinned && !b.isPinned) {
    //     return -1; // a comes first
    //   } else if (!a.isPinned && b.isPinned) {
    //     return 1; // b comes first
    //   } else {
    //     // Both are pinned or both are unpinned, sort by date
    //     return b.createdAt.compareTo(a.createdAt);
    //   }
    // });
    return filteredNotes;
  }

  // Future<void> getAIAdviceDirectly(String content) async {
  //   // Khởi tạo model trực tiếp trên App
  //   final model = GenerativeModel(
  //     model: 'gemini-1.5-flash',
  //     apiKey: 'YOUR_GEMINI_API_KEY', // Hãy dùng biến môi trường để bảo mật
  //   );

  //   final prompt =
  //       "Bạn là một chuyên gia tâm lý thấu cảm. Người dùng vừa viết một ghi chú như sau: '$content'. "
  //       "Hãy đưa ra một lời phản hồi ngắn gọn (dưới 100 chữ), mang tính an ủi, khích lệ và đưa ra một lời khuyên nhỏ về tâm trạng này.";
  //   final response = await model.generateContent([Content.text(prompt)]);

  //   lastAIResponse = response.text;
  //   notifyListeners();
  // }

  String get searchQuery => _searchQuery;
  List<TagModel> get tags => _tags;
  bool get isLoading => _isLoading;

  NoteProvider({required this.repository}) {
    loadNotes();
    loadTags();
  }

  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();
    _notes = await repository.getAllNotes();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadTags() async {
    _tags = await repository.getAllTags();
  }

  Future<void> createNote(NoteModel note) async {
    await repository.createNote(note);
    await loadNotes();
  }

  Future<void> updateNote(NoteModel note) async {
    await repository.updateNote(note);
    await loadNotes();
  }

  Future<void> deleteNote(String id) async {
    await repository.deleteNote(id);
    await loadNotes();
  }

  Future<void> togglePinNote(String id) async {
    await repository.togglePinNote(id);
    await loadNotes();
  }

  Future<void> toggleFavoriteNote(String id) async {
    await repository.toggleFavoriteNote(id);
    await loadNotes();
  }

  Future<void> createTag(TagModel tag) async {
    await repository.createTag(tag);
    await loadTags();
  }

  Future<void> deleteTag(String id) async {
    await repository.deleteTag(id);
    await loadTags();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearchQuery() {
    _searchQuery = '';
    notifyListeners();
  }

  Future<void> getFavoriteNotes() async {
    _notes = await repository.getFavoriteNotes();
    notifyListeners();
  }

  Future<void> getNotesByDate(DateTime date) async {
    _notes = await repository.getNotesByDate(date);
    notifyListeners();
  }
}
