import 'package:flutter/material.dart';
import '../models/example_sentence.dart';
import '../utils/constants.dart';
import 'pronunciation_buttons.dart';

/// 例文表示セクション
class ExampleSection extends StatelessWidget {
  final ExampleSentence sentence;

  const ExampleSection({
    super.key,
    required this.sentence,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '例文',
          style: AppConstants.titleStyle,
        ),
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
            sentence.text,
            style: AppConstants.bodyStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        PronunciationButtons(audioPath: sentence.audioPath),
      ],
    );
  }
}
