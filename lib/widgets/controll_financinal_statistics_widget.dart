import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:repiton/model/info_visualisation_state.dart';
import 'package:repiton/model/statistics.dart';
import 'package:repiton/provider/teachers.dart';
import 'package:repiton/screens/controll_teacher_student_info.dart';
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
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  DateTime _showDate = DateTime.now();
  Future<FinancialStatistics> _getStatistics(
    DateTime showDate,
    InfoVisualisationState state,
  ) async {
    return await Provider.of<Teachers>(context, listen: false)
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
            FutureBuilder<FinancialStatistics>(
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
                            "Всего проведенных занятий",
                            style: TextStyle(fontSize: 22),
                          ),
                          Text(
                            snapshot.data!.allLessons.toString(),
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
                            snapshot.data!.allPrice.toStringAsFixed(0) + " ₽",
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
                            backgroundImage: NetworkImage(
                                snapshot.data!.students[index].studentImageUrl),
                          ),
                          title: Text(snapshot
                                  .data!.students[index].studentName +
                              " " +
                              snapshot.data!.students[index].studentLastName),
                          trailing: Text(
                            snapshot.data!.students[index].presents.toString(),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => ControllTeacherStudentInfo(
                                  studentStatistics:
                                      snapshot.data!.students[index],
                                ),
                              ),
                            );
                          },
                        ),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: snapshot.data!.students.length,
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
