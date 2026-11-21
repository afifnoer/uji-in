import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:uji_in/data/questions_data.dart';
import 'package:uji_in/main.dart';
import 'package:uji_in/models/participant.dart';
import 'package:uji_in/models/question.dart';
import 'package:uji_in/models/quiz_result.dart';
import 'package:uji_in/providers/quiz_provider.dart';
import 'package:uji_in/screens/quiz_screen.dart';
import 'package:uji_in/services/scoring_service.dart';

void main() {
  group('Unit Tests - ScoringService & Model Consistency', () {
    test('Dataset kQuestions berisi 10 soal valid sesuai PRD 10.3', () {
      expect(kQuestions.length, 10);
      final singleCount =
          kQuestions.where((q) => q.type == QuestionType.single).length;
      final multipleCount =
          kQuestions.where((q) => q.type == QuestionType.multiple).length;
      expect(singleCount, 5);
      expect(multipleCount, 5);

      for (final q in kQuestions) {
        expect(q.options.length, 4);
        if (q.type == QuestionType.single) {
          expect(q.correctAnswers.length, 1);
        } else {
          expect(q.correctAnswers.length, greaterThanOrEqualTo(2));
        }
      }
    });

    test('TC-12: Jawab semua soal sesuai kunci menghasilkan skor 100 & Lulus',
        () {
      final allCorrectAnswers = <int, Set<int>>{
        for (final q in kQuestions) q.id: Set<int>.from(q.correctAnswers),
      };

      final result = ScoringService.calculateResult(
        questions: kQuestions,
        answers: allCorrectAnswers,
      );

      expect(result.totalScore, 100);
      expect(result.isPassed, isTrue);
      expect(result.correctCount, 10);
      expect(result.incorrectCount, 0);
      expect(result.unansweredCount, 0);
    });

    test(
        'TC-13: Soal multi-jawaban hanya sebagian kunci atau ada pengecoh dinilai Salah (skor 0)',
        () {
      final multiQuestion = kQuestions[1]; // Soal 2, kunci: {0, 1, 2}

      // Sebagian kunci
      final partialEval =
          ScoringService.evaluateQuestion(multiQuestion, {0, 1});
      expect(partialEval.status, QuestionStatus.incorrect);
      expect(partialEval.score, 0);

      // Menyertakan pengecoh
      final distractorEval =
          ScoringService.evaluateQuestion(multiQuestion, {0, 1, 2, 3});
      expect(distractorEval.status, QuestionStatus.incorrect);
      expect(distractorEval.score, 0);

      // Kosong
      final emptyEval = ScoringService.evaluateQuestion(multiQuestion, {});
      expect(emptyEval.status, QuestionStatus.unanswered);
      expect(emptyEval.score, 0);

      // Tepat sama dengan kunci
      final exactEval =
          ScoringService.evaluateQuestion(multiQuestion, {0, 1, 2});
      expect(exactEval.status, QuestionStatus.correct);
      expect(exactEval.score, 1);
    });

    test('TC-14: Jawab 7 soal benar dan 3 soal salah menghasilkan skor 70 Lulus',
        () {
      final answers = <int, Set<int>>{};
      for (int i = 0; i < kQuestions.length; i++) {
        final q = kQuestions[i];
        if (i < 7) {
          answers[q.id] = Set<int>.from(q.correctAnswers);
        } else {
          // Pilih jawaban yang pasti salah
          answers[q.id] = {2};
        }
      }

      final result = ScoringService.calculateResult(
        questions: kQuestions,
        answers: answers,
      );

      expect(result.totalScore, 70);
      expect(result.isPassed, isTrue);
      expect(result.correctCount, 7);
      expect(result.incorrectCount, 3);
      expect(result.unansweredCount, 0);
    });
  });

  group('Widget & Integration Tests (TC-01 s/d TC-18)', () {
    testWidgets('TC-01, TC-02, TC-03: Welcome ke Data Diri, validasi, & Lanjut',
        (WidgetTester tester) async {
      await tester.pumpWidget(const LatihanSoalApp());
      await tester.pumpAndSettle();

      // TC-01: Logo, judul, dan tombol Mulai tampil
      expect(find.text('Selamat Datang di Latihan Soal'), findsOneWidget);
      expect(find.byKey(const ValueKey('start_button')), findsOneWidget);

      // Masuk ke layar Data Diri
      final startBtnFinder = find.byKey(const ValueKey('start_button'));
      await tester.ensureVisible(startBtnFinder);
      await tester.pumpAndSettle();
      await tester.tap(startBtnFinder);
      await tester.pumpAndSettle();

      expect(find.text('Data Diri Peserta'), findsOneWidget);

      // TC-02: Tombol Lanjut nonaktif saat form kosong / belum valid
      final continueBtnFinder = find.byKey(const ValueKey('continue_button'));
      FilledButton continueBtn = tester.widget<FilledButton>(continueBtnFinder);
      expect(continueBtn.onPressed, isNull);

      // Uji validasi nama kurang dari 3 karakter & NIM huruf
      await tester.enterText(find.byKey(const ValueKey('input_name')), 'Ab');
      await tester.enterText(find.byKey(const ValueKey('input_nim')), '12A');
      await tester.pump();

      expect(find.text('Nama lengkap minimal 3 karakter'), findsOneWidget);
      expect(find.text('NIM hanya boleh berisi angka'), findsOneWidget);

      // TC-03: Isi seluruh data valid lalu tekan Lanjut
      await tester.enterText(
        find.byKey(const ValueKey('input_name')),
        'Budi Santoso',
      );
      await tester.enterText(
        find.byKey(const ValueKey('input_nim')),
        '2401001',
      );
      await tester.pump();

      final deptFinder = find.byKey(const ValueKey('dropdown_department'));
      await tester.ensureVisible(deptFinder);
      await tester.tap(deptFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Komputer dan Bisnis').last);
      await tester.pumpAndSettle();

      final prodiFinder = find.byKey(const ValueKey('dropdown_study_program'));
      await tester.ensureVisible(prodiFinder);
      await tester.tap(prodiFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Teknik Informatika').last);
      await tester.pumpAndSettle();

      final classFinder = find.byKey(const ValueKey('dropdown_class'));
      await tester.ensureVisible(classFinder);
      await tester.tap(classFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.text('1A').last);
      await tester.pumpAndSettle();

      continueBtn = tester.widget<FilledButton>(continueBtnFinder);
      expect(continueBtn.onPressed, isNotNull);

      await tester.ensureVisible(continueBtnFinder);
      await tester.pumpAndSettle();
      await tester.tap(continueBtnFinder);
      await tester.pumpAndSettle();

      // Masuk ke soal nomor 1
      expect(find.text('Soal 1 dari 10'), findsOneWidget);
    });

    testWidgets(
        'TC-04 s/d TC-11: RadioListTile, CheckboxListTile, toggleable, navigasi, panel nomor, & dialog submit',
        (WidgetTester tester) async {
      final provider = QuizProvider();
      provider.setParticipant(
        const Participant(
          name: 'Siti Aminah',
          nim: '2402002',
          department: 'Komputer dan Bisnis',
          studyProgram: 'Rekayasa Perangkat Lunak',
          className: '2B',
        ),
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<QuizProvider>.value(
          value: provider,
          child: const MaterialApp(
            home: QuizScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // TC-04: Soal 1 adalah Pilihan Tunggal (RadioListTile)
      expect(find.text('Pilihan Tunggal'), findsOneWidget);
      expect(find.text('Pilih satu jawaban yang benar.'), findsOneWidget);
      expect(find.byType(RadioListTile<int>), findsNWidgets(4));
      expect(find.byType(CheckboxListTile), findsNothing);

      // TC-05: Pilih opsi A lalu opsi C pada soal pilihan tunggal
      final radioA = find.byKey(const ValueKey('radio_1_0'));
      final radioC = find.byKey(const ValueKey('radio_1_2'));

      await tester.ensureVisible(radioA);
      await tester.tap(radioA);
      await tester.pumpAndSettle();
      expect(provider.selectedAnswersFor(1), {0});

      await tester.ensureVisible(radioC);
      await tester.tap(radioC);
      await tester.pumpAndSettle();
      expect(provider.selectedAnswersFor(1), {2});

      // TC-07 (Radio): Ketuk ulang opsi C yang sudah terpilih -> batal (toggleable)
      await tester.tap(radioC);
      await tester.pumpAndSettle();
      expect(provider.selectedAnswersFor(1), isEmpty);

      // Pilih kembali opsi A pada soal 1 untuk menguji persistensi (TC-08)
      await tester.tap(radioA);
      await tester.pumpAndSettle();
      expect(provider.selectedAnswersFor(1), {0});

      // Pindah ke soal 2 (Multi Jawaban)
      await tester.tap(find.byKey(const ValueKey('next_button')));
      await tester.pumpAndSettle();

      // TC-04: Soal 2 adalah Multi Jawaban (CheckboxListTile)
      expect(find.text('Soal 2 dari 10'), findsOneWidget);
      expect(find.text('Multi Jawaban'), findsOneWidget);
      expect(
        find.text('Pilih semua jawaban yang benar (bisa lebih dari satu).'),
        findsOneWidget,
      );
      expect(find.byType(CheckboxListTile), findsNWidgets(4));
      expect(find.byType(RadioListTile<int>), findsNothing);

      // TC-06: Centang opsi A lalu opsi C pada soal multi-jawaban
      final checkA = find.byKey(const ValueKey('checkbox_2_0'));
      final checkC = find.byKey(const ValueKey('checkbox_2_2'));

      await tester.ensureVisible(checkA);
      await tester.tap(checkA);
      await tester.pumpAndSettle();
      await tester.ensureVisible(checkC);
      await tester.tap(checkC);
      await tester.pumpAndSettle();
      expect(provider.selectedAnswersFor(2), {0, 2});

      // TC-07 (Checkbox): Ketuk ulang opsi A -> hanya A yang batal, C tetap bertahan
      await tester.tap(checkA);
      await tester.pumpAndSettle();
      expect(provider.selectedAnswersFor(2), {2});

      // TC-08: Kembali ke soal 1 -> pilihan A tetap ada
      await tester.tap(find.byKey(const ValueKey('prev_button')));
      await tester.pumpAndSettle();
      expect(find.text('Soal 1 dari 10'), findsOneWidget);
      expect(provider.selectedAnswersFor(1), {0});

      // TC-09: Ketuk angka 7 pada panel nomor -> langsung ke soal 7
      final nav7Finder = find.byKey(const ValueKey('nav_question_7'));
      await tester.ensureVisible(nav7Finder);
      await tester.pumpAndSettle();
      await tester.tap(nav7Finder);
      await tester.pumpAndSettle();
      expect(find.text('Soal 7 dari 10'), findsOneWidget);

      // TC-10: Panel nomor mencatat soal 1 dan 2 sudah dijawab
      expect(provider.isQuestionAnswered(1), isTrue);
      expect(provider.isQuestionAnswered(2), isTrue);
      expect(provider.isQuestionAnswered(7), isFalse);

      // TC-11: Jawab 8 soal (sisakan 2 soal kosong), lompat ke soal 10 lalu Submit
      for (int i = 0; i < 8; i++) {
        final q = kQuestions[i];
        if (!provider.isQuestionAnswered(q.id)) {
          provider.toggleAnswer(q, q.correctAnswers.first);
        }
      }
      provider.goTo(9); // Soal 10 (indeks 9)
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('submit_button')), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('submit_button')));
      await tester.pumpAndSettle();

      expect(find.text('Kirim jawaban?'), findsOneWidget);
      expect(
        find.textContaining('Masih ada 2 soal belum dijawab'),
        findsOneWidget,
      );
    });

    testWidgets(
        'TC-15, TC-16, TC-17: Layar Hasil, detail pembahasan, Ulangi Latihan, & Kembali ke Awal',
        (WidgetTester tester) async {
      await tester.pumpWidget(const LatihanSoalApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(Scaffold));
      final provider = Provider.of<QuizProvider>(context, listen: false);

      provider.setParticipant(
        const Participant(
          name: 'Andi Pratama',
          nim: '2403003',
          department: 'Komputer dan Bisnis',
          studyProgram: 'Teknologi Rekayasa Multimedia',
          className: '1C',
        ),
      );

      // Jawab seluruh soal dengan benar kecuali soal terakhir
      for (int i = 0; i < kQuestions.length - 1; i++) {
        final q = kQuestions[i];
        for (final ans in q.correctAnswers) {
          provider.toggleAnswer(q, ans);
        }
      }
      provider.goTo(9);

      // Navigasi dari Welcome -> Profile -> Quiz, atau langsung lewat tombol
      final startBtnFinder = find.byKey(const ValueKey('start_button'));
      await tester.ensureVisible(startBtnFinder);
      await tester.pumpAndSettle();
      await tester.tap(startBtnFinder);
      await tester.pumpAndSettle();

      // Isi form untuk masuk ke QuizScreen
      await tester.enterText(
        find.byKey(const ValueKey('input_name')),
        'Andi Pratama',
      );
      await tester.enterText(
        find.byKey(const ValueKey('input_nim')),
        '2403003',
      );
      final deptFinder = find.byKey(const ValueKey('dropdown_department'));
      await tester.ensureVisible(deptFinder);
      await tester.tap(deptFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Komputer dan Bisnis').last);
      await tester.pumpAndSettle();

      final prodiFinder = find.byKey(const ValueKey('dropdown_study_program'));
      await tester.ensureVisible(prodiFinder);
      await tester.tap(prodiFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Teknologi Rekayasa Multimedia').last);
      await tester.pumpAndSettle();

      final classFinder = find.byKey(const ValueKey('dropdown_class'));
      await tester.ensureVisible(classFinder);
      await tester.tap(classFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.text('1C').last);
      await tester.pumpAndSettle();

      final continueBtn = find.byKey(const ValueKey('continue_button'));
      await tester.ensureVisible(continueBtn);
      await tester.pumpAndSettle();
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      // Jawab semua 10 soal sesuai kunci
      for (final q in kQuestions) {
        for (final ans in q.correctAnswers) {
          provider.toggleAnswer(q, ans);
        }
      }
      provider.goTo(9);
      await tester.pumpAndSettle();

      // Submit
      await tester.tap(find.byKey(const ValueKey('submit_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('confirm_submit_button')));
      await tester.pumpAndSettle();

      // Layar Hasil tampil dengan skor 100 & Lulus
      expect(find.text('Hasil Latihan Soal'), findsOneWidget);
      expect(find.byKey(const ValueKey('final_score_text')), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.text('Lulus'), findsOneWidget);
      expect(find.text('Andi Pratama'), findsOneWidget);

      // TC-15: Buka detail soal 1 di layar hasil
      final resultItem1 = find.byKey(const ValueKey('result_item_1'));
      await tester.scrollUntilVisible(
        resultItem1,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(resultItem1);
      await tester.pumpAndSettle();

      expect(
        find.text('ListView menampilkan daftar yang dapat digulir.'),
        findsOneWidget,
      );

      // TC-16: Tekan Ulangi Latihan -> Jawaban kosong, data diri tetap
      await tester.tap(find.byKey(const ValueKey('retry_quiz_button')));
      await tester.pumpAndSettle();

      expect(find.text('Soal 1 dari 10'), findsOneWidget);
      expect(provider.answeredCount, 0);
      expect(provider.participant?.name, 'Andi Pratama');

      // Submit lagi untuk menguji TC-17 (Kembali ke Awal)
      provider.goTo(9);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('submit_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('confirm_submit_button')));
      await tester.pumpAndSettle();

      // TC-17: Tekan Kembali ke Awal -> kembali ke Welcome, data direset
      await tester.tap(find.byKey(const ValueKey('back_to_start_button')));
      await tester.pumpAndSettle();

      expect(find.text('Selamat Datang di Latihan Soal'), findsOneWidget);
      expect(provider.participant, isNull);
      expect(provider.answeredCount, 0);
    });

    testWidgets('TC-18: Uji di layar kecil (360 px) tidak terjadi overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const LatihanSoalApp());
      await tester.pumpAndSettle();

      // Layar Welcome di 360px
      expect(find.text('Selamat Datang di Latihan Soal'), findsOneWidget);

      final startBtn = find.byKey(const ValueKey('start_button'));
      await tester.ensureVisible(startBtn);
      await tester.tap(startBtn);
      await tester.pumpAndSettle();

      // Layar Data Diri di 360px dengan nama prodi terpanjang
      await tester.enterText(
        find.byKey(const ValueKey('input_name')),
        'Peserta Layar Kecil',
      );
      await tester.enterText(
        find.byKey(const ValueKey('input_nim')),
        '240999',
      );

      final deptDropdown = find.byKey(const ValueKey('dropdown_department'));
      await tester.ensureVisible(deptDropdown);
      await tester.tap(deptDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Komputer dan Bisnis').last);
      await tester.pumpAndSettle();

      final prodiDropdown =
          find.byKey(const ValueKey('dropdown_study_program'));
      await tester.ensureVisible(prodiDropdown);
      await tester.tap(prodiDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Akuntansi Lembaga Keuangan Syariah').last);
      await tester.pumpAndSettle();

      final classDropdown = find.byKey(const ValueKey('dropdown_class'));
      await tester.ensureVisible(classDropdown);
      await tester.tap(classDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('2C').last);
      await tester.pumpAndSettle();

      final continueBtn = find.byKey(const ValueKey('continue_button'));
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      // Layar Soal di 360px
      expect(find.text('Soal 1 dari 10'), findsOneWidget);
    });
  });
}
