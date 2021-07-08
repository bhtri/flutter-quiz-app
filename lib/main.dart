import 'package:flutter/material.dart';
import 'package:quiz_app/screens/quiz/quiz_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Quiz App',
    theme: ThemeData.dark(),
    home: QuizScreen(),
  ));
}
