import 'example_sentence.dart';

/// レッスンデータを管理するクラス
class LessonData {
  // すべての例文リストを取得
  static List<ExampleSentence> getAllExampleSentences() {
    final examples = [
      // Tの脱落（Elision）の例文
      ExampleSentence(
        id: 'elision_1',
        text: "I can't believe it.",
        translation: '信じられない。',
        words: ['I', 'can\'t', 'believe', 'it'],
        distractors: ['don\'t', 'won\'t', 'am', 'can'],
        audioPath: 'audio/elision_1.mp3',
        pronunciationText: "I can' believe it.", // Tの脱落
        explanations: [
          ExplanationItem(
            key: "can't",
            content: "「can't」の「t」は次の単語が子音で始まる場合、脱落することがあります。「カン」と発音されます。",
          ),
        ],
        level: 1,
      ),
      ExampleSentence(
        id: 'elision_2',
        text: 'Don\'t forget to call me.',
        translation: '電話するのを忘れないで。',
        words: ['Don\'t', 'forget', 'to', 'call', 'me'],
        distractors: ['remember', 'try', 'want', 'need'],
        audioPath: 'audio/elision_2.mp3',
        pronunciationText: 'Don\' forget to call me.', // Tの脱落
        explanations: [
          ExplanationItem(
            key: "don't",
            content: "「don't」の「t」は次の単語が子音で始まる場合、脱落することがあります。「ドン」と発音されます。",
          ),
        ],
        level: 2,
      ),
      
      // Flap Tの例文
      ExampleSentence(
        id: 'flap_t_1',
        text: 'What a beautiful city.',
        translation: 'なんて美しい街なんだ。',
        words: ['What', 'a', 'beautiful', 'city'],
        distractors: ['nice', 'great', 'wonderful', 'amazing'],
        audioPath: 'audio/flap_t_1.mp3',
        pronunciationText: 'Whada beautiful city.', // Flap T
        explanations: [
          ExplanationItem(
            key: "what a",
            content: "「what a」の「t」は母音に挟まれると、「d」のような音になります。「ワダ」と発音されます。",
          ),
        ],
        level: 1,
      ),
      ExampleSentence(
        id: 'flap_t_2',
        text: 'I need to get a better computer.',
        translation: 'もっといいコンピュータが必要だ。',
        words: ['I', 'need', 'to', 'get', 'a', 'better', 'computer'],
        distractors: ['want', 'have', 'buy', 'use'],
        audioPath: 'audio/flap_t_2.mp3',
        pronunciationText: 'I need da geda bedder computer.', // Flap T
        explanations: [
          ExplanationItem(
            key: "need to",
            content: "「need to」の「t」は母音に挟まれると、「d」のような音になります。「ニーダ」と発音されます。",
          ),
          ExplanationItem(
            key: "get a",
            content: "「get a」の「t」は母音に挟まれると、「d」のような音になります。「ゲダ」と発音されます。",
          ),
          ExplanationItem(
            key: "better",
            content: "「better」の「t」は母音に挟まれると、「d」のような音になります。「ベダー」と発音されます。",
          ),
        ],
        level: 3,
      ),
      
      // リンキング（Linking）の例文
      ExampleSentence(
        id: 'linking_1',
        text: 'Turn it off.',
        translation: 'それを消して。',
        words: ['Turn', 'it', 'off'],
        distractors: ['on', 'up', 'down', 'over'],
        audioPath: 'audio/linking_1.mp3',
        pronunciationText: 'Tur-ni-toff.', // リンキング
        explanations: [
          ExplanationItem(
            key: "turn it",
            content: "「turn it」の「n」と「i」がつながって「ターニ」と発音されます。",
          ),
          ExplanationItem(
            key: "it off",
            content: "「it off」の「t」と「o」がつながって「トフ」と発音されます。",
          ),
        ],
        level: 1,
      ),
      ExampleSentence(
        id: 'linking_2',
        text: 'Come and see me.',
        translation: '来て会いに来て。',
        words: ['Come', 'and', 'see', 'me'],
        distractors: ['go', 'visit', 'meet', 'find'],
        audioPath: 'audio/linking_2.mp3',
        pronunciationText: 'Co-man-see-me.', // リンキング
        explanations: [
          ExplanationItem(
            key: "come and",
            content: "「come and」の「m」と「a」がつながって「カマン」と発音されます。",
          ),
          ExplanationItem(
            key: "and see",
            content: "「and see」の「d」と「s」がつながって「アンスィー」と発音されます。",
          ),
          ExplanationItem(
            key: "see me",
            content: "「see me」の「e」と「m」がつながって「スィーミー」と発音されます。",
          ),
        ],
        level: 2,
      ),
      
      // リダクション（Reduction）の例文
      ExampleSentence(
        id: 'reduction_1',
        text: 'What do you want to do?',
        translation: '何がしたいの？',
        words: ['What', 'do', 'you', 'want', 'to', 'do'],
        distractors: ['need', 'like', 'can', 'will'],
        audioPath: 'audio/reduction_1.mp3',
        pronunciationText: 'Whaddaya wanna do?', // リダクション
        explanations: [
          ExplanationItem(
            key: "what do you",
            content: "「what do you」は会話では「ワダヤ」と短縮されて発音されることがあります。",
          ),
          ExplanationItem(
            key: "want to",
            content: "「want to」は会話では「ワナ」と短縮されて発音されることがあります。",
          ),
        ],
        level: 2,
      ),
      ExampleSentence(
        id: 'reduction_2',
        text: 'I have to go now.',
        translation: '今行かなければならない。',
        words: ['I', 'have', 'to', 'go', 'now'],
        distractors: ['want', 'need', 'must', 'should'],
        audioPath: 'audio/reduction_2.mp3',
        pronunciationText: 'I hafta go now.', // リダクション
        explanations: [
          ExplanationItem(
            key: "have to",
            content: "「have to」は会話では「ハフタ」と短縮されて発音されることがあります。「v」が「f」に変わります。",
          ),
          ExplanationItem(
            key: "coulda",
            content: "✔ 「could have」は会話では「クダ」みたいに聞こえます。\n「have」の部分はほとんど聞こえず、全体で「クダ（/kʊɾə/）」と発音されます。",
          ),
        ],
        level: 1,
      ),
      // TODO: 追加の例文を必要に応じて追加
    ];
    
    // レベル順にソート（低い方が簡単、簡単なものが最初に来る）
    examples.sort((a, b) => a.level.compareTo(b.level));
    return examples;
  }
}
