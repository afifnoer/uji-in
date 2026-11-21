import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../providers/quiz_provider.dart';
import '../widgets/option_tile.dart';
import '../widgets/question_navigator.dart';
import 'result_screen.dart';
import 'welcome_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _isDialogProcessing = false;

  Future<void> _showExitConfirmationDialog() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar dari latihan?'),
        content: const Text('Jawaban Anda tidak akan tersimpan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              minimumSize: const Size(0, 40),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (shouldExit == true && mounted) {
      context.read<QuizProvider>().reset();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _showSubmitConfirmationDialog(QuizProvider provider) async {
    if (_isDialogProcessing || provider.isSubmitting) {
      return;
    }

    final unanswered = provider.unansweredCount;
    final message = unanswered > 0
        ? 'Masih ada $unanswered soal belum dijawab. Apakah Anda yakin ingin mengirim jawaban?'
        : 'Seluruh soal telah dijawab. Apakah Anda yakin ingin mengirim jawaban?';

    final shouldSubmit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Kirim jawaban?'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            key: const ValueKey('confirm_submit_button'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 40),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Kirim'),
          ),
        ],
      ),
    );

    if (shouldSubmit == true && mounted) {
      setState(() {
        _isDialogProcessing = true;
      });
      provider.submit();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResultScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, _) {
        final question = provider.currentQuestion;
        final selectedAnswers = provider.selectedAnswersFor(question.id);
        final selectedSingleValue =
            selectedAnswers.isEmpty ? null : selectedAnswers.first;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            _showExitConfirmationDialog();
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Keluar dari latihan',
                onPressed: _showExitConfirmationDialog,
              ),
              title: Text(
                'Soal ${provider.currentIndex + 1} dari ${provider.totalQuestions}',
                key: const ValueKey('question_counter_text'),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.selectedOptionBackground,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${provider.answeredCount}/${provider.totalQuestions} Terjawab',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(6),
                child: LinearProgressIndicator(
                  value: provider.progress,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE5E7EB),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryColor,
                  ),
                ),
              ),
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
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              QuestionNavigator(
                                questions: provider.questions,
                                currentIndex: provider.currentIndex,
                                isQuestionAnswered: provider.isQuestionAnswered,
                                onSelectQuestion: provider.goTo,
                              ),
                              const SizedBox(height: 16),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: question.isMultipleChoice
                                                  ? const Color(0xFFFEF3C7)
                                                  : AppTheme
                                                      .selectedOptionBackground,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  question.isMultipleChoice
                                                      ? Icons
                                                          .fact_check_outlined
                                                      : Icons
                                                          .radio_button_checked,
                                                  size: 15,
                                                  color: question
                                                          .isMultipleChoice
                                                      ? const Color(0xFFB45309)
                                                      : AppTheme.primaryColor,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  question.typeLabel,
                                                  key: const ValueKey(
                                                    'question_type_badge',
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: question
                                                            .isMultipleChoice
                                                        ? const Color(
                                                            0xFFB45309,
                                                          )
                                                        : AppTheme.primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        question.instructionText,
                                        key: const ValueKey(
                                          'question_instruction_text',
                                        ),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic,
                                          color: Color(0xFF4B5563),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        question.text,
                                        key: const ValueKey('question_text'),
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF111827),
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: question.options.length,
                                        separatorBuilder: (_, _) =>
                                            const SizedBox(height: 10),
                                        itemBuilder: (context, optionIndex) {
                                          final isSelected = selectedAnswers
                                              .contains(optionIndex);
                                          return OptionTile(
                                            question: question,
                                            optionIndex: optionIndex,
                                            optionText:
                                                question.options[optionIndex],
                                            isSelected: isSelected,
                                            selectedSingleValue:
                                                selectedSingleValue,
                                            onTap: () => provider.toggleAnswer(
                                              question,
                                              optionIndex,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                                key: const ValueKey('prev_button'),
                                onPressed: provider.isFirstQuestion
                                    ? null
                                    : provider.previous,
                                icon: const Icon(Icons.arrow_back_rounded),
                                label: const Text('Sebelumnya'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: provider.isLastQuestion
                                  ? FilledButton.icon(
                                      key: const ValueKey('submit_button'),
                                      onPressed: (_isDialogProcessing ||
                                              provider.isSubmitting)
                                          ? null
                                          : () => _showSubmitConfirmationDialog(
                                                provider,
                                              ),
                                      icon: const Icon(
                                        Icons.check_circle_outline,
                                      ),
                                      label: const Text('Submit'),
                                    )
                                  : FilledButton.icon(
                                      key: const ValueKey('next_button'),
                                      onPressed: provider.next,
                                      icon: const Icon(
                                        Icons.arrow_forward_rounded,
                                      ),
                                      label: const Text('Selanjutnya'),
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
