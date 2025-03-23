import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// 単語選択ウィジェット
class WordSelection extends StatelessWidget {
  final List<String> words;
  final List<String> selectedWords;
  final Function(String) onWordSelected;
  final Function(String) onWordRemoved;

  const WordSelection({
    super.key,
    required this.words,
    required this.selectedWords,
    required this.onWordSelected,
    required this.onWordRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '単語を選択してください',
          style: AppConstants.titleStyle,
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Wrap(
          spacing: AppConstants.smallPadding,
          runSpacing: AppConstants.smallPadding,
          children: words.map((word) {
            final isSelected = selectedWords.contains(word);
            return _buildWordChip(word, isSelected);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWordChip(String word, bool isSelected) {
    return ActionChip(
      label: Text(
        word,
        style: TextStyle(
          color: isSelected ? Colors.grey : AppConstants.textColor,
          decoration: isSelected ? TextDecoration.lineThrough : null,
        ),
      ),
      backgroundColor: isSelected
          ? AppConstants.disabledColor.withOpacity(0.3)
          : AppConstants.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        side: BorderSide(
          color: isSelected
              ? AppConstants.disabledColor
              : AppConstants.primaryColor,
        ),
      ),
      onPressed: () {
        if (isSelected) {
          onWordRemoved(word);
        } else {
          onWordSelected(word);
        }
      },
    );
  }
}
