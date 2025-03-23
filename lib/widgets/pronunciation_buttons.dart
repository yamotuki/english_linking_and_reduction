import 'package:flutter/material.dart';
import '../utils/audio_player_util.dart';
import '../utils/constants.dart';

/// 発音ボタンウィジェット
class PronunciationButtons extends StatelessWidget {
  final String audioPath;

  const PronunciationButtons({
    super.key,
    required this.audioPath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(
          context,
          icon: Icons.volume_up,
          label: '発音',
          onPressed: () => AudioPlayerUtil().play(audioPath),
        ),
        const SizedBox(width: AppConstants.defaultPadding),
        _buildButton(
          context,
          icon: Icons.slow_motion_video,
          label: '遅く',
          onPressed: () => AudioPlayerUtil().playSlowly(audioPath),
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
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
    );
  }
}
