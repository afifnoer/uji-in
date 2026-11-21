import 'package:flutter/foundation.dart';

import '../data/questions_data.dart';
import '../models/participant.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';
import '../services/scoring_service.dart';

class QuizProvider extends ChangeNotifier {
  final List<Question> questions;

  Participant? _participant;
  int _currentIndex = 0;
  final Map<int, Set<int>> _answers = {};
  QuizResult? _result;
  bool _isSubmitting = false;

  QuizProvider({this.questions = kQuestions});

  Participant? get participant => _participant;
  int get currentIndex => _currentIndex;
  int get totalQuestions => questions.length;
  Question get currentQuestion => questions[_currentIndex];
  QuizResult? get result => _result;
  bool get isSubmitting => _isSubmitting;

  bool get isFirstQuestion => _currentIndex == 0;
  bool get isLastQuestion => _currentIndex == questions.length - 1;

  Map<int, Set<int>> get answers => Map.unmodifiable(
        _answers.map(
          (key, value) => MapEntry(key, Set<int>.unmodifiable(value)),
        ),
      );

  Set<int> selectedAnswersFor(int questionId) {
    final selected = _answers[questionId];
    if (selected == null) return const <int>{};
    return Set<int>.unmodifiable(selected);
  }

  bool isQuestionAnswered(int questionId) {
    final selected = _answers[questionId];
    return selected != null && selected.isNotEmpty;
  }

  int get answeredCount =>
      questions.where((q) => isQuestionAnswered(q.id)).length;

  int get unansweredCount => totalQuestions - answeredCount;

  double get progress =>
      totalQuestions == 0 ? 0 : (_currentIndex + 1) / totalQuestions;

  void setParticipant(Participant participant) {
    _participant = participant;
    _currentIndex = 0;
    _answers.clear();
    _result = null;
    _isSubmitting = false;
    notifyListeners();
  }

  void toggleAnswer(Question question, int optionIndex) {
    final current = Set<int>.from(_answers[question.id] ?? const <int>{});

    if (question.type == QuestionType.single) {
      if (current.contains(optionIndex)) {
        current.clear();
      } else {
        current
          ..clear()
          ..add(optionIndex);
      }
    } else {
      if (current.contains(optionIndex)) {
        current.remove(optionIndex);
      } else {
        current.add(optionIndex);
      }
    }

    if (current.isEmpty) {
      _answers.remove(question.id);
    } else {
      final sorted = current.toList()..sort();
      _answers[question.id] = Set<int>.from(sorted);
    }

    notifyListeners();
  }

  void goTo(int index) {
    if (index < 0 || index >= questions.length || index == _currentIndex) {
      return;
    }
    _currentIndex = index;
    notifyListeners();
  }

  void next() {
    if (_currentIndex < questions.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previous() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  QuizResult submit({DateTime? completedAt}) {
    if (_isSubmitting && _result != null) {
      return _result!;
    }
    _isSubmitting = true;
    notifyListeners();

    _result = ScoringService.calculateResult(
      questions: questions,
      answers: _answers,
      completedAt: completedAt,
    );
    _isSubmitting = false;
    notifyListeners();
    return _result!;
  }

  /// Ulangi latihan: bersihkan jawaban & hasil, tetapi pertahankan data diri peserta.
  void retryQuiz() {
    _currentIndex = 0;
    _answers.clear();
    _result = null;
    _isSubmitting = false;
    notifyListeners();
  }

  /// Kembali ke awal: reset seluruh state termasuk data diri peserta.
  void reset() {
    _participant = null;
    _currentIndex = 0;
    _answers.clear();
    _result = null;
    _isSubmitting = false;
    notifyListeners();
  }
}
