import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:repiton/model/home_task.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/provider/lessons.dart';
import 'package:repiton/widgets/empty_hometask_widget.dart';
import 'package:repiton/widgets/lesson_info_widget.dart';
import 'package:repiton/widgets/rocket_chat_screen.dart';
import 'package:repiton/widgets/state_chooser.dart';
import 'package:repiton/widgets/task_info_widget.dart';

import '../../widgets/test_info_widget.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  final String disciplineName;
  final String studentName;
  final String rocketChatRef;
  const LessonScreen({
    required this.lesson,
    required this.disciplineName,
    required this.studentName,
    required this.rocketChatRef,
    Key? key,
  }) : super(key: key);

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final List<String> _states = ["Информация", "Д/З", "Чат"];
  late String _newState;

  @override
  void initState() {
    super.initState();
    _newState = _states[0];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Lessons(widget.lesson),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Column(
                        children: [
                          if (_newState != _states[_states.length - 1]) ...{
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Consumer<Lessons>(
                                  builder: (context, lessons, _) => Text(
                                    lessons.lesson.name,
                                    style: const TextStyle(
                                      fontSize: 34,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          },
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Ученик ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.studentName,
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                TextSpan(
                                  text: "\n" + widget.disciplineName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            padding: const EdgeInsets.all(16),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                          const Expanded(child: SizedBox()),
                          IconButton(
                            padding: const EdgeInsets.all(16),
                            onPressed: () {},
                            icon: const Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            StateChooser(
                              items: _states,
                              onStateChange: (newState) {
                                setState(() {
                                  _newState = newState;
                                });
                              },
                            ),
                            if (_newState != _states[_states.length - 1])
                              Consumer<Lessons>(
                                builder: (context, lessons, _) => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: "Время ",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                            ),
                                          ),
                                          TextSpan(
                                            text: DateFormat("HH:mm").format(lessons.lesson.dateTimeStart),
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: "Дата ",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                            ),
                                          ),
                                          TextSpan(
                                            text: DateFormat(
                                              "dd.MM.yyyy",
                                            ).format(
                                              lessons.lesson.dateTimeStart,
                                            ),
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      (() {
                        if (_newState == _states[_states.length - 1]) {
                          return RocketChatScreen();
                        } else if (_newState == _states[0]) {
                          return const LessonInfoWidget();
                        } else {
                          return Consumer<Lessons>(
                            builder: (context, lessons, _) {
                              if (lessons.lesson.homeTask == null) {
                                return const EmptyHometaskWidget();
                              } else {
                                switch (lessons.lesson.homeTask!.type) {
                                  case HomeTaskType.test:
                                    return const TestInfoWidget();
                                  case HomeTaskType.task:
                                    return const TaskInfoWidget();
                                }
                              }
                            },
                          );
                        }
                      }()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
