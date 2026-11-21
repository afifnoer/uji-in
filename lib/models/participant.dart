class Participant {
  final String name;
  final String nim;
  final String department;
  final String studyProgram;
  final String className;

  const Participant({
    required this.name,
    required this.nim,
    required this.department,
    required this.studyProgram,
    required this.className,
  });

  static const List<String> departments = [
    'Komputer dan Bisnis',
  ];

  static const List<String> studyPrograms = [
    'Teknik Informatika',
    'Rekayasa Keamanan Siber',
    'Teknologi Rekayasa Multimedia',
    'Akuntansi Lembaga Keuangan Syariah',
    'Rekayasa Perangkat Lunak',
  ];

  static const List<String> classes = [
    '1A',
    '1B',
    '1C',
    '2A',
    '2B',
    '2C',
  ];
}
