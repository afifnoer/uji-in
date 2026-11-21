import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/question.dart';

class OptionTile extends StatelessWidget {
  final Question question;
  final int optionIndex;
  final String optionText;
  final bool isSelected;
  final int? selectedSingleValue;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.question,
    required this.optionIndex,
    required this.optionText,
    required this.isSelected,
    required this.selectedSingleValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final letter = Question.optionLetter(optionIndex);
    final backgroundColor =
        isSelected ? AppTheme.selectedOptionBackground : Colors.white;
    final borderColor =
        isSelected ? AppTheme.selectedOptionBorder : AppTheme.borderColor;
    final borderWidth = isSelected ? 1.5 : 1.0;

    final titleWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryColor
                : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            letter,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: isSelected ? Colors.white : const Color(0xFF374151),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              optionText,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? const Color(0xFF0F2952)
                    : const Color(0xFF1F2937),
              ),
            ),
          ),
        ),
      ],
    );

    return Semantics(
      label: 'Opsi $letter: $optionText',
      selected: isSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: question.isMultipleChoice
              ? CheckboxListTile(
                  key: ValueKey('checkbox_${question.id}_$optionIndex'),
                  value: isSelected,
                  onChanged: (_) => onTap(),
                  title: titleWidget,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppTheme.primaryColor,
                  checkboxShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                )
              : RadioListTile<int>(
                  key: ValueKey('radio_${question.id}_$optionIndex'),
                  value: optionIndex,
                  // ignore: deprecated_member_use
                  groupValue: selectedSingleValue,
                  // ignore: deprecated_member_use
                  onChanged: (_) => onTap(),
                  toggleable: true,
                  title: titleWidget,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppTheme.primaryColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
        ),
      ),
    );
  }
}
