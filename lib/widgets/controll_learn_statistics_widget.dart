import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:repiton/model/info_visualisation_state.dart';
import 'package:repiton/model/statistics.dart';
import 'package:repiton/provider/students.dart';
import 'package:repiton/screens/controll_student_teacher_info.dart';
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
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  DateTime _showDate = DateTime.now();
  Future<LearnStatistics> _getStatistics(
    DateTime showDate,
    InfoVisualisationState state,
  ) async {
    return await Provider.of<Students>(context, listen: false)
        .getStatistics(showDate, state);
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
                    child: TextField(
                      controller: _fromController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down,
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? _pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: _toDate ?? DateTime.now(),
                        );

                        if (_pickedDate != null) {
                          String formattedDate =
                              DateFormat('dd.MM.yyyy').format(_pickedDate);
                          _fromController.text = formattedDate;

                          setState(() {
                            _fromDate = _pickedDate;
                          });
                        } else {
                          debugPrint("Date is not selected");
                        }
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
                    child: TextField(
                      controller: _toController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down,
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? _pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: _fromDate ?? DateTime(1900),
                          lastDate: DateTime.now(),
                        );

                        if (_pickedDate != null) {
                          String formattedDate =
                              DateFormat('dd.MM.yyyy').format(_pickedDate);
                          _toController.text = formattedDate;

                          setState(() {
                            _toDate = _pickedDate;
                          });
                        } else {
                          debugPrint("Date is not selected");
                        }
                      },
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: widget.state == InfoVisualisationState.custom ? 26 : 5,
            ),
            FutureBuilder<LearnStatistics>(
              future: _getStatistics(_showDate, widget.state),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
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
                          Text(
                            snapshot.data!.allPresents.toString() +
                                "/" +
                                snapshot.data!.countAllLessons.toString() +
                                " (" +
                                (snapshot.data!.allPresents *
                                        100 /
                                        snapshot.data!.countAllLessons)
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
                            snapshot.data!.allHomeTasks.toString() +
                                "/" +
                                snapshot.data!.countAllLessons.toString() +
                                " (" +
                                (snapshot.data!.allPresents *
                                        100 /
                                        snapshot.data!.countAllLessons)
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
                        TableCalendar(
                          focusedDay: _showDate,
                          firstDay: DateTime(2000),
                          lastDay: DateTime.now().add(Duration(
                              days: DateTime.daysPerWeek - _showDate.weekday)),
                          calendarFormat: CalendarFormat.week,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                          onPageChanged: (focusedDay) {
                            setState(() {
                              _showDate = focusedDay;
                            });
                          },
                        ),
                      if (widget.state == InfoVisualisationState.month)
                        TableCalendar(
                          focusedDay: _showDate,
                          firstDay: DateTime(2000),
                          lastDay: DateTime(
                            DateTime.now().year,
                            DateTime.now().month + 1,
                            0,
                          ),
                          calendarFormat: CalendarFormat.month,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                          onPageChanged: (focusedDay) {
                            setState(() {
                              _showDate = focusedDay;
                            });
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
                        itemBuilder: (context, index) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(snapshot
                                .data!.disciplines[index].teacherImageUrl),
                          ),
                          title: Text(
                              snapshot.data!.disciplines[index].disciplineName),
                          subtitle: Text(
                            snapshot.data!.disciplines[index].teacherLastName +
                                " " +
                                snapshot.data!.disciplines[index].teacherName +
                                " " +
                                snapshot
                                    .data!.disciplines[index].teacherFatherName,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => ControllStudentTeacherInfo(
                                  studentStatistics:
                                      snapshot.data!.disciplines[index],
                                ),
                              ),
                            );
                          },
                        ),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: snapshot.data!.disciplines.length,
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
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
