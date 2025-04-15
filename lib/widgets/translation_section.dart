import 'package:flutter/material.dart';
import '../models/example_sentence.dart';
import '../utils/constants.dart';

/// 翻訳表示セクション
class TranslationSection extends StatelessWidget {
  final ExampleSentence sentence;
  final bool showTranslation;
  final VoidCallback onToggleTranslation;

  const TranslationSection({
    super.key,
    required this.sentence,
    required this.showTranslation,
    required this.onToggleTranslation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '日本語訳',
              style: AppConstants.titleStyle,
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: onToggleTranslation,
              icon: Icon(
                showTranslation ? Icons.visibility_off : Icons.visibility,
                color: AppConstants.primaryColor,
              ),
              label: Text(
                showTranslation ? '隠す' : '表示',
                style: const TextStyle(color: AppConstants.primaryColor),
              ),
            ),
          ],
        ),
        if (showTranslation) ...[
          const SizedBox(height: AppConstants.smallPadding),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              border: Border.all(color: AppConstants.primaryColor.withOpacity(0.3)),
            ),
            child: Text(
              sentence.translation,
              style: AppConstants.bodyStyle,
            ),
          ),
        ],
      ],
    );
  }
}
