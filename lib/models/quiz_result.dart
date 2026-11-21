import 'question.dart';

enum QuestionStatus { correct, incorrect, unanswered }

class QuestionEvaluation {
  final Question question;
  final Set<int> selectedAnswers;
  final QuestionStatus status;
  final int score;

  const QuestionEvaluation({
    required this.question,
    required this.selectedAnswers,
    required this.status,
    required this.score,
  });

  bool get isCorrect => status == QuestionStatus.correct;
  bool get isIncorrect => status == QuestionStatus.incorrect;
  bool get isUnanswered => status == QuestionStatus.unanswered;
}

class QuizResult {
  final int totalScore;
  final int totalQuestions;
  final int correctCount;
  final int incorrectCount;
  final int unansweredCount;
  final bool isPassed;
  final DateTime completedAt;
  final List<QuestionEvaluation> evaluations;

  const QuizResult({
    required this.totalScore,
    required this.totalQuestions,
    required this.correctCount,
    required this.incorrectCount,
    required this.unansweredCount,
    required this.isPassed,
    required this.completedAt,
    required this.evaluations,
  });
}
