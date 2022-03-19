import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:repiton/provider/teachers.dart';
import 'package:repiton/screens/lesson_screen.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  return Consumer<Teachers>(
                    builder: (context, teachers, _) => Column(
                      children: [
                        TimeTableCalendar(
                          provider: teachers,
                          format: CalendarFormat.month,
                          selectAction: (date) {
                            teachers.fecthAndSetLessonsForADay(date);
                          },
                        ),
                        const Divider(),
                        //TODO: Make scrollable
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => ListTile(
                            //TODO: change data to models
                            title: Text(
                              "Дима Носов",
                              style: const TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            subtitle: Text(
                              "Информатика",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            trailing: Column(
                              children: [
                                Text(
                                  DateFormat("HH:mm").format(
                                    teachers.todayLessons[index].dateTimeStart,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  DateFormat("dd.MM").format(
                                    teachers.todayLessons[index].dateTimeStart,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LessonScreen(
                                    lesson: teachers.todayLessons[index],
                                  ),
                                ),
                              );
                            },
                          ),
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: teachers.todayLessons.length,
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getLessons(DateTime dateTime) async {
    await Provider.of<Teachers>(context, listen: false)
        .fetchAndSetLessons(dateTime);

    Provider.of<Teachers>(context, listen: false)
        .fecthAndSetLessonsForADay(dateTime);
  }
}
