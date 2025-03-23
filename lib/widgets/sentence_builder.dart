import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import '../utils/constants.dart';

/// 文章組み立てウィジェット
class SentenceBuilder extends StatelessWidget {
  final List<String> selectedWords;
  final Function(int oldIndex, int newIndex) onReorder;
  final Function(String) onWordRemoved;

  const SentenceBuilder({
    super.key,
    required this.selectedWords,
    required this.onReorder,
    required this.onWordRemoved,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedWords.isEmpty) {
      return const Center(
        child: Text(
          '単語を選択して文章を組み立ててください',
          style: AppConstants.bodyStyle,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '文章を組み立てる',
          style: AppConstants.titleStyle,
        ),
        const SizedBox(height: AppConstants.smallPadding),
        const Text(
          'ドラッグして順序を変更できます。タップすると削除されます。',
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
          child: ReorderableGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            childAspectRatio: 2.5,
            mainAxisSpacing: AppConstants.smallPadding,
            crossAxisSpacing: AppConstants.smallPadding,
            children: selectedWords.map((word) => _buildWordItem(word)).toList(),
            onReorder: onReorder,
          ),
        ),
      ],
    );
  }

  Widget _buildWordItem(String word) {
    return Container(
      key: ValueKey(word),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(color: AppConstants.primaryColor),
      ),
      child: InkWell(
        onTap: () => onWordRemoved(word),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.smallPadding),
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
      ),
    );
  }
}
