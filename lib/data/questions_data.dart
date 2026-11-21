import '../models/question.dart';

const List<Question> kQuestions = [
  Question(
    id: 1,
    type: QuestionType.single,
    text: 'Widget yang dipakai untuk daftar yang dapat digulir?',
    options: [
      'ListView',
      'Row',
      'Padding',
      'SizedBox',
    ],
    correctAnswers: {0},
    explanation: 'ListView menampilkan daftar yang dapat digulir.',
  ),
  Question(
    id: 2,
    type: QuestionType.multiple,
    text: 'Manakah yang termasuk widget layout (tata letak) di Flutter?',
    options: [
      'Column',
      'Row',
      'Stack',
      'Text',
    ],
    correctAnswers: {0, 1, 2},
    explanation:
        'Column, Row, dan Stack mengatur tata letak widget anak, sedangkan Text menampilkan teks.',
  ),
  Question(
    id: 3,
    type: QuestionType.single,
    text: 'Siapa pengembang Flutter?',
    options: [
      'Meta',
      'Google',
      'Apple',
      'Oracle',
    ],
    correctAnswers: {1},
    explanation: 'Flutter dikembangkan oleh Google.',
  ),
  Question(
    id: 4,
    type: QuestionType.multiple,
    text: 'Apa saja karakteristik bahasa Dart yang dipakai Flutter?',
    options: [
      'Mendukung null safety',
      'Dikembangkan oleh Google',
      'Hanya berjalan di Android',
      'Dapat dikompilasi ke native/JS',
    ],
    correctAnswers: {0, 1, 3},
    explanation:
        'Dart mendukung null safety, dikembangkan Google, dan mendukung multi-platform (native maupun web/JS).',
  ),
  Question(
    id: 5,
    type: QuestionType.single,
    text: 'Method untuk memperbarui tampilan pada StatefulWidget?',
    options: [
      'print()',
      'dispose()',
      'setState()',
      'initState()',
    ],
    correctAnswers: {2},
    explanation: 'setState memicu build ulang tampilan.',
  ),
  Question(
    id: 6,
    type: QuestionType.multiple,
    text: 'Apa saja fungsi berkas pubspec.yaml pada proyek Flutter?',
    options: [
      'Mendeklarasikan package/dependency',
      'Mendaftarkan aset gambar/font',
      'Menulis kode UI utama',
      'Menentukan versi aplikasi',
    ],
    correctAnswers: {0, 1, 3},
    explanation:
        'pubspec.yaml mengatur metadata/versi aplikasi, dependency, dan aset; kode UI ditulis di berkas .dart.',
  ),
  Question(
    id: 7,
    type: QuestionType.single,
    text: 'Widget untuk isian teks?',
    options: [
      'Image',
      'Icon',
      'Divider',
      'TextField',
    ],
    correctAnswers: {3},
    explanation: 'TextField menerima input teks dari pengguna.',
  ),
  Question(
    id: 8,
    type: QuestionType.multiple,
    text: 'Manakah perintah CLI Flutter yang valid?',
    options: [
      'flutter run',
      'flutter doctor',
      'flutter start-ui',
      'flutter clean',
    ],
    correctAnswers: {0, 1, 3},
    explanation:
        'flutter run, flutter doctor, dan flutter clean adalah perintah resmi Flutter CLI.',
  ),
  Question(
    id: 9,
    type: QuestionType.single,
    text: 'Cara mengaktifkan tema Material 3?',
    options: [
      'ThemeData(useMaterial3: true)',
      'Navigator.pop',
      'MediaQuery.of',
      'setState',
    ],
    correctAnswers: {0},
    explanation: 'Material 3 diaktifkan lewat ThemeData.',
  ),
  Question(
    id: 10,
    type: QuestionType.multiple,
    text:
        'Manakah method Navigator untuk berpindah atau menutup layar di Flutter?',
    options: [
      'Navigator.push',
      'Navigator.pop',
      'Navigator.build',
      'Navigator.pushReplacement',
    ],
    correctAnswers: {0, 1, 3},
    explanation:
        'push dan pushReplacement membuka layar baru, sedangkan pop menutup layar saat ini.',
  ),
];
