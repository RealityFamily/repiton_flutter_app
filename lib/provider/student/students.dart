import 'package:flutter/foundation.dart';
import 'package:repiton/model/student.dart';

class Students with ChangeNotifier {
  Student? _student;

  Students({
    required Students prevStudents,
  }) : _student = prevStudents._student;

  Students.empty();
  // {
  //   _students = [
  //     Student(
  //       id: "s1",
  //       name: "Виталий",
  //       lastName: "Евпанько",
  //       birthDay: DateTime.now(),
  //       email: "",
  //       phone: "",
  //       imageUrl: "https://upload.wikimedia.org/wikipedia/commons/7/78/Image.jpg",
  //       education: "",
  //       parents: [],
  //       price: 0,
  //       hours: 0,
  //     ),
  //   ];
  // }

  Future<Student> getCachedStudent() async {
    _student ??= Student(
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
    );
    return _student!;
  }
}
