import 'package:flutter/material.dart';

class PromptTemplate {
  final String id;
  final Color backgroundColor;
  final String backgroundImage;
  final String title;
  final String preview;
  final List<String> contents;

  const PromptTemplate({
    required this.id,
    required this.backgroundColor,
    required this.backgroundImage,
    required this.title,
    required this.preview,
    required this.contents,
  });
}
