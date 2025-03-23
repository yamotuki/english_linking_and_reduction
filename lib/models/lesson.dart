/// レッスンの種類を表す列挙型
enum LessonType {
  elision, // tの脱落
  flapT, // tはdに
  linking, // リンキング
  reduction, // リダクション
}

/// レッスンモデル
class Lesson {
  final String id;
  final String title;
  final String description;
  final LessonType type;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
  });
}
