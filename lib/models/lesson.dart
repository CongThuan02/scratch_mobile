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

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'colorValue': color.value,
      'content': content,
      'practiceGuide': practiceGuide,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map, String id) {
    int parseColor(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0xFF42A5F5;
      return 0xFF42A5F5;
    }

    int parseIconCode(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0xe84e;
      return 0xe84e;
    }

    List<String> parseList(dynamic value) {
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      if (value is String) {
        return [value];
      }
      return [];
    }

    return Lesson(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      icon: IconData(parseIconCode(map['iconCodePoint']), fontFamily: map['iconFontFamily'] ?? 'MaterialIcons'),
      color: Color(parseColor(map['colorValue'])),
      content: parseList(map['content']),
      practiceGuide: parseList(map['practiceGuide']),
    );
  }
}
