import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repiton/core/comparing/date_comparing.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/statistics.dart';
import 'package:repiton/provider/students.dart';
import 'package:repiton/provider/teachers.dart';
import 'package:table_calendar/table_calendar.dart';

abstract class Calendar extends StatefulWidget {
  final CalendarFormat format;
  final DateTime lastDay;
  final Function(DateTime) selectAction;
  final Function(DateTime) pageChangeAction;

  const Calendar({
    required this.format,
    required this.lastDay,
    required this.selectAction,
    required this.pageChangeAction,
    Key? key,
  }) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();

  Color? getColor(DateTime day);
}

class _CalendarState extends State<Calendar> {
  DateTime _showDate = DateTime.now();
  DateTime _selectDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: _showDate,
      firstDay: DateTime(2000),
      lastDay: widget.lastDay,
      calendarFormat: widget.format,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(
            fontSize: 24,
          ),
          titleTextFormatter: (date, locale) {
            String result = "";

            switch (date.month) {
              case 1:
                result = "Январь";
                break;
              case 2:
                result = "Февраль";
                break;
              case 3:
                result = "Март";
                break;
              case 4:
                result = "Апрель";
                break;
              case 5:
                result = "Май";
                break;
              case 6:
                result = "Июнь";
                break;
              case 7:
                result = "Июль";
                break;
              case 8:
                result = "Август";
                break;
              case 9:
                result = "Сентябрь";
                break;
              case 10:
                result = "Октябрь";
                break;
              case 11:
                result = "Ноябрь";
                break;
              case 12:
                result = "Декабрь";
                break;
            }

            return result + " " + date.year.toString();
          }),
      daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (date, locale) => DateFormat("EE", "ru").format(
                date,
              )),
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
        todayDecoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
          shape: BoxShape.circle,
        ),
      ),
      selectedDayPredicate: (day) {
        return isSameDay(_selectDate, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectDate = selectedDay;
          _showDate = focusedDay;
        });
        widget.selectAction(_selectDate);
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _showDate = focusedDay;
        });
        widget.pageChangeAction(_showDate);
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, events) => Container(
          margin: const EdgeInsets.all(5.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.getColor(date) ?? Colors.transparent,
          ),
          child: Text(
            date.day.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
        ),
        selectedBuilder: (context, date, events) => Container(
          margin: const EdgeInsets.all(5.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Text(
            date.day.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        todayBuilder: (context, date, events) => Container(
          margin: const EdgeInsets.all(5.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.getColor(date) ?? Colors.black26,
          ),
          child: Text(
            date.day.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class TeachersInfoCalendar extends Calendar {
  late final FinancialStatistics? statistics;

  TeachersInfoCalendar({
    required Teachers provider,
    required CalendarFormat format,
    required Function(DateTime) selectAction,
    required Function(DateTime) pageChangeAction,
    Key? key,
  }) : super(
          format: format,
          lastDay: DateTime.now(),
          selectAction: selectAction,
          pageChangeAction: pageChangeAction,
          key: key,
        ) {
    statistics = provider.statictics;
  }

  @override
  Color? getColor(DateTime day) {
    LessonStatus? result;
    if (statistics == null) {
      return null;
    }

    OUTER:
    for (var student in statistics!.students) {
      for (var lesson in student.lessons) {
        if (lesson.dateTimeStart.isSameDate(day)) {
          switch (lesson.status) {
            case LessonStatus.done:
              result ??= LessonStatus.done;
              break;
            case LessonStatus.canceled:
              result = LessonStatus.canceled;
              break OUTER;
            case LessonStatus.moved:
              result = LessonStatus.moved;
              break;
          }
        }
      }
    }
    switch (result) {
      case LessonStatus.done:
        return const Color(0xFF9DCBAA);
      case LessonStatus.canceled:
        return const Color(0xFFDE9898);
      case LessonStatus.moved:
        return const Color(0xFFFFEE97);
      default:
        return null;
    }
  }
}

class StudentsInfoCalendar extends Calendar {
  late final LearnStatistics? statistics;

  StudentsInfoCalendar({
    required Students provider,
    required CalendarFormat format,
    required Function(DateTime) selectAction,
    required Function(DateTime) pageChangeAction,
    Key? key,
  }) : super(
          format: format,
          lastDay: DateTime.now(),
          selectAction: selectAction,
          pageChangeAction: pageChangeAction,
          key: key,
        ) {
    statistics = provider.statictics;
  }

  @override
  Color? getColor(DateTime day) {
    LessonStatus? result;
    if (statistics == null) {
      return null;
    }

    OUTER:
    for (var discipline in statistics!.disciplines) {
      for (var lesson in discipline.discipline.lessons) {
        if (lesson.dateTimeStart.isSameDate(day)) {
          switch (lesson.status) {
            case LessonStatus.done:
              result ??= LessonStatus.done;
              break;
            case LessonStatus.canceled:
              result = LessonStatus.canceled;
              break OUTER;
            case LessonStatus.moved:
              result = LessonStatus.moved;
              break;
          }
        }
      }
    }
    switch (result) {
      case LessonStatus.done:
        return const Color(0xFF9DCBAA);
      case LessonStatus.canceled:
        return const Color(0xFFDE9898);
      case LessonStatus.moved:
        return const Color(0xFFFFEE97);
      default:
        return null;
    }
  }
}

class TimeTableCalendar extends Calendar {
  late final List<Discipline> disciplines;

  TimeTableCalendar({
    required Teachers provider,
    required CalendarFormat format,
    required Function(DateTime) selectAction,
    required Function(DateTime) pageChangeAction,
    Key? key,
  }) : super(
          format: format,
          lastDay: DateTime(DateTime.now().year, DateTime.now().month + 2, 0),
          selectAction: selectAction,
          pageChangeAction: pageChangeAction,
          key: key,
        ) {
    disciplines = provider.disciplines;
  }

  @override
  Color? getColor(DateTime day) {
    LessonStatus? result;
    if (disciplines.isEmpty) {
      return null;
    }

    OUTER:
    for (var discipline in disciplines) {
      for (var lesson in discipline.lessons) {
        if (lesson.dateTimeStart.isSameDate(day)) {
          switch (lesson.status) {
            case LessonStatus.done:
              result ??= LessonStatus.done;
              break;
            case LessonStatus.canceled:
              result = LessonStatus.canceled;
              break OUTER;
            case LessonStatus.moved:
              result = LessonStatus.moved;
              break;
            case LessonStatus.planned:
              result = LessonStatus.planned;
              break;
          }
        }
      }
    }
    switch (result) {
      case LessonStatus.done:
        return const Color(0xFF9DCBAA);
      case LessonStatus.canceled:
        return const Color(0xFFDE9898);
      case LessonStatus.moved:
        return const Color(0xFFFFEE97);
      case LessonStatus.planned:
        return const Color.fromARGB(255, 151, 187, 255);
      default:
        return null;
    }
  }
}
