import 'package:flutter/foundation.dart';
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

  // Hàm gọi AI trực tiếp từ App
  Future<void> generateAIAdvice(String content) async {
    _isLoading = true;
    notifyListeners();

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
      _lastAIResponse = "Mình luôn lắng nghe bạn, hãy tiếp tục chia sẻ nhé.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 1. Thêm hàm Helper để nhóm dữ liệu (có thể để bên ngoài hoặc trong class)
  Map<String, List<NoteModel>> _groupNotes(List<NoteModel> allNotes) {
    Map<String, List<NoteModel>> groups = {};

    // Sắp xếp ghi chú mới nhất lên đầu trước khi nhóm
    allNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

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
