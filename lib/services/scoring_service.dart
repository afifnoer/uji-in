import '../models/question.dart';
import '../models/quiz_result.dart';

class ScoringService {
  static const int kPassingScore = 70;

  /// Menilai satu soal dengan aturan Exact Match (Bagian 9.1 & 9.3 PRD).
  static QuestionEvaluation evaluateQuestion(
    Question question,
    Set<int> selectedAnswers,
  ) {
    final normalizedSelected = Set<int>.unmodifiable(selectedAnswers);

    if (normalizedSelected.isEmpty) {
      return QuestionEvaluation(
        question: question,
        selectedAnswers: normalizedSelected,
        status: QuestionStatus.unanswered,
        score: 0,
      );
    }

    final isExactMatch =
        normalizedSelected.length == question.correctAnswers.length &&
            normalizedSelected.containsAll(question.correctAnswers);

    return QuestionEvaluation(
      question: question,
      selectedAnswers: normalizedSelected,
      status: isExactMatch ? QuestionStatus.correct : QuestionStatus.incorrect,
      score: isExactMatch ? 1 : 0,
    );
  }

  /// Menghitung skor akhir dan ringkasan seluruh soal (Bagian 9.2 PRD).
  static QuizResult calculateResult({
    required List<Question> questions,
    required Map<int, Set<int>> answers,
    int passingScore = kPassingScore,
    DateTime? completedAt,
  }) {
    final evaluations = <QuestionEvaluation>[];
    int correctCount = 0;
    int incorrectCount = 0;
    int unansweredCount = 0;

    for (final question in questions) {
      final selected = answers[question.id] ?? const <int>{};
      final evaluation = evaluateQuestion(question, selected);
      evaluations.add(evaluation);

      switch (evaluation.status) {
        case QuestionStatus.correct:
          correctCount++;
          break;
        case QuestionStatus.incorrect:
          incorrectCount++;
          break;
        case QuestionStatus.unanswered:
          unansweredCount++;
          break;
      }
    }

    final totalQuestions = questions.length;
    final totalScore = totalQuestions == 0
        ? 0
        : ((correctCount / totalQuestions) * 100).round();

    return QuizResult(
      totalScore: totalScore,
      totalQuestions: totalQuestions,
      correctCount: correctCount,
      incorrectCount: incorrectCount,
      unansweredCount: unansweredCount,
      isPassed: totalScore >= passingScore,
      completedAt: completedAt ?? DateTime.now(),
      evaluations: List<QuestionEvaluation>.unmodifiable(evaluations),
    );
  }
}
