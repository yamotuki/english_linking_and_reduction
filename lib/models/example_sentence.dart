/// 例文モデル
class ExampleSentence {
  final String id;
  final String text;
  final String translation;
  final List<String> words;
  final List<String> distractors; // 紛らわしい選択肢
  final String audioPath;

  ExampleSentence({
    required this.id,
    required this.text,
    required this.translation,
    required this.words,
    required this.distractors,
    required this.audioPath,
  });
}
