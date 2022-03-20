import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/model/info_visualisation_state.dart';
import 'package:repiton/provider/teachers.dart';
import 'package:repiton/screens/controll_teacher_student_info.dart';
import 'package:repiton/widgets/calendar_widget.dart';
import 'package:repiton/widgets/date_chooser.dart';
import 'package:table_calendar/table_calendar.dart';

class ControllFinancinalStatisticsWidget extends StatefulWidget {
  final InfoVisualisationState state;

  const ControllFinancinalStatisticsWidget({
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  State<ControllFinancinalStatisticsWidget> createState() =>
      _ControllFinancinalStatisticsWidgetState();
}

class _ControllFinancinalStatisticsWidgetState
    extends State<ControllFinancinalStatisticsWidget> {
  late DateTime _fromDay;
  late DateTime _toDay;

  Future<void> _getStatistics(
    DateTime dateFrom,
    DateTime dateTo,
  ) async {
    await Provider.of<Teachers>(context, listen: false).fetchAndSetStatistics(
      dateFrom,
      dateTo,
    );
    if (widget.state == InfoVisualisationState.custom) {
      Provider.of<Teachers>(context, listen: false)
          .fecthAndSetStudentsInfoForAPeriod(
        dateFrom,
        dateTo,
      );
    } else {
      Provider.of<Teachers>(context, listen: false)
          .fecthAndSetStudentsInfoForADay(
        DateTime.now(),
      );
    }
  }

  void setDates(DateTime focusDate) {
    switch (widget.state) {
      case InfoVisualisationState.week:
        _fromDay = focusDate.subtract(Duration(days: focusDate.weekday - 1));
        _toDay = focusDate
            .add(Duration(days: DateTime.daysPerWeek - focusDate.weekday));
        break;
      case InfoVisualisationState.month:
      case InfoVisualisationState.custom:
        _fromDay = DateTime(focusDate.year, focusDate.month, 1);
        _toDay = DateTime(focusDate.year, focusDate.month + 1, 0);
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
                      lastDate: DateTime.now(),
                      callBack: (day) {
                        setState(() {
                          _fromDay = day ?? _fromDay;
                        });
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
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      callBack: (day) {
                        setState(() {
                          _toDay = day ?? _toDay;
                        });
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
                _fromDay,
                _toDay,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Consumer<Teachers>(
                    builder: (context, teachers, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Всего проведенных занятий",
                              style: TextStyle(fontSize: 22),
                            ),
                            Text(
                              teachers.statictics!.allLessons.toString(),
                              style: const TextStyle(
                                fontSize: 24,
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
                              "Итого к оплате",
                              style: TextStyle(fontSize: 22),
                            ),
                            Text(
                              teachers.statictics!.allPrice.toStringAsFixed(0) +
                                  " ₽",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 26,
                        ),
                        if (widget.state == InfoVisualisationState.week)
                          TeachersInfoCalendar(
                            provider: teachers,
                            format: CalendarFormat.week,
                            selectAction:
                                teachers.fecthAndSetStudentsInfoForADay,
                            pageChangeAction: (date) async {
                              setDates(date);

                              await teachers.fetchAndSetStatistics(
                                _fromDay,
                                _toDay,
                              );
                              switch (widget.state) {
                                case InfoVisualisationState.week:
                                case InfoVisualisationState.month:
                                  teachers.fecthAndSetStudentsInfoForADay(date);
                                  break;
                              }
                            },
                          ),
                        if (widget.state == InfoVisualisationState.month)
                          TeachersInfoCalendar(
                            provider: teachers,
                            format: CalendarFormat.month,
                            selectAction:
                                teachers.fecthAndSetStudentsInfoForADay,
                            pageChangeAction: (date) async {
                              setDates(date);

                              await teachers.fetchAndSetStatistics(
                                _fromDay,
                                _toDay,
                              );
                              switch (widget.state) {
                                case InfoVisualisationState.week:
                                case InfoVisualisationState.month:
                                  teachers.fecthAndSetStudentsInfoForADay(date);
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
                                  teachers.students[index].student.imageUrl,
                                ),
                              ),
                              title: Text(teachers
                                      .students[index].student.name +
                                  " " +
                                  teachers.students[index].student.lastName),
                              trailing: Text(
                                teachers.students[index].presents.toString(),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        ControllTeacherStudentInfo(
                                      studentStatistics:
                                          teachers.students[index],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: teachers.students.length,
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
