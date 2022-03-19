import 'package:flutter/material.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/widgets/state_chooser.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  const LessonScreen({required this.lesson, Key? key}) : super(key: key);

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  LessonInfoState state = LessonInfoState.info;
  final List<String> _states = ["Информация", "Д/З", "Чат"];
  late String _newState;

  @override
  void initState() {
    super.initState();
    _newState = _states[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      //TODO: set lesson name
                      "Урок №1",
                      style: TextStyle(
                        fontSize: 34,
                      ),
                    )
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
                    // TODO: put student name
                    text: "Дима" + " " + "Носов",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  TextSpan(
                    // TODO: put student name
                    text: "\n" + "Информатика",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            StateChooser(
              items: _states,
              onStateChange: (newState) {
                setState(() {
                  _newState = newState;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

enum LessonInfoState {
  info,
  hw,
  chat,
}
