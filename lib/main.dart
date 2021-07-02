import 'package:flutter/material.dart';
import 'package:quiz_app/screens/welcome/welcome_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Quiz App',
    theme: ThemeData.dark(),
    home: WelcomeScreen(),
  ));
}
