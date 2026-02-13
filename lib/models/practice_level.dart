import 'block.dart';

class PracticeLevel {
  final String id;
  final String title;
  final String description;
  final List<Block> availableBlocks;
  final List<String> solutionBlockIds; // Sequence of block IDs required to solve

  PracticeLevel({
    required this.id,
    required this.title,
    required this.description,
    required this.availableBlocks,
    required this.solutionBlockIds,
  });
}
