import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// アクションボタンウィジェット
class ActionButtons extends StatelessWidget {
  final bool showResult;
  final bool isEmptySelection;
  final VoidCallback onCheck;
  final VoidCallback onNext;

  const ActionButtons({
    super.key,
    required this.showResult,
    required this.isEmptySelection,
    required this.onCheck,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    if (showResult) {
      // 結果表示後は「次の問題」ボタンを表示
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.largePadding,
                vertical: AppConstants.defaultPadding,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
            ),
            child: const Text('次の問題'),
          ),
        ],
      );
    } else {
      // 通常時は「完成」ボタンを表示
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: isEmptySelection ? null : onCheck,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.largePadding,
                vertical: AppConstants.defaultPadding,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
            ),
            child: const Text('完成'),
          ),
        ],
      );
    }
  }
}
