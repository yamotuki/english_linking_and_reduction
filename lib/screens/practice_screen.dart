import 'package:flutter/material.dart';
import '../models/example_sentence.dart';
import '../models/lesson.dart';
import '../models/lesson_data.dart';
import '../utils/constants.dart';
import '../widgets/pronunciation_buttons.dart';
import '../widgets/sentence_builder.dart';
import '../widgets/word_selection.dart';

/// 練習画面
class PracticeScreen extends StatefulWidget {
  final LessonType lessonType;

  const PracticeScreen({
    super.key,
    required this.lessonType,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late List<ExampleSentence> _exampleSentences;
  int _currentIndex = 0;
  List<String> _selectedWords = [];
  bool _showTranslation = false;
  bool _showResult = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _exampleSentences = LessonData.getExampleSentences(widget.lessonType);
  }

  @override
  Widget build(BuildContext context) {
    final currentSentence = _exampleSentences[_currentIndex];
    final allWords = [
      ...currentSentence.words,
      ...currentSentence.distractors,
    ]..shuffle();

    return Scaffold(
      appBar: AppBar(
        title: Text('練習: ${_getLessonTitle()}'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressIndicator(),
            const SizedBox(height: AppConstants.defaultPadding),
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

  String _getLessonTitle() {
    final lessons = LessonData.getLessons();
    final lesson = lessons.firstWhere((l) => l.type == widget.lessonType);
    return lesson.title;
  }

  Widget _buildProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '例文 ${_currentIndex + 1}/${_exampleSentences.length}',
          style: AppConstants.captionStyle,
        ),
        const SizedBox(height: AppConstants.smallPadding),
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _exampleSentences.length,
          backgroundColor: AppConstants.disabledColor.withOpacity(0.3),
          valueColor: const AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
        ),
      ],
    );
  }

  Widget _buildExampleSection(ExampleSentence sentence) {
    // マスクされた例文を表示（TODO: マスク機能の実装）
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_currentIndex < _exampleSentences.length - 1)
              ElevatedButton(
                onPressed: _goToNextSentence,
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
                child: const Text('次の例文へ'),
              )
            else
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
                child: const Text('レッスン選択に戻る'),
              ),
          ],
        ),
      ],
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

  void _checkAnswer() {
    final currentSentence = _exampleSentences[_currentIndex];
    final correctWords = currentSentence.words;
    
    // 単語数が一致しているか確認
    if (_selectedWords.length != correctWords.length) {
      setState(() {
        _showResult = true;
        _isCorrect = false;
      });
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
  }

  void _goToNextSentence() {
    setState(() {
      _currentIndex++;
      _selectedWords = [];
      _showTranslation = false;
      _showResult = false;
    });
  }
}
