import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/lesson_data.dart';
import '../utils/constants.dart';
import 'practice_screen.dart';

/// レッスン選択画面
class LessonSelectionScreen extends StatelessWidget {
  const LessonSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = LessonData.getLessons();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'レッスンを選択してください',
              style: AppConstants.headlineStyle,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Expanded(
              child: ListView.builder(
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  return _buildLessonCard(context, lesson);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard(BuildContext context, Lesson lesson) {
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
              builder: (context) => PracticeScreen(lessonType: lesson.type),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.title,
                style: AppConstants.titleStyle,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                lesson.description,
                style: AppConstants.bodyStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
