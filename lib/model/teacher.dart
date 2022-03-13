import 'package:intl/intl.dart';

class Teacher {
  late String name;
  late String lastName;
  late String fatherName;
  late DateTime birthDay;
  late String email;
  late String phone;
  late String education;

  Teacher.empty() {
    name = "";
    lastName = "";
    fatherName = "";
    birthDay = DateTime.now();
    email = "";
    phone = "";
    education = "";
  }

  Teacher({
    required this.name,
    required this.lastName,
    required this.fatherName,
    required this.birthDay,
    required this.email,
    required this.phone,
    required this.education,
  });

  @override
  String toString() {
    return "name: " +
        name +
        "\nlastName: " +
        lastName +
        "\nfatherName: " +
        fatherName +
        "\nbirthDay: " +
        DateFormat("dd.MM.yyyy").format(birthDay) +
        "\nemail: " +
        email +
        "\nphone: " +
        phone +
        "\neducation: " +
        education;
  }
}
