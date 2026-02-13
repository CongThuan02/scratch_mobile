import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/block.dart';

class ScratchBlock extends StatelessWidget {
  final Block block;
  final bool isPreview;

  const ScratchBlock({super.key, required this.block, this.isPreview = false});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScratchBlockPainter(color: block.color),
      child: Container(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 10,
          bottom: 14, // Extra space for the bottom notch
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(block.icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              block.text,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class ScratchBlockPainter extends CustomPainter {
  final Color color;

  ScratchBlockPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Dimensions for the puzzle notches
    const double notchWidth = 15.0;
    const double notchHeight = 4.0;
    const double cornerRadius = 4.0;
    const double leftPadding = 10.0; // Position of the top notch

    final path = Path();

    // Top Edge with Notch (Start from top-left)
    path.moveTo(cornerRadius, 0);

    // Top Notch
    path.lineTo(leftPadding, 0);
    path.lineTo(leftPadding + 3, notchHeight); // Down slope
    path.lineTo(leftPadding + notchWidth - 3, notchHeight); // Flat bottom
    path.lineTo(leftPadding + notchWidth, 0); // Up slope

    // Top right corner
    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    // Right Edge
    path.lineTo(size.width, size.height - cornerRadius - notchHeight); // Adjust for bottom area

    // Bottom right corner
    path.quadraticBezierTo(size.width, size.height - notchHeight, size.width - cornerRadius, size.height - notchHeight);

    // Bottom Edge with Notch (Matching top notch position)
    path.lineTo(leftPadding + notchWidth, size.height - notchHeight);
    path.lineTo(leftPadding + notchWidth - 3, size.height); // Down slope (outward)
    path.lineTo(leftPadding + 3, size.height); // Flat bottom (outward)
    path.lineTo(leftPadding, size.height - notchHeight); // Up slope

    // Bottom left corner
    path.lineTo(cornerRadius, size.height - notchHeight);
    path.quadraticBezierTo(0, size.height - notchHeight, 0, size.height - notchHeight - cornerRadius);

    // Left Edge
    path.lineTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    path.close();

    // Draw Shadow (Simple darker stroke or shadow)
    canvas.drawShadow(path.shift(const Offset(0, 2)), Colors.black.withOpacity(0.2), 2, true);

    canvas.drawPath(path, paint);

    // Optional: Draw a subtle highlight/stroke on top
    final strokePaint =
        Paint()
          ..color = Colors.black.withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
