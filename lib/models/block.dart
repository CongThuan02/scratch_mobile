import 'package:flutter/material.dart';

enum BlockType { motion, looks, sound, events, control, sensing, operators, variables, myBlocks }

class Block {
  final String id;
  final String text;
  final BlockType type;
  final Color color;
  final IconData icon;

  Block({required this.id, required this.text, required this.type, required this.color, required this.icon});
}
