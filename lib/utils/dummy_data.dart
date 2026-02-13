import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/quiz.dart';
import '../models/block.dart';
import '../models/practice_level.dart';
import 'constants.dart';

List<Lesson> dummyLessons = [
  Lesson(
    id: '1',
    title: 'Bài 1: Làm quen với Scratch',
    description: 'Tìm hiểu giao diện và những người bạn đầu tiên.',
    icon: Icons.star,
    color: AppColors.primary,
    content: [
      '**Chào mừng đến với thế giới Scratch!**',
      'Scratch là ngôn ngữ lập trình kéo thả giúp bạn tạo ra phim hoạt hình, trò chơi và những câu chuyện thú vị.',
      '**Giao diện Scratch gồm 3 phần chính:**',
      '1. **Sân khấu (Stage):** Nơi diễn ra câu chuyện của bạn. Bạn sẽ thấy chú Mèo Scratch ở đây.',
      '2. **Khu vực khối lệnh (Block Palette):** Chứa các mảnh ghép sắc màu. Mỗi màu là một loại lệnh khác nhau (Chuyển động, Âm thanh, Sự kiện...).',
      '3. **Khu vực lập trình (Workspace):** Nơi bạn kéo các khối lệnh vào để ghép chúng lại với nhau.',
    ],
    practiceGuide: [
      '1. Mở phần **Thực hành**.',
      '2. Tìm khối màu xanh dương **"Di chuyển 10 bước"** và kéo vào khu vực lập trình.',
      '3. Chạm vào khối lệnh đó và xem Mèo di chuyển trên Sân khấu.',
      '4. Tìm khối màu tím **"Nói Xin chào! trong 2 giây"** và ghép xuống dưới khối di chuyển.',
      '5. Chạm vào chuỗi khối lệnh để xem kết quả.',
    ],
  ),
  Lesson(
    id: '2',
    title: 'Bài 2: Chuyển động nhịp nhàng',
    description: 'Học cách điều khiển nhân vật đi lại và xoay vòng.',
    icon: Icons.directions_run,
    color: AppColors.secondary,
    content: [
      '**Tọa độ X và Y:**',
      'Sân khấu Scratch giống như một bản đồ. **X** là chiều ngang (Trái-Phải), **Y** là chiều dọc (Lên-Xuống).',
      'Biểu tượng **Hướng (Direction)** giúp bạn biết nhân vật đang nhìn về đâu (90 độ là nhìn sang phải).',
      '**Các khối lệnh quan trọng:**',
      '- **Đi tới điểm x: y:**: Nhảy ngay lập tức đến vị trí cụ thể.',
      '- **Lướt trong 1 giây tới...**: Di chuyển mượt mà đến vị trí mới.',
      '- **Xoay 15 độ**: Làm nhân vật quay tròn.',
    ],
    practiceGuide: [
      '1. Tạo một dự án mới.',
      '2. Kéo khối **"Khi nhấn vào cờ xanh"** (Màu vàng - Sự kiện) ra đầu tiên.',
      '3. Ghép khối **"Đi tới điểm x: 0 y: 0"** để Mèo về giữa sân khấu.',
      '4. Thêm khối **"Lướt trong 1 giây tới điểm x: 100 y: 100"**.',
      '5. Nhấn lá cờ xanh và xem Mèo trượt đi nhé!',
    ],
  ),
  Lesson(
    id: '3',
    title: 'Bài 3: Vòng lặp vô tận (Loops)',
    description: 'Tại sao phải làm đi làm lại một việc? Hãy dùng vòng lặp!',
    icon: Icons.loop,
    color: AppColors.accentPurple,
    content: [
      'Máy tính rất giỏi làm những việc lặp đi lặp lại mà không biết chán.',
      '**Vòng lặp (Loop)** giúp bạn ra lệnh cho nhân vật thực hiện hành động nhiều lần.',
      '**Các loại vòng lặp:**',
      '- **Lặp lại 10 lần:** Chỉ làm đúng số lần bạn quy định.',
      '- **Liên tục (Forever):** Làm mãi mãi cho đến khi bạn nhấn nút Đỏ (Dừng lại).',
    ],
    practiceGuide: [
      '1. Bắt đầu với **"Khi nhấn cờ xanh"**.',
      '2. Kéo khối vòng lặp **"Liên tục"** (Màu cam - Điều khiển) vào.',
      '3. Bên trong vòng lặp, đặt khối **"Di chuyển 10 bước"**.',
      '4. Đặt tiếp khối **"Bật lại nếu chạm cạnh"** (Màu xanh dương) ngay dưới khối di chuyển.',
      '**. Kết quả:** Mèo sẽ chạy qua lại trên sân khấu mãi mãi không dừng!',
    ],
  ),
  Lesson(
    id: '4',
    title: 'Bài 4: Sự kiện & Điều khiển',
    description: 'Tương tác với nhân vật bằng bàn phím và chuột.',
    icon: Icons.touch_app,
    color: Colors.orange,
    content: [
      '**Sự kiện (Events)** là khởi đầu của mọi chương trình. Nó trả lời câu hỏi "Khi nào thì chạy?".',
      'Ví dụ: "Khi bấm vào nhân vật này", "Khi phím Trắng được nhấn".',
      'Bạn có thể tạo ra trò chơi điều khiển nhân vật bằng các phím mũi tên nhờ các khối Sự kiện này.',
    ],
    practiceGuide: [
      '1. Kéo khối **"Khi bấm phím Trắng"** ra.',
      '2. Đổi "phím Trắng" thành **"Mũi tên phải"**.',
      '3. Ghép khối **"Đổi x một lượng 10"** vào dưới.',
      '4. Làm tương tự: **"Khi bấm phím Trái"** thì **"Đổi x một lượng -10"**.',
      '5. Thử nhấn các phím mũi tên để điều khiển Mèo nhé!',
    ],
  ),
  Lesson(
    id: '5',
    title: 'Bài 5: Âm thanh & Hiệu ứng',
    description: 'Thêm gia vị cho dự án bằng âm nhạc và màu sắc.',
    icon: Icons.music_note,
    color: Colors.pinkAccent,
    content: [
      'Một trò chơi sẽ chán ngắt nếu không có âm thanh!',
      'Bạn có thể dùng thẻ **Âm thanh (Sound)** để:',
      '- Phát tiếng kêu con vật.',
      '- Chơi nhạc cụ (Trống, Đàn Piano...).',
      '- Ghi âm giọng nói của chính bạn.',
      'Thẻ **Hiển thị (Looks)** giúp thay đổi màu sắc, kích thước và trang phục của nhân vật.',
    ],
    practiceGuide: [
      '1. Chọn sự kiện **"Khi nhấn vào nhân vật này"**.',
      '2. Thêm khối **"Phát âm thanh Meow tới hết"**.',
      '3. Thêm khối **"Đổi hiệu ứng màu một lượng 25"**.',
      '4. Bây giờ hãy chạm vào chú Mèo liên tục: Nó sẽ vừa kêu vừa đổi màu lấp lánh!',
    ],
  ),
  Lesson(
    id: '6',
    title: 'Bài 6: Biến số (Variables)',
    description: 'Làm bảng điểm cho trò chơi.',
    icon: Icons.score,
    color: Colors.teal,
    content: [
      '**Biến số** giống như một chiếc hộp dùng để chứa thông tin.',
      'Trong trò chơi, Biến số thường dùng để lưu: **Điểm số**, **Thời gian**, hoặc **Mạng sống**.',
      'Bạn có thể:',
      '- **Đặt biến:** Gán giá trị ban đầu (Ví dụ: Điểm = 0).',
      '- **Thay đổi biến:** Cộng hoặc trừ điểm (Ví dụ: Ăn táo thì Điểm tăng 1).',
    ],
    practiceGuide: [
      '1. Vào nhóm Các biến số, chọn **"Tạo một biến"** và đặt tên là "Điểm".',
      '2. Khi bắt đầu (Cờ xanh), dùng khối **"Đặt Điểm thành 0"**.',
      '3. Chọn sự kiện **"Khi bấm vào nhân vật này"**.',
      '4. Thêm khối **"Thay đổi Điểm một lượng 1"** và **"Phát âm thanh Pop"**.',
      '5. Chơi thử: Càng bấm nhanh vào Mèo, điểm càng tăng cao!',
    ],
  ),
];

// Simplified Quizzes for now
List<Quiz> dummyQuizzes = [
  Quiz(
    id: 'q1',
    lessonId: '1',
    question: 'Khối lệnh dùng để bắt đầu chương trình thường có màu gì?',
    options: ['Xanh dương', 'Vàng (Sự kiện)', 'Tím', 'Đỏ'],
    correctAnswerIndex: 1,
  ),
  Quiz(
    id: 'q2',
    lessonId: '1',
    question: 'Sân khấu (Stage) dùng để làm gì?',
    options: ['Để chứa các khối lệnh', 'Để nhân vật biểu diễn', 'Để đổi tên nhân vật', 'Để lưu bài làm'],
    correctAnswerIndex: 1,
  ),
];

List<Quiz> getQuizzesForLesson(String lessonId) {
  return dummyQuizzes.where((q) => q.lessonId == lessonId).toList();
}

// Dummy Blocks and Levels remain as placeholders or can be updated similarly if needed
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

final blockSayHello = Block(
  id: 'say_hello',
  text: 'Nói "Xin chào!"',
  type: BlockType.looks,
  color: AppColors.accentPurple,
  icon: Icons.chat_bubble_outline,
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
