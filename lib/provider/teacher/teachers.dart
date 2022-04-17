import 'package:flutter/foundation.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';

class Teachers with ChangeNotifier {
  Teacher? _teacher;
  final List<Student> _teacherStudents = [];

  Teachers.empty();

  Teachers({
    required Teachers prevTeachers,
  }) : _teacher = prevTeachers._teacher;

  List<Student> get teachersStudents => [..._teacherStudents];

  Future<Teacher> getCachedTeacher() async {
    _teacher ??= Teacher(
      id: "t1",
      name: "Зинаида",
      lastName: "Юрьевна",
      fatherName: "Аркадьевна",
      birthDay: DateTime.now(),
      email: "",
      phone: "",
      imageUrl: "https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg",
      education: "",
    );
    return _teacher!;
  }

  void registerStudent(Student student) {}

  Future<void> fetchTeacherStudents() async {
    _teacherStudents.clear();
    _teacherStudents.addAll(
      [
        Student(
          id: "s1",
          name: "Виталий",
          lastName: "Евпанько",
          birthDay: DateTime.now(),
          email: "",
          phone: "",
          imageUrl: "https://upload.wikimedia.org/wikipedia/commons/7/78/Image.jpg",
          education: "",
          parents: [],
          price: 0,
          hours: 0,
        ),
      ],
    );
  }
}
