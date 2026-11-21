import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';

class ResultItem extends StatelessWidget {
  final int index;
  final QuestionEvaluation evaluation;

  const ResultItem({
    super.key,
    required this.index,
    required this.evaluation,
  });

  Color get _statusColor {
    switch (evaluation.status) {
      case QuestionStatus.correct:
        return AppTheme.successColor;
      case QuestionStatus.incorrect:
        return AppTheme.errorColor;
      case QuestionStatus.unanswered:
        return AppTheme.neutralColor;
    }
  }

  Color get _statusBackground {
    switch (evaluation.status) {
      case QuestionStatus.correct:
        return AppTheme.successBackground;
      case QuestionStatus.incorrect:
        return AppTheme.errorBackground;
      case QuestionStatus.unanswered:
        return AppTheme.neutralBackground;
    }
  }

  String get _statusLabel {
    switch (evaluation.status) {
      case QuestionStatus.correct:
        return 'Benar';
      case QuestionStatus.incorrect:
        return 'Salah';
      case QuestionStatus.unanswered:
        return 'Tidak Dijawab';
    }
  }

  IconData get _statusIcon {
    switch (evaluation.status) {
      case QuestionStatus.correct:
        return Icons.check_circle;
      case QuestionStatus.incorrect:
        return Icons.cancel;
      case QuestionStatus.unanswered:
        return Icons.help_outline;
    }
  }

  String _formatOptionSet(Question question, Set<int> indices) {
    if (indices.isEmpty) {
      return 'Tidak dijawab';
    }
    final sorted = indices.toList()..sort();
    return sorted
        .map((i) => '${Question.optionLetter(i)}. ${question.options[i]}')
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final question = evaluation.question;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey('result_item_${question.id}'),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: CircleAvatar(
            backgroundColor: _statusBackground,
            foregroundColor: _statusColor,
            child: Icon(_statusIcon, size: 22),
          ),
          title: Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Soal ${index + 1}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _statusBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _statusColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.selectedOptionBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  question.typeLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              question.text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
              ),
            ),
          ),
          children: [
            const Divider(height: 16),
            ...List.generate(question.options.length, (optIdx) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildOptionStatusTile(question, optIdx),
              );
            }),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailLine(
                    label: 'Tipe Soal',
                    value: question.typeLabel,
                  ),
                  const SizedBox(height: 6),
                  _buildDetailLine(
                    label: 'Jawaban Anda',
                    value: _formatOptionSet(
                      question,
                      evaluation.selectedAnswers,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildDetailLine(
                    label: 'Kunci Jawaban',
                    value: _formatOptionSet(
                      question,
                      question.correctAnswers,
                    ),
                  ),
                  const Divider(height: 18),
                  const Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 16,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Pembahasan',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    question.explanation,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF374151),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Menampilkan status visual per opsi sesuai Bagian 11.3 PRD:
  /// - Kunci dan dipilih: Hijau
  /// - Dipilih tetapi salah: Merah
  /// - Kunci tetapi tidak dipilih: Hijau outline
  /// - Lainnya: Putih netral
  Widget _buildOptionStatusTile(Question question, int optionIndex) {
    final isSelected = evaluation.selectedAnswers.contains(optionIndex);
    final isCorrectKey = question.correctAnswers.contains(optionIndex);
    final letter = Question.optionLetter(optionIndex);
    final text = question.options[optionIndex];

    Color backgroundColor = Colors.white;
    Color borderColor = AppTheme.borderColor;
    double borderWidth = 1.0;
    Color textColor = const Color(0xFF374151);
    Widget? trailingBadge;

    if (isCorrectKey && isSelected) {
      // Kunci dan dipilih -> Hijau
      backgroundColor = AppTheme.successBackground;
      borderColor = AppTheme.successColor;
      borderWidth = 1.5;
      textColor = const Color(0xFF14532D);
      trailingBadge = _buildBadge(
        label: 'Benar & Dipilih',
        color: AppTheme.successColor,
        icon: Icons.check_circle,
      );
    } else if (!isCorrectKey && isSelected) {
      // Dipilih tetapi salah -> Merah
      backgroundColor = AppTheme.errorBackground;
      borderColor = AppTheme.errorColor;
      borderWidth = 1.5;
      textColor = const Color(0xFF7F1D1D);
      trailingBadge = _buildBadge(
        label: 'Salah Pilih',
        color: AppTheme.errorColor,
        icon: Icons.cancel,
      );
    } else if (isCorrectKey && !isSelected) {
      // Kunci tetapi tidak dipilih -> Hijau outline
      backgroundColor = Colors.white;
      borderColor = AppTheme.successColor;
      borderWidth = 1.5;
      textColor = AppTheme.successColor;
      trailingBadge = _buildBadge(
        label: 'Kunci Terlewat',
        color: AppTheme.successColor,
        icon: Icons.check_circle_outline,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$letter.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: (isCorrectKey || isSelected)
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: textColor,
              ),
            ),
          ),
          if (trailingBadge != null) ...[
            const SizedBox(width: 8),
            trailingBadge,
          ],
        ],
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailLine({
    required String label,
    required String value,
  }) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 13,
          color: Color(0xFF374151),
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
