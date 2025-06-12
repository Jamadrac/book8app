import 'package:flutter/material.dart';
import 'base_subject_screen.dart';

class HowQuestionsScreen extends StatelessWidget {
  static const routeName = '/how-questions';
  final Color backgroundColor;

  const HowQuestionsScreen({
    super.key,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return BaseSubjectScreen(
      title: 'How Questions',
      backgroundColor: backgroundColor,
      category: 'how_questions',
    );
  }
}
