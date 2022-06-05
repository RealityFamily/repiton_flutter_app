import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/teacher/lesson_screen.dart';
import 'package:repiton/widgets/calendar_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({Key? key}) : super(key: key);

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Расписание",
                style: TextStyle(
                  fontSize: 34,
                ),
              ),
              const SizedBox(
                height: 23,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  labelText: "Поиск",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.cancel_outlined,
                    ),
                    onPressed: () {
                      debugPrint("Cancel search");
                    },
                  ),
                ),
              ),
              FutureBuilder(
                future: _getLessons(DateTime.now()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Consumer(
                      builder: (context, ref, _) {
                        final teachersLessons = ref.watch(RootProvider.getTeachersLessonsProvider());

                        return Column(
                          children: [
                            TimeTableCalendar(
                              format: CalendarFormat.month,
                              selectAction: teachersLessons.fecthAndSetLessonsForADay,
                              pageChangeAction: teachersLessons.fetchAndSetLessons,
                            ),
                            const Divider(),
                            Column(
                              children: [
                                ...(() {
                                  List<Widget> result = [];
                                  for (var discipline in teachersLessons.todayLessons) {
                                    for (var lesson in discipline.lessons) {
                                      result.add(
                                        ListTile(
                                          title: Text(
                                            discipline.student.fullName,
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                          subtitle: Text(
                                            discipline.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          trailing: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 2.5,
                                              horizontal: 5,
                                            ),
                                            color: (() {
                                              switch (lesson.status) {
                                                case LessonStatus.done:
                                                  return const Color(0xFF9DCBAA);
                                                case LessonStatus.canceled:
                                                  return const Color(0xFFDE9898);
                                                case LessonStatus.moved:
                                                  return const Color(0xFFFFEE97);
                                                case LessonStatus.planned:
                                                  return Colors.transparent;
                                                default:
                                                  return null;
                                              }
                                            }()),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  DateFormat("HH:mm").format(
                                                    lesson.dateTimeStart,
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  DateFormat("dd.MM").format(
                                                    lesson.dateTimeStart,
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            RootProvider.getLessons().openLesson(lesson);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => LessonScreen(
                                                  disciplineName: discipline.name,
                                                  studentName: discipline.student.fullName,
                                                  rocketChatRef: discipline.rocketChatReference,
                                                  teacherImageUrl: discipline.teacher.imageUrl,
                                                  studentImageUrl: discipline.student.imageUrl,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                      result.add(
                                        const Divider(),
                                      );
                                    }
                                  }
                                  return result;
                                }()),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getLessons(DateTime dateTime) async {
    await RootProvider.getTeachersLessons().fetchAndSetLessons(dateTime);

    RootProvider.getTeachersLessons().fecthAndSetLessonsForADay(dateTime);
  }
}
