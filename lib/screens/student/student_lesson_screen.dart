import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:repiton/model/home_task.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/lesson_action.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/widgets/empty_hometask_widget.dart';
import 'package:repiton/widgets/lesson_info_widget.dart';
import 'package:repiton/widgets/rocket_chat_screen.dart';
import 'package:repiton/widgets/state_chooser.dart';
import 'package:repiton/widgets/task_info_widget.dart';
import 'package:repiton/widgets/test_info_widget.dart';

class StudentLessonScreen extends StatefulWidget {
  final String disciplineName;
  final String teacherName;

  const StudentLessonScreen({
    required this.disciplineName,
    required this.teacherName,
    Key? key,
  }) : super(key: key);

  @override
  State<StudentLessonScreen> createState() => _StudentLessonScreenState();
}

class _StudentLessonScreenState extends State<StudentLessonScreen> {
  final List<String> _states = ["Информация", "Д/З", "Чат"];
  late String _newState;

  @override
  void initState() {
    super.initState();
    _newState = _states[0];
  }

  Widget get _lessonHeader => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48.0),
        child: Column(children: [_lessonHeaderTitle, const SizedBox(height: 10), _lessonHeaderSubTitle]),
      );

  Widget get _lessonHeaderTitle => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final lessons = ref.watch(RootProvider.getLessonsProvider());
                return Text(lessons.lesson!.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 34));
              },
            ),
          )
        ],
      );

  Widget get _lessonHeaderSubTitle => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            const TextSpan(text: "Преподаватель ", style: TextStyle(fontSize: 18, color: Colors.grey)),
            TextSpan(text: widget.teacherName, style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.primary)),
            TextSpan(text: "\n" + widget.disciplineName, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      );

  Widget get _lessonHeaderAction => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_lessonHeaderActionBackButton, _lessonHeaderActionMenuButton],
      );

  Widget get _lessonHeaderActionBackButton => IconButton(
        padding: const EdgeInsets.all(16),
        onPressed: () {
          RootProvider.getLessons().closeLesson();
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back),
      );

  List<LessonAction> get _lessonActions {
    List<LessonAction> result = [];

    if (RootProvider.getLessons().lessonStatus != null) {
      if (RootProvider.getLessons().lessonStatus == LessonStatus.planned && RootProvider.getLessons().isActiveLessonBefore(const Duration(days: 1))) {
        result.add(MoveLessonAction());
        result.add(CancelLessonAction());
      }
    }

    return result;
  }

  Widget get _lessonHeaderActionMenuButton => PopupMenuButton<LessonAction>(
        padding: const EdgeInsets.all(16),
        icon: const Icon(Icons.more_vert),
        itemBuilder: (_) => _lessonActions
            .map(
              (item) => PopupMenuItem<LessonAction>(
                // TODO: Delete param when would created func
                enabled: item.isActive ?? true,
                value: item,
                child: Row(
                  children: [Icon(item.icon), const SizedBox(width: 5), Text(item.title)],
                ),
              ),
            )
            .toList(),
        onSelected: (value) => value.action(),
      );

  Widget get _mainLessonInfo => Consumer(
        builder: (context, ref, _) {
          final lessons = ref.watch(RootProvider.getLessonsProvider());

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(text: "Время ", style: TextStyle(color: Colors.grey, fontSize: 18)),
                    TextSpan(
                      text: DateFormat("HH:mm").format(lessons.lesson!.dateTimeStart),
                      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 18),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(text: "Дата ", style: TextStyle(color: Colors.grey, fontSize: 18)),
                    TextSpan(
                      text: DateFormat("dd.MM.yyyy").format(lessons.lesson!.dateTimeStart),
                      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );

  Widget get _choosedInfoStateContent {
    if (_newState == _states[_states.length - 1]) {
      return const RocketChatScreen();
    } else if (_newState == _states[0]) {
      return const LessonInfoWidget();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: RefreshIndicator(
            onRefresh: RootProvider.getLessons().updateLessonInfo,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [_lessonHeader, _lessonHeaderAction],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  StateChooser(items: _states, onStateChange: (newState) => setState(() => _newState = newState)),
                                  if (_newState != _states[_states.length - 1]) _mainLessonInfo
                                ],
                              ),
                            ),
                            Expanded(child: _choosedInfoStateContent),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
