import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/model/info_visualisation_state.dart';
import 'package:repiton/model/statistics.dart';
import 'package:repiton/provider/admin/teachers_statistics.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/admin/controll/teacher/controll_teacher_student_info.dart';
import 'package:repiton/widgets/calendar_widget.dart';
import 'package:repiton/widgets/date_chooser.dart';
import 'package:table_calendar/table_calendar.dart';

class ControllFinancinalStatisticsWidget extends StatefulWidget {
  final InfoVisualisationState state;

  const ControllFinancinalStatisticsWidget({required this.state, Key? key}) : super(key: key);

  @override
  State<ControllFinancinalStatisticsWidget> createState() => _ControllFinancinalStatisticsWidgetState();
}

class _ControllFinancinalStatisticsWidgetState extends State<ControllFinancinalStatisticsWidget> {
  late DateTime _fromDay;
  late DateTime _toDay;

  Future<void> _getStatistics(DateTime dateFrom, DateTime dateTo) async {
    await RootProvider.getTearchersStatisctics().fetchAndSetStatistics(dateFrom, dateTo);
    if (widget.state == InfoVisualisationState.custom) {
      RootProvider.getTearchersStatisctics().fecthAndSetStudentsInfoForAPeriod(dateFrom, dateTo);
    } else {
      RootProvider.getTearchersStatisctics().fecthAndSetStudentsInfoForADay(DateTime.now());
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
        _toDay = DateTime(focusDate.year, focusDate.month + 1, 0).isBefore(DateTime.now()) ? DateTime(focusDate.year, focusDate.month + 1, 0) : DateTime.now();
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

  Widget _calendar(TearchersStatiscticsProvider teachersStatistics, InfoVisualisationState state) {
    CalendarFormat formOfCalendarVisualisation = CalendarFormat.week;

    switch (state) {
      case InfoVisualisationState.week:
        formOfCalendarVisualisation = CalendarFormat.week;
        break;
      case InfoVisualisationState.month:
        formOfCalendarVisualisation = CalendarFormat.month;
        break;
      case InfoVisualisationState.custom:
        break;
    }

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: TeachersInfoCalendar(
        format: formOfCalendarVisualisation,
        selectAction: teachersStatistics.fecthAndSetStudentsInfoForADay,
        pageChangeAction: (date) async {
          _setDates(date);

          await teachersStatistics.fetchAndSetStatistics(
            _fromDay,
            _toDay,
          );
          switch (widget.state) {
            case InfoVisualisationState.week:
            case InfoVisualisationState.month:
              teachersStatistics.fecthAndSetStudentsInfoForADay(date);
              break;
            case InfoVisualisationState.custom:
              break;
          }
        },
      ),
    );
  }

  ImageProvider _studentImage(String? imageUrl) {
    if (imageUrl != null) {
      return NetworkImage(imageUrl);
    } else {
      return const AssetImage("assets/images/user_black.png");
    }
  }

  Widget _studentsList(List<StudentFinancialStatistics> students) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Подробнее по ученикам", style: TextStyle(fontSize: 24)),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(backgroundImage: _studentImage(students[index].student.imageUrl)),
              title: Text(students[index].student.name + " " + students[index].student.lastName),
              trailing: Text(students[index].presents.toString()),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ControllTeacherStudentInfo(studentStatistics: students[index]))),
            ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: students.length,
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
                      final teachersStatistics = ref.watch(RootProvider.getTearchersStatiscticsProvider());

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Всего проведенных занятий", style: TextStyle(fontSize: 22)),
                              Text(teachersStatistics.statictics!.allLessons.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Итого к оплате", style: TextStyle(fontSize: 22)),
                              Text(teachersStatistics.statictics!.allPrice.toStringAsFixed(0) + " ₽", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(height: 26),
                          _calendar(teachersStatistics, widget.state),
                          const SizedBox(height: 37),
                          _studentsList(teachersStatistics.students),
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
