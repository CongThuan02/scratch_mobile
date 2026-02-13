import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/block.dart';
import '../models/practice_level.dart';
import '../utils/constants.dart';
import '../widgets/scratch_block.dart';
import '../widgets/scratch_editor_layout.dart';

class PracticeScreen extends StatefulWidget {
  final PracticeLevel level;

  const PracticeScreen({super.key, required this.level});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final List<Block> _placedBlocks = [];

  void _checkSolution() {
    final placedIds = _placedBlocks.map((b) => b.id).toList();
    final solutionIds = widget.level.solutionBlockIds;

    bool isCorrect = placedIds.length == solutionIds.length;
    if (isCorrect) {
      for (int i = 0; i < placedIds.length; i++) {
        if (placedIds[i] != solutionIds[i]) {
          isCorrect = false;
          break;
        }
      }
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(isCorrect ? 'Thành công!' : 'Chưa chính xác'),
            content: Text(
              isCorrect ? 'Chúc mừng! Bạn đã hoàn thành thử thách.' : 'Hãy thử lại. Thứ tự các khối chưa đúng.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (isCorrect) Navigator.pop(context); // Go back to level list
                },
                child: const Text('Đóng'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.level.title, style: GoogleFonts.poppins(fontSize: 16)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _placedBlocks.clear();
              });
            },
          ),
          IconButton(icon: const Icon(Icons.play_arrow), onPressed: _checkSolution),
        ],
      ),
      body: ScratchEditorLayout(
        availableBlocks: widget.level.availableBlocks,
        stage: Container(
          color: Colors.white,
          child: Column(
            children: [
              // Stage Toolbar
              Container(
                height: 40,
                color: Colors.grey[200],
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const Icon(Icons.flag, color: Colors.green),
                    const SizedBox(width: 16),
                    const Icon(Icons.stop_circle, color: Colors.red),
                    const Spacer(),
                    const Icon(Icons.fullscreen),
                  ],
                ),
              ),
              // Stage Content (Preview)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.pets, size: 50, color: Colors.orange), // Scratch Cat Placeholder
                        const SizedBox(height: 8),
                        Text('Sân khấu', style: GoogleFonts.poppins(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        workspace: DragTarget<Block>(
          builder: (context, candidateData, rejectedData) {
            return Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  // Grid background
                  Positioned.fill(child: CustomPaint(painter: GridPainter())),
                  // Block List
                  ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _placedBlocks.length,
                    itemBuilder: (context, index) {
                      final block = _placedBlocks[index];
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          setState(() {
                            _placedBlocks.removeAt(index);
                          });
                        },
                        background: Container(color: Colors.red),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ScratchBlock(block: block, isPreview: false),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
          onWillAccept: (data) => true,
          onAccept: (data) {
            setState(() {
              _placedBlocks.add(data);
            });
          },
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.shade200
          ..strokeWidth = 1;

    const double spacing = 40;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
