import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// 文章組み立てウィジェット
class SentenceBuilder extends StatelessWidget {
  final List<String> selectedWords;
  final Function(String) onWordRemoved;

  const SentenceBuilder({
    super.key,
    required this.selectedWords,
    required this.onWordRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '文章を組み立てる',
          style: AppConstants.titleStyle,
        ),
        const SizedBox(height: AppConstants.smallPadding),
        const Text(
          'タップすると削除されます。',
          style: AppConstants.captionStyle,
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            border: Border.all(color: AppConstants.primaryColor.withOpacity(0.3)),
          ),
          constraints: const BoxConstraints(
            minHeight: 120, // 2行分のスペースを確保
            minWidth: double.infinity, // 横幅を最大に確保
          ),
          child: selectedWords.isEmpty
              ? const Center(
                  child: Text(
                    '単語を選択して文章を組み立ててください',
                    style: AppConstants.bodyStyle,
                  ),
                )
              : Wrap(
                  spacing: AppConstants.smallPadding,
                  runSpacing: AppConstants.smallPadding,
                  children: List.generate(selectedWords.length, (index) {
                    return _buildWordItem(selectedWords[index], index);
                  }),
                ),
        ),
      ],
    );
  }

  Widget _buildWordItem(String word, int index) {
    return Container(
      key: ValueKey('word_$index'),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(color: AppConstants.primaryColor),
      ),
      child: InkWell(
        onTap: () => onWordRemoved(word),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.smallPadding,
          ),
          child: Text(
            word,
            style: const TextStyle(
              color: AppConstants.textColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
