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

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'availableBlocks': availableBlocks.map((b) => b.toMap()).toList(), // Embed blocks for simplicity
      'solutionBlockIds': solutionBlockIds,
    };
  }

  factory PracticeLevel.fromMap(Map<String, dynamic> map, String id) {
    return PracticeLevel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      availableBlocks:
          (map['availableBlocks'] as List<dynamic>?)
              ?.map(
                (b) => Block.fromMap(b as Map<String, dynamic>, b['id'] ?? ''),
              ) // ID might be tricky if embedded without explicit ID field in map, but Block.toMap doesn't save ID.
              // Wait, Block.toMap didn't save ID. Let's fix Block.toMap first or handle it here.
              // Actually, looking at Block.toMap, it doesn't save ID. We should probably save ID in toMap.
              // For now, let's assume we can generate/read ID or it's part of the embedded map if we modify Block.
              // Let's modify Block.toMap to include ID for safer embedding.
              .toList() ??
          [],
      solutionBlockIds: List<String>.from(map['solutionBlockIds'] ?? []),
    );
  }
}
