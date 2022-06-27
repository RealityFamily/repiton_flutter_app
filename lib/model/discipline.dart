import 'package:repiton/model/lesson.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';

class Discipline {
  String? id;
  late String name;
  Teacher? teacher;
  Student? student;
  late List<Lesson> lessons;
  late double price;
  late int minutes;

  late List<String> rocketChatReference;

  Discipline({
    required this.id,
    required this.name,
    this.teacher,
    this.student,
    required this.lessons,
    required this.price,
    required this.minutes,
    required this.rocketChatReference,
  });

  Discipline.empty() {
    id = null;
    name = "";
    teacher = null;
    student = null;
    lessons = [];
    price = 0;
    minutes = 0;
    rocketChatReference = [];
  }

  Discipline copyWith({
    String? id,
    String? name,
    Teacher? teacher,
    Student? student,
    List<Lesson>? lessons,
    double? price,
    int? minutes,
    List<String>? rocketChatReference,
  }) =>
      Discipline(
        id: id ?? this.id,
        name: name ?? this.name,
        teacher: teacher ?? this.teacher,
        student: student ?? this.student,
        lessons: lessons ?? this.lessons,
        price: price ?? this.price,
        minutes: minutes ?? this.minutes,
        rocketChatReference: rocketChatReference ?? this.rocketChatReference,
      );

  @override
  bool operator ==(Object other) {
    if (other is Discipline) {
      return id == other.id;
    } else {
      return false;
    }
  }

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;
}
