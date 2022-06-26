import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/teacher/teacher_lesson_screen.dart';
import 'package:repiton/utils/separated_list.dart';
import 'package:repiton/widgets/calendar_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class TeacherTimeTableScreen extends StatefulWidget {
  const TeacherTimeTableScreen({Key? key}) : super(key: key);

  @override
  State<TeacherTimeTableScreen> createState() => _TeacherTimeTableScreenState();
}

class _TeacherTimeTableScreenState extends State<TeacherTimeTableScreen> {
  Color? _lessonElementInListColor(LessonStatus status) {
    switch (status) {
      case LessonStatus.done:
        return const Color(0xFF9DCBAA);
      case LessonStatus.canceledByStudent:
      case LessonStatus.canceledByTeacher:
        return const Color(0xFFDE9898);
      case LessonStatus.moved:
        return const Color(0xFFFFEE97);
      case LessonStatus.planned:
        return Colors.transparent;
      default:
        return null;
    }
  }

  void _onTapStudentElementInList(Discipline discipline, Lesson lesson) async {
    await RootProvider.getLessons().openLesson(lesson.id);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TeacherLessonScreen(disciplineName: discipline.name, studentName: discipline.student?.fullName ?? ""),
      ),
    );
  }

  Widget _studentElementInList(Discipline discipline, Lesson lesson) {
    return InkWell(
      hoverColor: Colors.grey[200],
      onTap: () => _onTapStudentElementInList(discipline, lesson),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(discipline.student?.fullName ?? "", style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 8),
                  Text(discipline.name, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
              color: _lessonElementInListColor(lesson.status),
              child: Column(
                children: [
                  Text(DateFormat("HH:mm").format(lesson.dateTimeStart), style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 5),
                  Text(DateFormat("dd.MM").format(lesson.dateTimeStart), style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    return TextField(
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
    );
  }

  List<Widget> _getListOfLessonsWidgetsForToday(List<Discipline> disciplines) {
    List<Widget> result = [];
    for (var discipline in disciplines) {
      for (var lesson in discipline.lessons) {
        result.add(_studentElementInList(discipline, lesson));
      }
    }
    return result;
  }

  Widget _wideScreen(Widget calendar, Widget students) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [calendar, Expanded(child: students)],
      );

  Widget _tinyScreen(Widget calendar, Widget students, bool areAnyLessons) => Column(
        children: [
          calendar,
          if (areAnyLessons) const Divider(),
          students,
          if (areAnyLessons) const Divider(),
        ],
      );

  Widget _getConsumerBuilder(BuildContext context, WidgetRef ref, Widget? child) {
    final teachersLessons = ref.watch(RootProvider.getTeachersLessonsProvider());

    final calendar = TimeTableCalendar(
      format: CalendarFormat.month,
      selectAction: teachersLessons.fecthAndSetLessonsForADay,
      pageChangeAction: teachersLessons.fetchAndSetLessons,
      disciplines: teachersLessons.disciplines,
    );
    final students = SeparatedList(
      children: _getListOfLessonsWidgetsForToday(teachersLessons.todayLessons),
      separatorBuilder: (_, __) => const Divider(),
    );

    if (MediaQuery.of(context).size.width < 1300) {
      return _tinyScreen(calendar, students, teachersLessons.todayLessons.isNotEmpty);
    } else {
      return _wideScreen(calendar, students);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Расписание", style: TextStyle(fontSize: 34)),
              const SizedBox(height: 23),
              _searchField(),
              const SizedBox(height: 20),
              FutureBuilder(
                future: _getLessons(DateTime.now()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Consumer(builder: _getConsumerBuilder);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getLessons(DateTime dateTime) async {
    await RootProvider.getTeachersLessons().fetchAndSetLessons(dateTime);

    RootProvider.getTeachersLessons().fecthAndSetLessonsForADay(dateTime);
  }
}
