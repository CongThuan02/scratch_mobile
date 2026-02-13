import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lesson.dart';
import '../utils/ad_helper.dart'; // Import AdHelper
import '../utils/constants.dart';
import '../utils/dummy_data.dart';
import 'lesson_screen.dart';
import 'practice_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [const LessonListTab(), const PracticeListScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bài học'),
          BottomNavigationBarItem(icon: Icon(Icons.code), label: 'Thực hành'),
        ],
      ),
    );
  }
}

class LessonListTab extends StatefulWidget {
  const LessonListTab({super.key});

  @override
  State<LessonListTab> createState() => _LessonListTabState();
}

class _LessonListTabState extends State<LessonListTab> {
  final Set<String> _unlockedLessonIds = {'1'}; // Lesson 1 is always unlocked
  final AdHelper _adHelper = AdHelper();

  @override
  void initState() {
    super.initState();
    _adHelper.createRewardedInterstitialAd();
    _loadUnlockedLessons();
  }

  Future<void> _loadUnlockedLessons() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList('unlockedLessons');
    if (savedIds != null) {
      setState(() {
        _unlockedLessonIds.addAll(savedIds);
      });
    }
  }

  Future<void> _unlockLesson(String lessonId) async {
    setState(() {
      _unlockedLessonIds.add(lessonId);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('unlockedLessons', _unlockedLessonIds.toList());
  }

  void _handleLessonTap(Lesson lesson) {
    if (_unlockedLessonIds.contains(lesson.id)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LessonScreen(lesson: lesson)));
    } else {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Mở khóa bài học'),
              content: const Text('Xem một quảng cáo ngắn để mở khóa bài học này nhé?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Để sau')),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _adHelper.showRewardedInterstitialAd(context, () {
                      _unlockLesson(lesson.id);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('Đã mở khóa bài học! Chúc bạn học vui vẻ.')));
                    });
                  },
                  child: const Text('Xem Ngay'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.appName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.homeTitle,
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.text),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: dummyLessons.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final lesson = dummyLessons[index];
                  final isLocked = !_unlockedLessonIds.contains(lesson.id);
                  return LessonCard(lesson: lesson, isLocked: isLocked, onTap: () => _handleLessonTap(lesson));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final bool isLocked;
  final VoidCallback onTap;

  const LessonCard({super.key, required this.lesson, this.isLocked = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isLocked ? Colors.grey[200] : lesson.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isLocked ? Icons.lock : lesson.icon,
                    color: isLocked ? Colors.grey : lesson.color,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isLocked ? Colors.grey : AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lesson.description,
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(isLocked ? Icons.lock_outline : Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
