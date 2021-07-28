import 'package:dio/dio.dart' as request;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/models/Questions.dart';
import 'package:quiz_app/screens/quiz/quiz_screen.dart';
import 'package:websafe_svg/websafe_svg.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final List<String> _categories = [
    'Any Category',
    'General Knowledge',
    'Entertainment: Books',
    'Entertainment: Film',
    'Entertainment: Music',
    'Entertainment: Musicals & Theatres',
    'Entertainment: Television',
    'Entertainment: Video Games',
    'Entertainment: Board Games',
    'Science & Nature',
    'Science: Computers',
    'Science: Mathematics',
    'Mythology',
    'Sports',
    'Geography',
    'History',
    'Politics',
    'Art',
    'Celebrities',
    'Animals',
    'Vehicles',
    'Entertainment: Comics',
    'Science: Gadgets',
    'Entertainment: Japanese Anime & Manga',
    'Entertainment: Cartoon & Animations',
  ];
  String _selectedCategory = 'Any Category';

  final List<String> _difficulties = [
    'Any Difficulty',
    'Easy',
    'Medium',
    'Hard',
  ];
  String _selectedDifficulty = 'Any Difficulty';

  final _txtNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _txtNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                children: [
                  Spacer(flex: 2),
                  Row(
                    children: [
                      Text(
                        'Number of Question:  ',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _txtNumber,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFF1C2341),
                            hintText: 'Enter number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.numberWithOptions(),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        itemHeight: 80,
                        iconSize: 0,
                        icon: const Icon(Icons.arrow_downward),
                        value: _selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                        underline:
                            Container(height: 5, color: Color(0xFF1C2341)),
                        items:
                            _categories.map<DropdownMenuItem<String>>((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Container(
                              child: Text(
                                item,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                    ),
                              ),
                              width: 300,
                            ),
                          );
                        }).toList(),
                      ),
                      Icon(Icons.arrow_downward, size: 30),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                        itemHeight: 80,
                        iconSize: 0,
                        icon: const Icon(Icons.arrow_downward),
                        value: _selectedDifficulty,
                        onChanged: (value) {
                          setState(() {
                            _selectedDifficulty = value!;
                          });
                        },
                        underline:
                            Container(height: 5, color: Color(0xFF1C2341)),
                        items:
                            _difficulties.map<DropdownMenuItem<String>>((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Container(
                              child: Text(
                                item,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                    ),
                              ),
                              width: 300,
                            ),
                          );
                        }).toList(),
                      ),
                      Icon(Icons.arrow_downward, size: 30),
                    ],
                  ),
                  Spacer(flex: 1),
                  InkWell(
                    onTap: () async {
                      int number = int.tryParse(_txtNumber.text) ?? 3;
                      int idxCategory = _categories.indexOf(_selectedCategory);
                      int idxEasy = _difficulties.indexOf(_selectedDifficulty);

                      String url = 'https://opentdb.com/api.php?amount=$number';

                      if (idxCategory > 0) {
                        url += '&category=${idxCategory + 8}';
                      }

                      if (idxEasy > 0) {
                        url +=
                            '&difficulty=${_selectedDifficulty.toLowerCase()}';
                      }

                      print(url);

                      try {
                        request.Response response =
                            await request.Dio().get(url);
                        if (response.statusCode == 200) {
                          sampleData.clear();

                          List<dynamic> json = response.data['results'] ?? {};
                          json.forEach((element) {
                            List<String> questions = [
                              element['correct_answer']
                            ];

                            List<dynamic> tmp = element['incorrect_answers'];
                            tmp.forEach((value) {
                              questions.add(value);
                            });

                            sampleData.add({
                              "id": json.indexOf(element) + 1,
                              "question": element['question'],
                              "options": questions,
                              "answer_index": 1,
                            });
                          });

                          Get.to(() => QuizScreen());
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(kDefaultPadding * 0.75),
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Lets Start Quiz',
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
