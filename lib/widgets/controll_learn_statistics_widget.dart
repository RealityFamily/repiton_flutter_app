import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/model/info_visualisation_state.dart';
import 'package:repiton/model/statistics.dart';
import 'package:repiton/provider/admin/students_statistics.dart';
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
  late DateTime _fromDay;
  late DateTime _toDay;

  Future<void> _getStatistics(DateTime fromDate, DateTime toDate) async {
    await RootProvider.getStudentsStatistics().fetchAndSetStatistics(fromDate, toDate);
    if (widget.state == InfoVisualisationState.custom) {
      RootProvider.getStudentsStatistics().fecthAndSetTeachersInfoForAPeriod(fromDate, toDate);
    } else {
      RootProvider.getStudentsStatistics().fecthAndSetTeachersInfoForADay(DateTime.now());
    }
  }

  void _setDates(DateTime focusDate) {
    switch (widget.state) {
      case InfoVisualisationState.week:
        _fromDay = focusDate.subtract(Duration(days: focusDate.weekday - 1));
        _toDay = focusDate.add(Duration(days: DateTime.daysPerWeek - focusDate.weekday));
        break;
      case InfoVisualisationState.month:
      case InfoVisualisationState.custom:
        _fromDay = DateTime(focusDate.year, focusDate.month, 1);
        _toDay = DateTime(focusDate.year, focusDate.month + 1, 0);
        break;
    }
  }

  Widget get _customDateSelector => Column(
        children: [
          Row(
            children: [
              const Text("c"),
              const SizedBox(width: 5),
              Expanded(child: DateChooser(firstDate: DateTime(2000), lastDate: _toDay, callBack: (day) => setState(() => _fromDay = day ?? _fromDay))),
              const SizedBox(width: 16),
              const Text("по"),
              const SizedBox(width: 5),
              Expanded(child: DateChooser(firstDate: _fromDay, lastDate: DateTime.now(), callBack: (day) => setState(() => _toDay = day ?? _toDay))),
            ],
          ),
          const SizedBox(height: 21)
        ],
      );

  Widget _statisticsCount(int countingValue, int countAllLessons) => RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Text(
                "${countingValue.toString()}/${countAllLessons.toString()}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
              ),
            ),
            TextSpan(
              text: " (${(countingValue * 100 / countAllLessons).toStringAsFixed(0)}%)",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black45),
            ),
          ],
        ),
      );

  Widget _calendar(StudentsStatisticsProvider studentsStatistics, InfoVisualisationState state) {
    CalendarFormat formOfCalendarVisualisation = CalendarFormat.week;

    switch (state) {
      case InfoVisualisationState.week:
        formOfCalendarVisualisation = CalendarFormat.week;
        break;
      case InfoVisualisationState.month:
        formOfCalendarVisualisation = CalendarFormat.month;
        break;
      case InfoVisualisationState.custom:
        return Container();
    }

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: StudentsInfoCalendar(
        format: formOfCalendarVisualisation,
        selectAction: studentsStatistics.fecthAndSetTeachersInfoForADay,
        pageChangeAction: (date) async {
          _setDates(date);

          await studentsStatistics.fetchAndSetStatistics(
            _fromDay,
            _toDay,
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
    );
  }

  ImageProvider _teacherImage(String? imageUrl) {
    if (imageUrl != null) {
      return NetworkImage(imageUrl);
    } else {
      return const AssetImage("assets/images/user_black.png");
    }
  }

  Widget _disciplinesList(List<DisciplineLearnStatistics> disciplines) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Подробнее по дисциплинам", style: TextStyle(fontSize: 24)),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(backgroundImage: _teacherImage(disciplines[index].discipline.teacher?.imageUrl)),
                title: Text(disciplines[index].discipline.name),
                subtitle: Text(disciplines[index].discipline.teacher?.fullName ?? ""),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => ControllStudentTeacherInfo(studentStatistics: disciplines[index])),
                  );
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: disciplines.length,
          ),
        ],
      );

  @override
  void initState() {
    super.initState();

    _setDates(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.state == InfoVisualisationState.custom) _customDateSelector,
            const SizedBox(height: 5),
            FutureBuilder(
              future: _getStatistics(_fromDay, _toDay),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                              const Text("Всего посещений", style: TextStyle(fontSize: 20)),
                              _statisticsCount(studentsStatistics.statictics!.allPresents, studentsStatistics.statictics!.countAllLessons),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Всего выполненных ДЗ", style: TextStyle(fontSize: 20)),
                              _statisticsCount(studentsStatistics.statictics!.allHomeTasks, studentsStatistics.statictics!.countAllLessons)
                            ],
                          ),
                          const SizedBox(height: 26),
                          _calendar(studentsStatistics, widget.state),
                          const SizedBox(height: 37),
                          _disciplinesList(studentsStatistics.showingDisciplines),
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
