import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:repiton/model/home_task.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/widgets/empty_hometask_widget.dart';
import 'package:repiton/widgets/lesson_info_widget.dart';
import 'package:repiton/widgets/rocket_chat_screen.dart';
import 'package:repiton/widgets/state_chooser.dart';
import 'package:repiton/widgets/task_info_widget.dart';
import 'package:repiton/widgets/test_info_widget.dart';

class LessonScreen extends StatefulWidget {
  final String disciplineName;
  final String studentName;
  final List<String> rocketChatRef;
  final String studentImageUrl;
  final String teacherImageUrl;

  const LessonScreen({
    required this.disciplineName,
    required this.studentName,
    required this.rocketChatRef,
    required this.studentImageUrl,
    required this.teacherImageUrl,
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
    return Scaffold(
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
                              Consumer(
                                builder: (context, ref, _) {
                                  final lessons = ref.watch(RootProvider.getLessonsProvider());
                                  return Text(
                                    lessons.lesson!.name,
                                    style: const TextStyle(
                                      fontSize: 34,
                                    ),
                                  );
                                },
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
                            RootProvider.getLessons().closeLesson();
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const Expanded(child: SizedBox()),
                        PopupMenuButton<String>(
                          padding: const EdgeInsets.all(16),
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (_) => ["Перенести занятие", "Отменить занятие"]
                              .map(
                                (item) => PopupMenuItem<String>(
                                  // TODO: Delete param when would created func
                                  enabled: false,
                                  value: item,
                                  child: Row(
                                    children: [
                                      Icon(item.contains("Перенести") ? Icons.move_down : Icons.dnd_forwardslash),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(item),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onSelected: (value) {},
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
                            Consumer(
                              builder: (context, ref, _) {
                                final lessons = ref.watch(RootProvider.getLessonsProvider());

                                return Row(
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
                                            text: DateFormat("HH:mm").format(lessons.lesson!.dateTimeStart),
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
                                              lessons.lesson!.dateTimeStart,
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
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                    (() {
                      if (_newState == _states[_states.length - 1]) {
                        return const RocketChatScreen();
                      } else if (_newState == _states[0]) {
                        return LessonInfoWidget(
                          disciplineName: widget.disciplineName,
                          studentName: widget.studentName,
                          teacherImageUrl: widget.teacherImageUrl,
                          studentImageUrl: widget.studentImageUrl,
                        );
                      } else {
                        return Consumer(
                          builder: (context, ref, _) {
                            final lessons = ref.watch(RootProvider.getLessonsProvider());

                            if (lessons.lesson!.homeTask == null) {
                              return const EmptyHometaskWidget();
                            } else {
                              switch (lessons.lesson!.homeTask!.type) {
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
    );
  }
}
