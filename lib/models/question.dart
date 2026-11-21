enum QuestionType { single, multiple }

class Question {
  final int id;
  final QuestionType type;
  final String text;
  final List<String> options;
  final Set<int> correctAnswers; // indeks opsi benar (mulai dari 0)
  final String explanation;

  const Question({
    required this.id,
    required this.type,
    required this.text,
    required this.options,
    required this.correctAnswers,
    required this.explanation,
  });

  bool get isMultipleChoice => type == QuestionType.multiple;

  String get typeLabel =>
      isMultipleChoice ? 'Multi Jawaban' : 'Pilihan Tunggal';

  String get instructionText => isMultipleChoice
      ? 'Pilih semua jawaban yang benar (bisa lebih dari satu).'
      : 'Pilih satu jawaban yang benar.';

  static String optionLetter(int index) {
    return String.fromCharCode(65 + index);
  }
}
