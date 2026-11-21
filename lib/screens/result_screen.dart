import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../providers/quiz_provider.dart';
import '../services/scoring_service.dart';
import '../widgets/result_item.dart';
import '../widgets/score_card.dart';
import 'quiz_screen.dart';
import 'welcome_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, _) {
        final result = provider.result ??
            ScoringService.calculateResult(
              questions: provider.questions,
              answers: provider.answers,
            );

        return PopScope(
          canPop: false,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Hasil Latihan Soal'),
            ),
            body: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppTheme.maxContentWidth,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: result.evaluations.length + 2,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return ScoreCard(
                                participant: provider.participant,
                                result: result,
                              );
                            }
                            if (index == 1) {
                              return const Padding(
                                padding: EdgeInsets.only(
                                  top: 24,
                                  bottom: 12,
                                ),
                                child: Text(
                                  'Pembahasan & Detail per Soal',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                              );
                            }

                            final evalIndex = index - 2;
                            final evaluation = result.evaluations[evalIndex];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ResultItem(
                                index: evalIndex,
                                evaluation: evaluation,
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                key: const ValueKey('back_to_start_button'),
                                onPressed: () {
                                  provider.reset();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const WelcomeScreen(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                icon: const Icon(Icons.home_outlined),
                                label: const Text('Kembali ke Awal'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton.icon(
                                key: const ValueKey('retry_quiz_button'),
                                onPressed: () {
                                  provider.retryQuiz();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const QuizScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.refresh_rounded),
                                label: const Text('Ulangi Latihan'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
