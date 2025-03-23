import 'lesson.dart';
import 'example_sentence.dart';

/// レッスンデータを管理するクラス
class LessonData {
  // レッスンリストを取得
  static List<Lesson> getLessons() {
    return [
      Lesson(
        id: 'elision',
        title: 'Tの脱落（Elision）',
        description: '単語の最後のTが次の単語の子音の前で脱落する現象です。',
        type: LessonType.elision,
      ),
      Lesson(
        id: 'flap_t',
        title: 'Tはdに（Flap T）',
        description: '単語の中のTが母音に挟まれると、Dのような音になる現象です。',
        type: LessonType.flapT,
      ),
      Lesson(
        id: 'linking',
        title: 'リンキング（Linking）',
        description: '単語と単語がつながって発音される現象です。',
        type: LessonType.linking,
      ),
      Lesson(
        id: 'reduction',
        title: 'リダクション（Reduction）',
        description: '機能語（冠詞、前置詞、助動詞など）が弱く発音される現象です。',
        type: LessonType.reduction,
      ),
    ];
  }

  // レッスンタイプに基づいて例文リストを取得
  static List<ExampleSentence> getExampleSentences(LessonType type) {
    switch (type) {
      case LessonType.elision:
        return _getElisionExamples();
      case LessonType.flapT:
        return _getFlapTExamples();
      case LessonType.linking:
        return _getLinkingExamples();
      case LessonType.reduction:
        return _getReductionExamples();
    }
  }

  // Tの脱落の例文
  static List<ExampleSentence> _getElisionExamples() {
    return [
      ExampleSentence(
        id: 'elision_1',
        text: 'I can\'t believe it.',
        translation: '信じられない。',
        words: ['I', 'can\'t', 'believe', 'it'],
        distractors: ['don\'t', 'won\'t', 'am', 'can'],
        audioPath: 'assets/audio/elision_1.mp3',
      ),
      ExampleSentence(
        id: 'elision_2',
        text: 'Don\'t forget to call me.',
        translation: '電話するのを忘れないで。',
        words: ['Don\'t', 'forget', 'to', 'call', 'me'],
        distractors: ['remember', 'try', 'want', 'need'],
        audioPath: 'assets/audio/elision_2.mp3',
      ),
      // TODO: 追加の例文を6つ程度追加
    ];
  }

  // Flap Tの例文
  static List<ExampleSentence> _getFlapTExamples() {
    return [
      ExampleSentence(
        id: 'flap_t_1',
        text: 'What a beautiful city.',
        translation: 'なんて美しい街なんだ。',
        words: ['What', 'a', 'beautiful', 'city'],
        distractors: ['nice', 'great', 'wonderful', 'amazing'],
        audioPath: 'assets/audio/flap_t_1.mp3',
      ),
      ExampleSentence(
        id: 'flap_t_2',
        text: 'I need to get a better computer.',
        translation: 'もっといいコンピュータが必要だ。',
        words: ['I', 'need', 'to', 'get', 'a', 'better', 'computer'],
        distractors: ['want', 'have', 'buy', 'use'],
        audioPath: 'assets/audio/flap_t_2.mp3',
      ),
      // TODO: 追加の例文を6つ程度追加
    ];
  }

  // リンキングの例文
  static List<ExampleSentence> _getLinkingExamples() {
    return [
      ExampleSentence(
        id: 'linking_1',
        text: 'Turn it off.',
        translation: 'それを消して。',
        words: ['Turn', 'it', 'off'],
        distractors: ['on', 'up', 'down', 'over'],
        audioPath: 'assets/audio/linking_1.mp3',
      ),
      ExampleSentence(
        id: 'linking_2',
        text: 'Come and see me.',
        translation: '来て会いに来て。',
        words: ['Come', 'and', 'see', 'me'],
        distractors: ['go', 'visit', 'meet', 'find'],
        audioPath: 'assets/audio/linking_2.mp3',
      ),
      // TODO: 追加の例文を6つ程度追加
    ];
  }

  // リダクションの例文
  static List<ExampleSentence> _getReductionExamples() {
    return [
      ExampleSentence(
        id: 'reduction_1',
        text: 'What do you want to do?',
        translation: '何がしたいの？',
        words: ['What', 'do', 'you', 'want', 'to', 'do'],
        distractors: ['need', 'like', 'can', 'will'],
        audioPath: 'assets/audio/reduction_1.mp3',
      ),
      ExampleSentence(
        id: 'reduction_2',
        text: 'I have to go now.',
        translation: '今行かなければならない。',
        words: ['I', 'have', 'to', 'go', 'now'],
        distractors: ['want', 'need', 'must', 'should'],
        audioPath: 'assets/audio/reduction_2.mp3',
      ),
      // TODO: 追加の例文を6つ程度追加
    ];
  }
}
