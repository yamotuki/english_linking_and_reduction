import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 回答状態の列挙型
enum AnswerStatus {
  correct,
  incorrect,
}

/// ローカルストレージを使用してデータを保存・取得するためのユーティリティクラス
class LocalStorage {
  // キー定数
  static const String _answeredExamplesKey = 'answered_examples';

  /// 回答済み例文の状態を保存
  /// Map<String, String> 形式で、キーが例文ID、値が回答状態（"correct" または "incorrect"）
  static Future<bool> saveAnsweredExamples(Map<String, String> exampleStatuses) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(exampleStatuses);
    return prefs.setString(_answeredExamplesKey, jsonString);
  }

  /// 回答済み例文の状態を取得
  static Future<Map<String, String>> getAnsweredExamples() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_answeredExamplesKey);
    if (jsonString == null) {
      return {};
    }
    
    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      return {};
    }
  }

  /// 例文が回答済みかどうかを確認
  static Future<bool> isExampleAnswered(String exampleId) async {
    final answeredExamples = await getAnsweredExamples();
    return answeredExamples.containsKey(exampleId);
  }

  /// 例文の回答状態を取得
  /// 回答していない場合はnullを返す
  static Future<String?> getExampleAnswerStatus(String exampleId) async {
    final answeredExamples = await getAnsweredExamples();
    return answeredExamples[exampleId];
  }

  /// 例文が正解済みかどうかを確認
  static Future<bool> isExampleCorrectlyAnswered(String exampleId) async {
    final status = await getExampleAnswerStatus(exampleId);
    return status == AnswerStatus.correct.toString();
  }

  /// 例文を正解としてマーク
  static Future<bool> markExampleAsCorrectlyAnswered(String exampleId) async {
    final answeredExamples = await getAnsweredExamples();
    answeredExamples[exampleId] = AnswerStatus.correct.toString();
    return saveAnsweredExamples(answeredExamples);
  }

  /// 例文を不正解としてマーク
  static Future<bool> markExampleAsIncorrectlyAnswered(String exampleId) async {
    final answeredExamples = await getAnsweredExamples();
    answeredExamples[exampleId] = AnswerStatus.incorrect.toString();
    return saveAnsweredExamples(answeredExamples);
  }

  /// 例文の回答状態をリセット
  static Future<bool> resetExampleAnswerStatus(String exampleId) async {
    final answeredExamples = await getAnsweredExamples();
    answeredExamples.remove(exampleId);
    return saveAnsweredExamples(answeredExamples);
  }

  /// すべての例文の回答状態をリセット
  static Future<bool> resetAllAnswerStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(_answeredExamplesKey);
  }
}
