import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/practice_level.dart';
import '../utils/constants.dart';
import '../utils/dummy_data.dart';
import 'scratch_webview_screen.dart';

class PracticeListScreen extends StatelessWidget {
  const PracticeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Thực hành', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.secondary,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: dummyPracticeLevels.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final level = dummyPracticeLevels[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              // ignore: deprecated_member_use
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.code, color: AppColors.secondary),
              ),
              title: Text(level.title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.text)),
              subtitle: Text(
                level.description,
                style: GoogleFonts.poppins(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ScratchWebViewScreen()));
              },
            ),
          );
        },
      ),
    );
  }
}
