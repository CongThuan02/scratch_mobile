import 'package:flutter/material.dart';

class Lesson {
  final String id;
  final String title;
  final String description;
  final IconData icon; // Using IconData for prototype
  final Color color; // Hex color for the card background
  final List<String> content; // Markdown or simple text content segments
  final List<String> practiceGuide; // Step-by-step practice instructions

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.content,
    required this.practiceGuide,
  });
}
