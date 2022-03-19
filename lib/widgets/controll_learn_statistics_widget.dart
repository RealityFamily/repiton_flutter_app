import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/model/info_visualisation_state.dart';
import 'package:repiton/provider/students.dart';
import 'package:repiton/screens/controll_student_teacher_info.dart';
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
  State<ControllLearnStatisticsWidget> createState() =>
      _ControllFinancinalStatisticsWidgetState();
}

class _ControllFinancinalStatisticsWidgetState
    extends State<ControllLearnStatisticsWidget> {
  DateTime? _choosedFromDate;
  late DateTime _fromDate;
  late DateTime _toDate;

  Future<void> _getStatistics(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    await Provider.of<Students>(context, listen: false).fetchAndSetStatistics(
      fromDate,
      toDate,
    );
    if (widget.state == InfoVisualisationState.custom) {
      Provider.of<Students>(context, listen: false)
          .fecthAndSetTeachersInfoForAPeriod(
        fromDate,
        toDate,
      );
    } else {
      Provider.of<Students>(context, listen: false)
          .fecthAndSetTeachersInfoForADay(
        DateTime.now(),
      );
    }
  }

  void setDates(DateTime focusDate) {
    switch (widget.state) {
      case InfoVisualisationState.week:
        _fromDate = focusDate.subtract(Duration(days: focusDate.weekday - 1));
        _toDate = focusDate
            .add(Duration(days: DateTime.daysPerWeek - focusDate.weekday));
        break;
      case InfoVisualisationState.month:
        _fromDate = DateTime(focusDate.year, focusDate.month, 1);
        _toDate = DateTime(focusDate.year, focusDate.month + 1, 0);
        break;
      case InfoVisualisationState.custom:
        _fromDate =
            _choosedFromDate ?? DateTime(focusDate.year, focusDate.month, 1);
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
                      lastDate: DateTime.now().isBefore(_toDate)
                          ? DateTime.now()
                          : _toDate,
                      callBack: (day) {
                        setState(() {
                          _fromDate = day ?? _fromDate;
                          _choosedFromDate = day;
                        });
                        Provider.of<Students>(context, listen: false)
                            .fecthAndSetTeachersInfoForAPeriod(
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
                      firstDate: _choosedFromDate == null ||
                              DateTime(2000).isAfter(_choosedFromDate!)
                          ? DateTime(2000)
                          : _choosedFromDate!,
                      lastDate: DateTime.now(),
                      callBack: (day) {
                        setState(() {
                          _toDate = day ?? _toDate;
                        });
                        Provider.of<Students>(context, listen: false)
                            .fecthAndSetTeachersInfoForAPeriod(
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
                  return Consumer<Students>(
                    builder: (context, students, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Всего посещений",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              students.statictics!.allPresents.toString() +
                                  "/" +
                                  students.statictics!.countAllLessons
                                      .toString() +
                                  " (" +
                                  (students.statictics!.allPresents *
                                          100 /
                                          students.statictics!.countAllLessons)
                                      .toStringAsFixed(0) +
                                  "%)",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
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
                            Text(
                              students.statictics!.allHomeTasks.toString() +
                                  "/" +
                                  students.statictics!.countAllLessons
                                      .toString() +
                                  " (" +
                                  (students.statictics!.allPresents *
                                          100 /
                                          students.statictics!.countAllLessons)
                                      .toStringAsFixed(0) +
                                  "%)",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 26,
                        ),
                        if (widget.state == InfoVisualisationState.week)
                          StudentsInfoCalendar(
                            provider: students,
                            format: CalendarFormat.week,
                            selectAction:
                                students.fecthAndSetTeachersInfoForADay,
                            pageChangeAction: (date) async {
                              setDates(date);

                              await students.fetchAndSetStatistics(
                                _fromDate,
                                _toDate,
                              );
                              switch (widget.state) {
                                case InfoVisualisationState.week:
                                case InfoVisualisationState.month:
                                  students.fecthAndSetTeachersInfoForADay(date);
                                  break;
                              }
                            },
                          ),
                        if (widget.state == InfoVisualisationState.month)
                          StudentsInfoCalendar(
                            provider: students,
                            format: CalendarFormat.month,
                            selectAction:
                                students.fecthAndSetTeachersInfoForADay,
                            pageChangeAction: (date) async {
                              setDates(date);

                              await students.fetchAndSetStatistics(
                                _fromDate,
                                _toDate,
                              );
                              switch (widget.state) {
                                case InfoVisualisationState.week:
                                case InfoVisualisationState.month:
                                  students.fecthAndSetTeachersInfoForADay(date);
                                  break;
                              }
                            },
                          ),
                        const SizedBox(
                          height: 37,
                        ),
                        const Text(
                          "Подробнее по ученикам",
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
                                  students.disciplines[index].teacherImageUrl,
                                ),
                              ),
                              title: Text(
                                students.disciplines[index].disciplineName,
                              ),
                              subtitle: Text(
                                students.disciplines[index].teacherLastName +
                                    " " +
                                    students.disciplines[index].teacherName +
                                    " " +
                                    students
                                        .disciplines[index].teacherFatherName,
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        ControllStudentTeacherInfo(
                                      studentStatistics: students
                                          .statictics!.disciplines[index],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: students.disciplines.length,
                        ),
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
}
