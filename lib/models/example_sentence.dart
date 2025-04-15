/// 例文モデル
class ExampleSentence {
  final String id;
  final String text;
  final String translation;
  final List<String> distractors; // 紛らわしい選択肢
  final String audioPath;
  final String? pronunciationText; // 発音用テキスト（TTSに渡すための文章）
  final List<ExplanationItem>? explanations; // 解説項目のリスト
  final int level; // 難易度レベル（1が最も簡単、数字が大きいほど難しい）

  ExampleSentence({
    required this.id,
    required this.text,
    required this.translation,
    required this.distractors,
    required this.audioPath,
    this.pronunciationText,
    this.explanations,
    required this.level,
  });

  /// テキストから単語リストを生成
  List<String> get words {
    // 句読点を削除し、スペースで分割
    final cleanText = text.replaceAll(RegExp(r'[.,!?]'), '');
    return cleanText.split(' ');
  }
}

/// 解説項目モデル
class ExplanationItem {
  final String key; // 解説のキー（例: "coulda"）
  final String content; // 解説の内容

  ExplanationItem({
    required this.key,
    required this.content,
  });
}
