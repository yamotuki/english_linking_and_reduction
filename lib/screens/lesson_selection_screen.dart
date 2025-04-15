import 'package:flutter/material.dart';
import '../models/example_sentence.dart';
import '../models/lesson_data.dart';
import '../utils/constants.dart';
import '../utils/local_storage.dart';
import 'practice_screen.dart';

/// レッスン選択画面
class LessonSelectionScreen extends StatefulWidget {
  const LessonSelectionScreen({super.key});

  @override
  State<LessonSelectionScreen> createState() => _LessonSelectionScreenState();
}

class _LessonSelectionScreenState extends State<LessonSelectionScreen> {
  List<ExampleSentence> _exampleSentences = [];
  Map<String, String> _answeredStatus = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // 例文データを取得
    final examples = LessonData.getAllExampleSentences();
    
    // 回答済み例文の状態を取得
    final answeredExamples = await LocalStorage.getAnsweredExamples();
    
    setState(() {
      _exampleSentences = examples;
      _answeredStatus = answeredExamples;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '例文を選択してください',
                    style: AppConstants.headlineStyle,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _exampleSentences.length,
                      itemBuilder: (context, index) {
                        final example = _exampleSentences[index];
                        return _buildExampleCard(context, example);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildExampleCard(BuildContext context, ExampleSentence example) {
    // 例文の最初の7文字を取得し、残りはぼかす
    final displayText = _getDisplayText(example.text);
    
    // 回答状態に基づいてアイコンを決定
    final isAnswered = _answeredStatus.containsKey(example.id);
    final isCorrect = isAnswered && _answeredStatus[example.id] == AnswerStatus.correct.toString();
    
    return Card(
      elevation: AppConstants.defaultElevation,
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PracticeScreen(exampleSentence: example),
            ),
          ).then((_) {
            // 画面に戻ってきたら、データを再読み込み
            _loadData();
          });
        },
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            children: [
              // ステータスアイコン
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isAnswered
                      ? (isCorrect ? Colors.green : Colors.red)
                      : AppConstants.disabledColor,
                ),
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              // 例文テキスト
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayText,
                      style: AppConstants.titleStyle,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      example.translation,
                      style: AppConstants.bodyStyle,
                    ),
                    // レベル表示
                    Text(
                      'レベル: ${example.level}',
                      style: AppConstants.captionStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDisplayText(String text) {
    if (text.length <= 7) {
      return text;
    }
    
    // 最初の7文字を取得し、残りはぼかす
    final visiblePart = text.substring(0, 7);
    final hiddenPart = '...' + '•' * (text.length - 7);
    return '$visiblePart$hiddenPart';
  }
}
