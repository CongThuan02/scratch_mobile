import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/lesson/lesson_cubit.dart';
import '../blocs/lesson/lesson_state.dart';
import '../models/lesson.dart';
import '../services/progress_service.dart';
import '../services/lesson_service.dart';
import '../utils/ad_helper.dart'; // Import AdHelper
import '../utils/constants.dart';
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

class LessonListTab extends StatelessWidget {
  const LessonListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => LessonCubit(lessonService: LessonService(), progressService: ProgressService())..loadLessons(),
      child: const LessonlistView(),
    );
  }
}

class LessonlistView extends StatelessWidget {
  const LessonlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LessonCubit, LessonState>(
      listener: (context, state) {
        if (state is LessonError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocBuilder<LessonCubit, LessonState>(
        builder: (context, state) {
          if (state is LessonLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LessonError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Đã xảy ra lỗi: ${state.message}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<LessonCubit>().loadLessons(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (state is LessonLoaded) {
            final lessons = state.lessons;
            final unlockedLessonIds = state.unlockedLessonIds;

            if (lessons.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.sentiment_dissatisfied, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text('Chưa có bài học nào.', style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => context.read<LessonCubit>().seedData(),
                      icon: const Icon(Icons.cloud_upload),
                      label: const Text('Tải dữ liệu mẫu'),
                    ),
                  ],
                ),
              );
            }

            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                title: Text(
                  AppStrings.appName,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                backgroundColor: AppColors.primary,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.cloud_upload),
                    tooltip: 'Tải lại dữ liệu mẫu',
                    onPressed: () => context.read<LessonCubit>().seedData(),
                  ),
                ],
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
                        itemCount: lessons.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final lesson = lessons[index];
                          final isLocked = !unlockedLessonIds.contains(lesson.id);
                          return LessonCard(
                            lesson: lesson,
                            isLocked: isLocked,
                            onTap: () => _handleLessonTap(context, lesson, isLocked),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink(); // Initial state
        },
      ),
    );
  }

  void _handleLessonTap(BuildContext context, Lesson lesson, bool isLocked) {
    if (!isLocked) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LessonScreen(lesson: lesson)));
    } else {
      showDialog(
        context: context,
        builder:
            (dialogContext) => AlertDialog(
              title: const Text('Mở khóa bài học'),
              content: const Text('Xem một quảng cáo ngắn để mở khóa bài học này nhé?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Để sau')),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    final adHelper = AdHelper();
                    adHelper.createRewardedInterstitialAd();
                    adHelper.showRewardedInterstitialAd(context, () {
                      context.read<LessonCubit>().unlockLesson(lesson.id);
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
