import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/question.dart';

class QuestionNavigator extends StatelessWidget {
  final List<Question> questions;
  final int currentIndex;
  final bool Function(int questionId) isQuestionAnswered;
  final ValueChanged<int> onSelectQuestion;

  const QuestionNavigator({
    super.key,
    required this.questions,
    required this.currentIndex,
    required this.isQuestionAnswered,
    required this.onSelectQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  'Navigasi Soal',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF374151),
                  ),
                ),
                _buildLegendItem(
                  color: AppTheme.primaryColor,
                  borderColor: AppTheme.primaryColor,
                  label: 'Aktif',
                ),
                _buildLegendItem(
                  color: AppTheme.successBackground,
                  borderColor: AppTheme.successColor,
                  label: 'Dijawab',
                ),
                _buildLegendItem(
                  color: Colors.white,
                  borderColor: AppTheme.borderColor,
                  label: 'Belum',
                ),
              ],
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 44,
              ),
              itemBuilder: (context, index) {
                final question = questions[index];
                final isCurrent = index == currentIndex;
                final isAnswered = isQuestionAnswered(question.id);

                Color backgroundColor;
                Color borderColor;
                Color textColor;

                if (isCurrent) {
                  backgroundColor = AppTheme.primaryColor;
                  borderColor = AppTheme.primaryColor;
                  textColor = Colors.white;
                } else if (isAnswered) {
                  backgroundColor = AppTheme.successBackground;
                  borderColor = AppTheme.successColor;
                  textColor = AppTheme.successColor;
                } else {
                  backgroundColor = Colors.white;
                  borderColor = AppTheme.borderColor;
                  textColor = const Color(0xFF374151);
                }

                return Semantics(
                  button: true,
                  selected: isCurrent,
                  label:
                      'Nomor soal ${index + 1}, ${isAnswered ? "sudah dijawab" : "belum dijawab"}',
                  child: InkWell(
                    key: ValueKey('nav_question_${index + 1}'),
                    onTap: () => onSelectQuestion(index),
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: borderColor,
                          width: isCurrent || isAnswered ? 1.5 : 1.0,
                        ),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required Color borderColor,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: borderColor, width: 1.2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
