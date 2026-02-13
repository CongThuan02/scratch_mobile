import 'package:flutter/material.dart';

enum BlockType { motion, looks, sound, events, control, sensing, operators, variables, myBlocks }

class Block {
  final String id;
  final String text;
  final BlockType type;
  final Color color;
  final IconData icon;

  Block({required this.id, required this.text, required this.type, required this.color, required this.icon});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'type': type.toString().split('.').last,
      'colorValue': color.value,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
    };
  }

  factory Block.fromMap(Map<String, dynamic> map, String id) {
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

    return Block(
      id: id,
      text: map['text'] ?? '',
      type: BlockType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => BlockType.motion,
      ),
      color: Color(parseColor(map['colorValue'])),
      icon: IconData(parseIconCode(map['iconCodePoint']), fontFamily: map['iconFontFamily'] ?? 'MaterialIcons'),
    );
  }
}
