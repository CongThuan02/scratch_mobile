import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/quiz.dart';
import '../services/progress_service.dart';
import '../utils/constants.dart';

class QuizScreen extends StatefulWidget {
  final List<Quiz> quizzes;
  final String lessonTitle;

  const QuizScreen({super.key, required this.quizzes, required this.lessonTitle});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  int? _selectedOptionIndex;

  void _answerQuestion(int index) {
    if (_isAnswered) return;

    setState(() {
      _selectedOptionIndex = index;
      _isAnswered = true;
      if (index == widget.quizzes[_currentIndex].correctAnswerIndex) {
        _score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (_currentIndex < widget.quizzes.length - 1) {
        setState(() {
          _currentIndex++;
          _isAnswered = false;
          _selectedOptionIndex = null;
        });
      } else {
        // Show result
        _showResultDialog();
      }
    });
  }

  void _showResultDialog() {
    // Save Score
    ProgressService().saveQuizScore(widget.quizzes.first.lessonId, _score);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text('Kết quả', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bạn đã trả lời đúng $_score / ${widget.quizzes.length} câu hỏi!',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Điểm cao nhất: ${ProgressService().getQuizScore(widget.quizzes.first.lessonId)}', // Show high score (updated)
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back to lesson
                },
                child: Text('Hoàn thành', style: GoogleFonts.poppins()),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quiz = widget.quizzes[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Quiz: ${widget.lessonTitle}',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (_currentIndex + 1) / widget.quizzes.length,
              backgroundColor: Colors.grey[200],
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),

            // Question Counter
            Text(
              'Câu hỏi ${_currentIndex + 1}/${widget.quizzes.length}',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            // Question Text
            Text(
              quiz.question,
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
            ),
            const SizedBox(height: 32),

            // Options
            ...List.generate(quiz.options.length, (index) {
              final isSelected = _selectedOptionIndex == index;
              final isCorrect = index == quiz.correctAnswerIndex;

              Color borderColor = Colors.grey.shade300;
              Color backgroundColor = Colors.white;

              if (_isAnswered) {
                if (isCorrect) {
                  borderColor = AppColors.accentGreen;
                  backgroundColor = AppColors.accentGreen.withOpacity(0.1);
                } else if (isSelected) {
                  borderColor = Colors.red;
                  backgroundColor = Colors.red.withOpacity(0.1);
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: GestureDetector(
                  onTap: () => _answerQuestion(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isAnswered && (isCorrect || isSelected) ? borderColor : Colors.grey,
                            ),
                            color:
                                _isAnswered && isCorrect
                                    ? AppColors.accentGreen
                                    : (_isAnswered && isSelected ? Colors.red : Colors.transparent),
                          ),
                          child:
                              _isAnswered && isCorrect
                                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                                  : (_isAnswered && isSelected
                                      ? const Icon(Icons.close, size: 16, color: Colors.white)
                                      : null),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            quiz.options[index],
                            style: GoogleFonts.poppins(fontSize: 16, color: AppColors.text),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
