import 'package:flutter/material.dart';
import '../models/example_sentence.dart';
import '../utils/constants.dart';

/// 結果表示セクション
class ResultSection extends StatelessWidget {
  final ExampleSentence sentence;
  final bool isCorrect;
  final VoidCallback onBackToList;
  final VoidCallback onNextExample;

  const ResultSection({
    super.key,
    required this.sentence,
    required this.isCorrect,
    required this.onBackToList,
    required this.onNextExample,
  });

  @override
  Widget build(BuildContext context) {
    final resultColor = isCorrect ? Colors.green : Colors.red;
    final resultIcon = isCorrect ? Icons.check_circle : Icons.error;
    final resultText = isCorrect ? '正解！' : '不正解';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(resultIcon, color: resultColor, size: 24),
            const SizedBox(width: AppConstants.smallPadding),
            Text(
              resultText,
              style: AppConstants.titleStyle.copyWith(color: resultColor),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        if (!isCorrect) ...[
          const Text(
            '正解:',
            style: AppConstants.bodyStyle,
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
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        const SizedBox(height: AppConstants.defaultPadding),
        
        // 文章表現と口語表現
        const Text(
          '文章表現:',
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
            style: AppConstants.bodyStyle,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        
        if (sentence.pronunciationText != null) ...[
          const Text(
            '口語表現:',
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
              sentence.pronunciationText!,
              style: AppConstants.bodyStyle,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
        ],
        
        // 解説
        if (sentence.explanations != null && sentence.explanations!.isNotEmpty) ...[
          const Text(
            '解説:',
            style: AppConstants.titleStyle,
          ),
          const SizedBox(height: AppConstants.smallPadding),
          ...sentence.explanations!.map((explanation) => _buildExplanationItem(explanation)),
          const SizedBox(height: AppConstants.defaultPadding),
        ],
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: onBackToList,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                  vertical: AppConstants.smallPadding,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                ),
              ),
              child: const Text('例文一覧に戻る'),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            ElevatedButton(
              onPressed: onNextExample,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                  vertical: AppConstants.smallPadding,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                ),
              ),
              child: const Text('次の問題'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExplanationItem(ExplanationItem explanation) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(color: AppConstants.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '【${explanation.key}】',
            style: AppConstants.bodyStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            explanation.content,
            style: AppConstants.bodyStyle,
          ),
        ],
      ),
    );
  }
}
