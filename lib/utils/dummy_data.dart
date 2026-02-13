import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/quiz.dart';
import '../models/block.dart';
import '../models/practice_level.dart';
import 'constants.dart';

// Generated from CURRICULUM_SCHEMA.json
List<Lesson> dummyLessons = [
  Lesson(
    id: '1',
    title: 'Bài 1: Làm quen với Scratch',
    description: 'Khám phá giao diện và những khối lệnh đầu tiên.',
    icon: Icons.star,
    color: AppColors.primary,
    content: [
      '**Chào mừng bạn đến với Scratch!**',
      'Trong bài này, chúng ta sẽ tìm hiểu về giao diện Scratch, nơi bạn sẽ sáng tạo ra những câu chuyện và trò chơi thú vị.',
      '**Các thành phần chính:**',
      '- **Sân khấu (Stage):** Nơi diễn ra hoạt động của nhân vật.',
      '- **Nhân vật (Sprite):** Các đối tượng bạn điều khiển (mặc định là chú Mèo).',
      '- **Khối lệnh (Blocks):** Các mảnh ghép dùng để lập trình.',
    ],
    practiceGuide: [
      '1. Mở phần **Thực hành**.',
      '2. Kéo khối **"Di chuyển 10 bước"** (Motion - Xanh dương) vào khu vực làm việc.',
      '3. Nhấn vào khối lệnh để xem Mèo di chuyển.',
      '4. Thử kéo khối **"Xoay 15 độ"** và ghép vào dưới khối di chuyển.',
    ],
  ),
  Lesson(
    id: '2',
    title: 'Bài 2: Chuyển động và Hướng',
    description: 'Điều khiển nhân vật di chuyển chính xác trên sân khấu.',
    icon: Icons.directions_run,
    color: AppColors.secondary,
    content: [
      '**Hệ tọa độ:** Sân khấu Scratch sử dụng hệ tọa độ X (ngang) và Y (dọc). Tâm sân khấu có tọa độ (0, 0).',
      '**Các lệnh chuyển động:**',
      '- **Đi tới điểm x: y:**: Nhảy ngay tới vị trí cụ thể.',
      '- **Lướt trong ... giây tới ...**: Di chuyển từ từ tới đích.',
      '- **Đặt hướng bằng ...**: Quay mặt nhân vật về hướng chỉ định (90 là phải, -90 là trái).',
    ],
    practiceGuide: [
      '1. Tạo dự án mới.',
      '2. Dùng khối **"Khi nhấn cờ xanh"** (Events - Vàng).',
      '3. Ghép khối **"Đi tới điểm x: 0 y: 0"** để Mèo về giữa.',
      '4. Thêm khối **"Lướt trong 1 giây tới điểm x: 100 y: 100"**.',
      '5. Nhấn cờ xanh và quan sát đường đi của Mèo.',
    ],
  ),
  Lesson(
    id: '3',
    title: 'Bài 3: Ngoại hình và Hiệu ứng',
    description: 'Thay đổi trang phục, màu sắc và kích thước nhân vật.',
    icon: Icons.palette,
    color: AppColors.accentPurple,
    content: [
      '**Nhóm lệnh Hiển thị (Looks - Tím):**',
      '- **Nói "Xin chào"**: Hiện bóng đối thoại.',
      '- **Đổi trang phục kế tiếp**: Tạo hiệu ứng hoạt hình (ví dụ: Mèo bước đi).',
      '- **Đổi hiệu ứng màu**: Thay đổi màu sắc nhân vật.',
      '- **Đặt kích thước**: Phóng to hoặc thu nhỏ nhân vật.',
    ],
    practiceGuide: [
      '1. Chọn sự kiện **"Khi nhấn vào nhân vật này"**.',
      '2. Thêm khối **"Đổi trang phục kế tiếp"**.',
      '3. Thêm khối **"Đổi hiệu ứng màu một lượng 25"**.',
      '4. Nhấn liên tục vào chú Mèo để xem nó đổi màu và hình dạng nhé!',
    ],
  ),
];

// Quizzes aligned with lessons 1-3
List<Quiz> dummyQuizzes = [
  Quiz(
    id: 'q1',
    lessonId: '1',
    question: 'Khối lệnh dùng để di chuyển thuộc nhóm màu gì?',
    options: ['Tím', 'Xanh dương (Motion)', 'Vàng', 'Cam'],
    correctAnswerIndex: 1,
  ),
  Quiz(
    id: 'q2',
    lessonId: '1',
    question: 'Sân khấu (Stage) là nơi nào?',
    options: ['Nơi lập trình', 'Nơi chọn nhân vật', 'Nơi diễn ra hoạt động của nhân vật', 'Nơi lưu bài'],
    correctAnswerIndex: 2,
  ),
  Quiz(
    id: 'q3',
    lessonId: '2',
    question: 'Tọa độ tâm sân khấu là bao nhiêu?',
    options: ['(100, 100)', '(0, 0)', '(240, 180)', '(10, 10)'],
    correctAnswerIndex: 1,
  ),
  Quiz(
    id: 'q4',
    lessonId: '3',
    question: 'Lệnh nào dùng để thay đổi màu nhân vật?',
    options: ['Đổi hướng', 'Đổi hiệu ứng màu', 'Di chuyển 10 bước', 'Phát âm thanh'],
    correctAnswerIndex: 1,
  ),
];

List<Quiz> getQuizzesForLesson(String lessonId) {
  return dummyQuizzes.where((q) => q.lessonId == lessonId).toList();
}

// Dummy Blocks and Levels remain as placeholders
final blockMove10 = Block(
  id: 'move_10',
  text: 'Di chuyển 10 bước',
  type: BlockType.motion,
  color: AppColors.primary,
  icon: Icons.directions_run,
);

final blockTurnRight15 = Block(
  id: 'turn_right_15',
  text: 'Xoay phải 15 độ',
  type: BlockType.motion,
  color: AppColors.primary,
  icon: Icons.rotate_right,
);

final List<PracticeLevel> dummyPracticeLevels = [
  PracticeLevel(
    id: 'p1',
    title: 'Thử thách 1: Bước đi đầu tiên',
    description: 'Hãy ghép khối lệnh để nhân vật di chuyển 10 bước.',
    availableBlocks: [blockMove10, blockTurnRight15],
    solutionBlockIds: ['move_10'],
  ),
];
