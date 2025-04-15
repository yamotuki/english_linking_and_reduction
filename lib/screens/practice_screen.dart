import 'package:flutter/material.dart';
import '../models/example_sentence.dart';
import '../utils/constants.dart';
import '../utils/local_storage.dart';
import '../widgets/pronunciation_buttons.dart';
import '../widgets/sentence_builder.dart';
import '../widgets/word_selection.dart';

/// 練習画面
class PracticeScreen extends StatefulWidget {
  final ExampleSentence exampleSentence;

  const PracticeScreen({
    super.key,
    required this.exampleSentence,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  List<String> _selectedWords = [];
  bool _showTranslation = false;
  bool _showResult = false;
  bool _isCorrect = false;

  @override
  Widget build(BuildContext context) {
    final currentSentence = widget.exampleSentence;
    final allWords = [
      ...currentSentence.words,
      ...currentSentence.distractors,
    ]..shuffle();

    return Scaffold(
      appBar: AppBar(
        title: const Text('例文練習'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExampleSection(currentSentence),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildTranslationSection(currentSentence),
            const SizedBox(height: AppConstants.largePadding),
            SentenceBuilder(
              selectedWords: _selectedWords,
              onReorder: _handleReorder,
              onWordRemoved: _handleWordRemoved,
            ),
            const SizedBox(height: AppConstants.largePadding),
            WordSelection(
              words: allWords,
              selectedWords: _selectedWords,
              onWordSelected: _handleWordSelected,
              onWordRemoved: _handleWordRemoved,
            ),
            const SizedBox(height: AppConstants.largePadding),
            _buildActionButtons(),
            if (_showResult) ...[
              const SizedBox(height: AppConstants.defaultPadding),
              _buildResultSection(currentSentence),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExampleSection(ExampleSentence sentence) {
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

  Widget _buildTranslationSection(ExampleSentence sentence) {
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
              onPressed: () {
                setState(() {
                  _showTranslation = !_showTranslation;
                });
              },
              icon: Icon(
                _showTranslation ? Icons.visibility_off : Icons.visibility,
                color: AppConstants.primaryColor,
              ),
              label: Text(
                _showTranslation ? '隠す' : '表示',
                style: const TextStyle(color: AppConstants.primaryColor),
              ),
            ),
          ],
        ),
        if (_showTranslation) ...[
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

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _selectedWords.isEmpty ? null : _checkAnswer,
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

  Widget _buildResultSection(ExampleSentence sentence) {
    final resultColor = _isCorrect ? Colors.green : Colors.red;
    final resultIcon = _isCorrect ? Icons.check_circle : Icons.error;
    final resultText = _isCorrect ? '正解！' : '不正解';

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
        if (!_isCorrect) ...[
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
              onPressed: () {
                Navigator.pop(context);
              },
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

  void _handleWordSelected(String word) {
    setState(() {
      _selectedWords.add(word);
    });
  }

  void _handleWordRemoved(String word) {
    setState(() {
      _selectedWords.remove(word);
    });
  }

  void _handleReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _selectedWords.removeAt(oldIndex);
      _selectedWords.insert(newIndex, item);
    });
  }

  Future<void> _checkAnswer() async {
    final currentSentence = widget.exampleSentence;
    final correctWords = currentSentence.words;
    
    // 単語数が一致しているか確認
    if (_selectedWords.length != correctWords.length) {
      setState(() {
        _showResult = true;
        _isCorrect = false;
      });
      
      // 不正解として記録
      await LocalStorage.markExampleAsIncorrectlyAnswered(currentSentence.id);
      return;
    }
    
    // 単語の順序が正しいか確認
    bool isCorrect = true;
    for (int i = 0; i < correctWords.length; i++) {
      if (_selectedWords[i] != correctWords[i]) {
        isCorrect = false;
        break;
      }
    }
    
    setState(() {
      _showResult = true;
      _isCorrect = isCorrect;
    });
    
    // 回答状態を保存
    if (isCorrect) {
      await LocalStorage.markExampleAsCorrectlyAnswered(currentSentence.id);
    } else {
      await LocalStorage.markExampleAsIncorrectlyAnswered(currentSentence.id);
    }
  }
}
