import 'package:flutter/material.dart';
import '../models/example_sentence.dart';
import '../models/lesson_data.dart';
import '../utils/constants.dart';
import '../utils/local_storage.dart';
import '../widgets/action_buttons.dart';
import '../widgets/example_section.dart';
import '../widgets/result_section.dart';
import '../widgets/sentence_builder.dart';
import '../widgets/translation_section.dart';
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

  // 単語リストを保持
  List<String> _allWords = [];
  
  @override
  void initState() {
    super.initState();
    // 初期化時に単語リストを作成
    _allWords = [
      ...widget.exampleSentence.words,
      ...widget.exampleSentence.distractors,
    ]..shuffle();
  }
  
  @override
  Widget build(BuildContext context) {
    final currentSentence = widget.exampleSentence;

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
            ExampleSection(sentence: currentSentence),
            const SizedBox(height: AppConstants.defaultPadding),
            TranslationSection(
              sentence: currentSentence,
              showTranslation: _showTranslation,
              onToggleTranslation: _toggleTranslation,
            ),
            const SizedBox(height: AppConstants.largePadding),
            SentenceBuilder(
              selectedWords: _selectedWords,
              onWordRemoved: _handleWordRemoved,
            ),
            const SizedBox(height: AppConstants.largePadding),
            WordSelection(
              words: _allWords,
              selectedWords: _selectedWords,
              onWordSelected: _handleWordSelected,
              onWordRemoved: _handleWordRemoved,
            ),
            const SizedBox(height: AppConstants.largePadding),
            ActionButtons(
              showResult: _showResult,
              isEmptySelection: _selectedWords.isEmpty,
              onCheck: _checkAnswer,
              onNext: _goToNextExample,
            ),
            if (_showResult) ...[
              const SizedBox(height: AppConstants.defaultPadding),
              ResultSection(
                sentence: currentSentence,
                isCorrect: _isCorrect,
                onBackToList: () => Navigator.pop(context),
                onNextExample: _goToNextExample,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _toggleTranslation() {
    setState(() {
      _showTranslation = !_showTranslation;
    });
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

  /// 次の例文に移動する
  void _goToNextExample() {
    // 全ての例文を取得
    final allExamples = LessonData.getAllExampleSentences();
    
    // 現在の例文のインデックスを取得
    final currentIndex = allExamples.indexWhere((example) => example.id == widget.exampleSentence.id);
    
    // 次の例文のインデックスを計算（最後の例文の場合は最初に戻る）
    final nextIndex = (currentIndex + 1) % allExamples.length;
    
    // 次の例文に移動
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PracticeScreen(exampleSentence: allExamples[nextIndex]),
      ),
    );
  }
}
