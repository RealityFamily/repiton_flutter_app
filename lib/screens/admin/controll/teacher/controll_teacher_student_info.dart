import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/statistics.dart';

class ControllTeacherStudentInfo extends StatelessWidget {
  final StudentFinancialStatistics studentStatistics;

  const ControllTeacherStudentInfo({
    required this.studentStatistics,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          const Text("Ведение", textAlign: TextAlign.center, style: TextStyle(fontSize: 34)),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(text: "Ученик ", style: TextStyle(fontSize: 18, color: Colors.grey)),
                                TextSpan(text: studentStatistics.student.fullName, style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.primary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Проведенных занятий", style: TextStyle(fontSize: 22)),
                          Text(studentStatistics.presents.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Итого к оплате", style: TextStyle(fontSize: 22)),
                          Text(studentStatistics.price.toStringAsFixed(0) + " ₽", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 42),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          List<Lesson> lessons = studentStatistics.lessons.reversed.toList();
                          Color background = Colors.transparent;
                          String trailing = "";

                          switch (lessons[index].status) {
                            case LessonStatus.done:
                            case LessonStatus.started:
                              background = const Color(0xFF9DCBAA);
                              trailing = "Проведено";
                              break;
                            case LessonStatus.canceledByStudent:
                              background = const Color(0xFFDE9898);
                              trailing = "Отменено учеником";
                              break;
                            case LessonStatus.canceledByTeacher:
                              background = const Color(0xFFDE9898);
                              trailing = "Отменено преподавателем";
                              break;
                            case LessonStatus.moved:
                              background = const Color(0xFFFFEE97);
                              trailing = "Перенесено";
                              break;
                            case LessonStatus.planned:
                              break;
                          }

                          return ListTile(
                            title: Text(DateFormat("dd.MM.yyyy").format(lessons[index].dateTimeStart), style: const TextStyle(fontSize: 18)),
                            trailing: Container(
                              constraints: const BoxConstraints(minWidth: 110),
                              padding: const EdgeInsets.all(10),
                              color: background,
                              child: Text(trailing, textAlign: TextAlign.center),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: studentStatistics.lessons.length,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
