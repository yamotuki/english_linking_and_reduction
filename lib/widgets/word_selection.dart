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
          children: _buildWordChips(),
        ),
      ],
    );
  }

  List<Widget> _buildWordChips() {
    // 単語ごとの出現回数と選択回数を追跡
    final Map<String, int> wordOccurrences = {};
    final Map<String, int> wordSelections = {};
    
    // 単語の出現回数をカウント
    for (final word in words) {
      wordOccurrences[word] = (wordOccurrences[word] ?? 0) + 1;
    }
    
    // 選択された単語の回数をカウント
    for (final word in selectedWords) {
      wordSelections[word] = (wordSelections[word] ?? 0) + 1;
    }
    
    // 単語チップのリストを作成
    final List<Widget> chips = [];
    for (final word in words) {
      final int occurrences = wordOccurrences[word] ?? 0;
      final int selections = wordSelections[word] ?? 0;
      
      // 選択可能かどうか（選択回数が出現回数より少ない場合は選択可能）
      final bool canBeSelected = selections < occurrences;
      
      // 完全に選択済みかどうか（選択回数が出現回数と同じ場合）
      final bool fullySelected = selections == occurrences;
      
      chips.add(_buildWordChip(word, fullySelected, canBeSelected));
    }
    
    return chips;
  }

  Widget _buildWordChip(String word, bool fullySelected, bool canBeSelected) {
    return ActionChip(
      label: Text(
        word,
        style: TextStyle(
          color: fullySelected ? Colors.grey : AppConstants.textColor,
        ),
      ),
      backgroundColor: fullySelected
          ? AppConstants.disabledColor.withOpacity(0.3)
          : AppConstants.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        side: BorderSide(
          color: fullySelected
              ? AppConstants.disabledColor
              : AppConstants.primaryColor,
        ),
      ),
      onPressed: () {
        if (selectedWords.contains(word) && !canBeSelected) {
          // 選択済みの単語をタップした場合は削除
          onWordRemoved(word);
        } else if (canBeSelected) {
          // 選択可能な単語をタップした場合は追加
          onWordSelected(word);
        }
      },
    );
  }
}
