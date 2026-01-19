import 'package:flutter/material.dart';

// Sử dụng để truyền nội dung template vào nhưng
// sử dụng truyền context thì dễ hơn
class EditorProvider extends ChangeNotifier {
  String _content = '';
  String get content => _content;

  void setContent(String content) {
    _content = content;
    notifyListeners();
  }

  void appendContent(String value) {
    if (_content.isEmpty) {
      _content = value;
    } else {
      _content += '\n$value';
    }
  }

  void clear() {
    _content = '';
    notifyListeners();
  }
}
