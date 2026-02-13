import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/block.dart';
import '../utils/scratch_colors.dart';
import 'scratch_block.dart';

class ScratchEditorLayout extends StatefulWidget {
  final List<Block> availableBlocks;
  final Widget workspace;
  final Widget stage;

  const ScratchEditorLayout({super.key, required this.availableBlocks, required this.workspace, required this.stage});

  @override
  State<ScratchEditorLayout> createState() => _ScratchEditorLayoutState();
}

class _ScratchEditorLayoutState extends State<ScratchEditorLayout> {
  BlockType _selectedCategory = BlockType.motion;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 1. Category Rail
        Container(
          width: 60,
          color: Colors.white,
          child: Column(
            children: [
              _buildCategoryIcon(BlockType.motion, 'Motion', ScratchColors.motion),
              _buildCategoryIcon(BlockType.looks, 'Looks', ScratchColors.looks),
              _buildCategoryIcon(BlockType.sound, 'Sound', ScratchColors.sound),
              _buildCategoryIcon(BlockType.events, 'Events', ScratchColors.events),
              _buildCategoryIcon(BlockType.control, 'Control', ScratchColors.control),
              _buildCategoryIcon(BlockType.sensing, 'Sensing', ScratchColors.sensing),
              _buildCategoryIcon(BlockType.operators, 'Operators', ScratchColors.operators),
              _buildCategoryIcon(BlockType.variables, 'Variables', ScratchColors.variables),
            ],
          ),
        ),

        // 2. Block Palette
        Container(
          width: 140, // Expanded for block visibility
          color: Colors.grey[100],
          child: ListView(
            padding: const EdgeInsets.all(8),
            children:
                widget.availableBlocks
                    .where((b) => b.type == _selectedCategory)
                    .map(
                      (block) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Draggable<Block>(
                          data: block,
                          feedback: Material(
                            color: Colors.transparent,
                            child: ScratchBlock(block: block, isPreview: true),
                          ),
                          childWhenDragging: Opacity(opacity: 0.5, child: ScratchBlock(block: block, isPreview: false)),
                          child: ScratchBlock(block: block, isPreview: false),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),

        // 3. Code Workspace & Stage (Split Vertically or Horizontally)
        Expanded(
          child: Column(
            children: [
              // Top: Stage (Collapsible or Fixed height)
              SizedBox(height: 200, child: widget.stage),
              const Divider(height: 1),
              // Bottom: Workspace
              Expanded(child: widget.workspace),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryIcon(BlockType type, String label, Color color) {
    final isSelected = _selectedCategory == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = type;
        });
      },
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 20, height: 20, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                color: isSelected ? color : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
