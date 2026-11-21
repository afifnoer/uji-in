import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../models/participant.dart';
import '../providers/quiz_provider.dart';
import 'quiz_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();

  String? _selectedDepartment;
  String? _selectedStudyProgram;
  String? _selectedClass;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFieldChanged);
    _nimController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFieldChanged);
    _nimController.removeListener(_onFieldChanged);
    _nameController.dispose();
    _nimController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    setState(() {});
  }

  static String? validateName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Nama lengkap wajib diisi';
    }
    if (trimmed.length < 3) {
      return 'Nama lengkap minimal 3 karakter';
    }
    if (trimmed.length > 50) {
      return 'Nama lengkap maksimal 50 karakter';
    }
    return null;
  }

  static String? validateNim(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'NIM wajib diisi';
    }
    if (!RegExp(r'^\d+$').hasMatch(trimmed)) {
      return 'NIM hanya boleh berisi angka';
    }
    return null;
  }

  bool get _isFormValid {
    return validateName(_nameController.text) == null &&
        validateNim(_nimController.text) == null &&
        _selectedDepartment != null &&
        _selectedStudyProgram != null &&
        _selectedClass != null;
  }

  void _handleContinue() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false) || !_isFormValid) {
      return;
    }

    final participant = Participant(
      name: _nameController.text.trim(),
      nim: _nimController.text.trim(),
      department: _selectedDepartment!,
      studyProgram: _selectedStudyProgram!,
      className: _selectedClass!,
    );

    context.read<QuizProvider>().setParticipant(participant);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const QuizScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Data Diri Peserta'),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppTheme.maxContentWidth,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Lengkapi data diri Anda sebelum memulai',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildLabel('Nama Lengkap'),
                              const SizedBox(height: 6),
                              TextFormField(
                                key: const ValueKey('input_name'),
                                controller: _nameController,
                                textInputAction: TextInputAction.next,
                                maxLength: 50,
                                decoration: const InputDecoration(
                                  hintText: 'Masukkan nama lengkap (3-50 karakter)',
                                  prefixIcon: Icon(Icons.badge_outlined),
                                  counterText: '',
                                ),
                                validator: validateName,
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('NIM'),
                              const SizedBox(height: 6),
                              TextFormField(
                                key: const ValueKey('input_nim'),
                                controller: _nimController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  hintText: 'Masukkan NIM (hanya angka)',
                                  prefixIcon: Icon(Icons.numbers_rounded),
                                ),
                                validator: validateNim,
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('Jurusan'),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                key: const ValueKey('dropdown_department'),
                                initialValue: _selectedDepartment,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  hintText: 'Pilih Jurusan',
                                  prefixIcon: Icon(Icons.domain_outlined),
                                ),
                                items: Participant.departments
                                    .map(
                                      (dept) => DropdownMenuItem<String>(
                                        value: dept,
                                        child: Text(
                                          dept,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDepartment = value;
                                  });
                                },
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Jurusan wajib dipilih'
                                        : null,
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('Program Studi (Prodi)'),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                key: const ValueKey('dropdown_study_program'),
                                initialValue: _selectedStudyProgram,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  hintText: 'Pilih Program Studi',
                                  prefixIcon: Icon(Icons.school_outlined),
                                ),
                                items: Participant.studyPrograms
                                    .map(
                                      (prodi) => DropdownMenuItem<String>(
                                        value: prodi,
                                        child: Text(
                                          prodi,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedStudyProgram = value;
                                  });
                                },
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Program studi wajib dipilih'
                                        : null,
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('Kelas'),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                key: const ValueKey('dropdown_class'),
                                initialValue: _selectedClass,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  hintText: 'Pilih Kelas',
                                  prefixIcon: Icon(Icons.class_outlined),
                                ),
                                items: Participant.classes
                                    .map(
                                      (kelas) => DropdownMenuItem<String>(
                                        value: kelas,
                                        child: Text(
                                          kelas,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedClass = value;
                                  });
                                },
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Kelas wajib dipilih'
                                        : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        key: const ValueKey('continue_button'),
                        onPressed: _isFormValid ? _handleContinue : null,
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text('Lanjut'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F2937),
      ),
    );
  }
}
