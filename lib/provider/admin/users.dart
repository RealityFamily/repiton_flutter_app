import 'package:flutter/foundation.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';

class UsersProvider with ChangeNotifier {
  final List<Teacher> _teachersList = [];
  final List<Student> _studentsList = [];

  UsersProvider();

  List<Teacher> get teachersList => [..._teachersList];
  List<Student> get studentsList => [..._studentsList];

  Future<void> fetchTeachers() async {
    _teachersList.clear();
    // TODO: Call API method https://backend.repiton.dev.realityfamily.ru:9046/swagger-ui/?urls.primaryName=user-service#/Teacher/getTeachers

    await Future.delayed(const Duration(milliseconds: 500));
    _teachersList.addAll(
      [
        Teacher(
          id: "t1",
          name: "Зинаида",
          lastName: "Юрьевна",
          fatherName: "Аркадьевна",
          birthDay: DateTime.now(),
          email: "",
          phone: "",
          imageUrl: "https://interactive-examples.mdn.mozilla.net/media/cc0-images/grapefruit-slice-332-332.jpg",
          education: "",
        ),
      ],
    );
    notifyListeners();
  }

  void addTeacher(Teacher newTeacher) {
    _teachersList.add(newTeacher);
    notifyListeners();
  }

  Future<void> fetchStudents() async {
    _studentsList.clear();
    // TODO: Call API method https://backend.repiton.dev.realityfamily.ru:9046/swagger-ui/?urls.primaryName=user-service#/Student/getStudents

    await Future.delayed(const Duration(milliseconds: 500));
    _studentsList.addAll(
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
        ),
      ],
    );
    notifyListeners();
  }

  void addStudent(Student newStudent) {
    _studentsList.add(newStudent);
    notifyListeners();
  }
}
