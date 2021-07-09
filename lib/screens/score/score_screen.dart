import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:websafe_svg/websafe_svg.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuestionController _qnController = Get.put(QuestionController());

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          WebsafeSvg.asset(
            'assets/icons/bg.svg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Column(
            children: [
              Spacer(flex: 3),
              Text(
                'Score',
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: kSecondaryColor),
              ),
              Spacer(),
              Text(
                '${_qnController.correctAns * 10}/${_qnController.questions.length * 10}',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: kSecondaryColor),
              ),
              InkWell(
                onTap: _qnController.restart,
                child: Container(
                  margin: EdgeInsets.only(top: kDefaultPadding),
                  padding: EdgeInsets.symmetric(
                    horizontal: kDefaultPadding * 2,
                    vertical: kDefaultPadding / 2,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Restart',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: kGrayColor),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  exit(0);
                },
                child: Container(
                  margin: EdgeInsets.only(top: kDefaultPadding),
                  padding: EdgeInsets.symmetric(
                    horizontal: kDefaultPadding * 2,
                    vertical: kDefaultPadding / 2,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Exit',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: kGrayColor),
                  ),
                ),
              ),
              Spacer(flex: 3),
            ],
          ),
        ],
      ),
    );
  }
}
