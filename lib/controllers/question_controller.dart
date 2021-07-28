import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:quiz_app/models/Questions.dart';
import 'package:quiz_app/screens/quiz/quiz_screen.dart';
import 'package:quiz_app/screens/score/score_screen.dart';

class QuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  // Lets animated our progress bar
  late AnimationController _animationController;
  late Animation _animation;

  // so that we can access our animation outside
  Animation get animation => this._animation;

  late PageController _pageController;
  PageController get pageController => this._pageController;

  List<Question> _questions = sampleData
      .map(
        (question) => Question(
            id: question['id'],
            question: question['question'],
            answer: question['answer_index'],
            options: question['options']),
      )
      .toList();
  List<Question> get questions => this._questions;

  bool _isAnswered = false;
  bool get isAnswered => this._isAnswered;

  int _correctAns = 0;
  int get correctAns => this._correctAns;

  late int _selectedAns;
  int get selectedAns => this._selectedAns;

  RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => this._questionNumber;

  late int _numOfCorrectAns = 0;
  int get numOfCorrectAns => this._numOfCorrectAns;

  @override
  void onInit() {
    // Our animation duration is 60s
    // so our plan is to fill the progress bar within 60s
    _animationController = AnimationController(
      duration: Duration(seconds: 60),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        // update like setState
        update();
      });

    // start our animation
    // Once 60s is completed go to the next qn
    _animationController.forward().whenComplete(nextQuestion);
    _pageController = PageController();
    super.onInit();
  }

  // called just before the Controller is deleted from memory
  @override
  void onClose() {
    _animationController.dispose();
    _pageController.dispose();
    super.onClose();
  }

  void checkAns(Question question, int selectedIndex) {
    // because once user press any option then it will run
    _isAnswered = true;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) _numOfCorrectAns++;

    // it will stop the counter
    _animationController.stop();
    update();

    // Once user select an ans after 3s it will go to the next qn
    Future.delayed(Duration(seconds: 1), nextQuestion);
  }

  void nextQuestion() {
    if (_questionNumber.value != _questions.length) {
      _isAnswered = false;
      _pageController.nextPage(
          duration: Duration(milliseconds: 250), curve: Curves.ease);

      // Reset the counter
      _animationController.reset();

      // Then start it again
      // Once timer is finish go to the next qn
      _animationController.forward().whenComplete(nextQuestion);
    } else {
      // Get package provide us simple way to navigate another page
      Get.to(() => ScoreScreen());
    }
  }

  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
  }

  void restart() {
    _isAnswered = false;
    _correctAns = 0;
    _numOfCorrectAns = 0;
    _questionNumber = 1.obs;
    _pageController = PageController();

    _animationController.reset();
    _animationController.forward().whenComplete(nextQuestion);
    Get.to(() => QuizScreen());
  }
}
