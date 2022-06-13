import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';

class Discipline {
  late String id;
  late String name;
  late Teacher teacher;
  late Student student;
  late List<Lesson> lessons;

  late List<String> rocketChatReference;

  Discipline({
    required this.id,
    required this.name,
    required this.teacher,
    required this.student,
    required this.lessons,
    required this.rocketChatReference,
  });

  Discipline.empty() {
    id = "";
    name = "";
    teacher = Teacher.empty();
    student = Student.empty();
    lessons = [];
    rocketChatReference = [];
  }
}
