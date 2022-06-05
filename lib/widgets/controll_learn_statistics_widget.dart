import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/model/info_visualisation_state.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/admin/controll/student/controll_student_teacher_info.dart';
import 'package:repiton/widgets/calendar_widget.dart';
import 'package:repiton/widgets/date_chooser.dart';
import 'package:table_calendar/table_calendar.dart';

class ControllLearnStatisticsWidget extends StatefulWidget {
  final InfoVisualisationState state;

  const ControllLearnStatisticsWidget({
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  State<ControllLearnStatisticsWidget> createState() => _ControllFinancinalStatisticsWidgetState();
}

class _ControllFinancinalStatisticsWidgetState extends State<ControllLearnStatisticsWidget> {
  DateTime? _choosedFromDate;
  late DateTime _fromDate;
  late DateTime _toDate;

  Future<void> _getStatistics(DateTime fromDate, DateTime toDate) async {
    await RootProvider.getStudentsStatistics().fetchAndSetStatistics(fromDate, toDate);
    if (widget.state == InfoVisualisationState.custom) {
      RootProvider.getStudentsStatistics().fecthAndSetTeachersInfoForAPeriod(fromDate, toDate);
    } else {
      RootProvider.getStudentsStatistics().fecthAndSetTeachersInfoForADay(DateTime.now());
    }
  }

  void setDates(DateTime focusDate) {
    switch (widget.state) {
      case InfoVisualisationState.week:
        _fromDate = focusDate.subtract(Duration(days: focusDate.weekday - 1));
        _toDate = focusDate.add(Duration(days: DateTime.daysPerWeek - focusDate.weekday));
        break;
      case InfoVisualisationState.month:
        _fromDate = DateTime(focusDate.year, focusDate.month, 1);
        _toDate = DateTime(focusDate.year, focusDate.month + 1, 0);
        break;
      case InfoVisualisationState.custom:
        _fromDate = _choosedFromDate ?? DateTime(focusDate.year, focusDate.month, 1);
        _toDate = DateTime(focusDate.year, focusDate.month + 1, 0);
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    setDates(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.state == InfoVisualisationState.custom)
              Row(
                children: [
                  const Text("c"),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: DateChooser(
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().isBefore(_toDate) ? DateTime.now() : _toDate,
                      callBack: (day) {
                        setState(() {
                          _fromDate = day ?? _fromDate;
                          _choosedFromDate = day;
                        });
                        RootProvider.getStudentsStatistics().fecthAndSetTeachersInfoForAPeriod(
                          _fromDate,
                          _toDate,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Text("по"),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: DateChooser(
                      firstDate: _choosedFromDate == null || DateTime(2000).isAfter(_choosedFromDate!)
                          ? DateTime(2000)
                          : _choosedFromDate!,
                      lastDate: DateTime.now(),
                      callBack: (day) {
                        setState(() {
                          _toDate = day ?? _toDate;
                        });
                        RootProvider.getStudentsStatistics().fecthAndSetTeachersInfoForAPeriod(
                          _fromDate,
                          _toDate,
                        );
                      },
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: widget.state == InfoVisualisationState.custom ? 26 : 5,
            ),
            FutureBuilder(
              future: _getStatistics(
                _fromDate,
                _toDate,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Consumer(
                    builder: (context, ref, _) {
                      final studentsStatistics = ref.watch(RootProvider.getStudentsStatisticsProvider());

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Всего посещений",
                                style: TextStyle(fontSize: 20),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Text(
                                        studentsStatistics.statictics!.allPresents.toString() +
                                            "/" +
                                            studentsStatistics.statictics!.countAllLessons.toString(),
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: " (" +
                                          (studentsStatistics.statictics!.allPresents *
                                                  100 /
                                                  studentsStatistics.statictics!.countAllLessons)
                                              .toStringAsFixed(0) +
                                          "%)",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Всего выполненных ДЗ",
                                style: TextStyle(fontSize: 20),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Text(
                                        studentsStatistics.statictics!.allHomeTasks.toString() +
                                            "/" +
                                            studentsStatistics.statictics!.countAllLessons.toString(),
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: " (" +
                                          (studentsStatistics.statictics!.allHomeTasks *
                                                  100 /
                                                  studentsStatistics.statictics!.countAllLessons)
                                              .toStringAsFixed(0) +
                                          "%)",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 26,
                          ),
                          if (widget.state == InfoVisualisationState.week)
                            StudentsInfoCalendar(
                              format: CalendarFormat.week,
                              selectAction: studentsStatistics.fecthAndSetTeachersInfoForADay,
                              pageChangeAction: (date) async {
                                setDates(date);

                                await studentsStatistics.fetchAndSetStatistics(
                                  _fromDate,
                                  _toDate,
                                );
                                switch (widget.state) {
                                  case InfoVisualisationState.week:
                                  case InfoVisualisationState.month:
                                    studentsStatistics.fecthAndSetTeachersInfoForADay(date);
                                    break;
                                  case InfoVisualisationState.custom:
                                    break;
                                }
                              },
                            ),
                          if (widget.state == InfoVisualisationState.month)
                            StudentsInfoCalendar(
                              format: CalendarFormat.month,
                              selectAction: studentsStatistics.fecthAndSetTeachersInfoForADay,
                              pageChangeAction: (date) async {
                                setDates(date);

                                await studentsStatistics.fetchAndSetStatistics(
                                  _fromDate,
                                  _toDate,
                                );
                                switch (widget.state) {
                                  case InfoVisualisationState.week:
                                  case InfoVisualisationState.month:
                                    studentsStatistics.fecthAndSetTeachersInfoForADay(date);
                                    break;
                                  case InfoVisualisationState.custom:
                                    break;
                                }
                              },
                            ),
                          const SizedBox(
                            height: 37,
                          ),
                          const Text(
                            "Подробнее по дисциплинам",
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    studentsStatistics.showingDisciplines[index].discipline.teacher.imageUrl,
                                  ),
                                ),
                                title: Text(
                                  studentsStatistics.showingDisciplines[index].discipline.name,
                                ),
                                subtitle: Text(
                                  studentsStatistics.showingDisciplines[index].discipline.teacher.lastName +
                                      " " +
                                      studentsStatistics.showingDisciplines[index].discipline.teacher.name +
                                      " " +
                                      studentsStatistics.showingDisciplines[index].discipline.teacher.fatherName,
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => ControllStudentTeacherInfo(
                                        studentStatistics: studentsStatistics.showingDisciplines[index],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            separatorBuilder: (context, index) => const Divider(),
                            itemCount: studentsStatistics.showingDisciplines.length,
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
    );
  }
}
