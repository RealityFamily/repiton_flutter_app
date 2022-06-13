import 'package:intl/intl.dart';
import 'package:repiton/model/parent.dart';

class Student {
  late String id;
  late String name;
  late String lastName;
  late DateTime birthDay;
  late String email;
  late String phone;
  late String imageUrl;
  late String education;

  late List<Parent> parents;

  Student.empty() {
    id = "";
    name = "";
    lastName = "";
    birthDay = DateTime.now();
    email = "";
    phone = "";
    imageUrl = "";
    education = "";

    parents = [];
  }

  Student({
    required this.id,
    required this.name,
    required this.lastName,
    required this.birthDay,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.education,
    required this.parents,
  });

  String get fullName => lastName + " " + name;

  @override
  String toString() {
    return "id: " +
        id +
        "\nname: " +
        name +
        "\nlastName: " +
        lastName +
        "\nbirthDay: " +
        DateFormat("dd.MM.yyyy").format(birthDay) +
        "\nemail: " +
        email +
        "\nphone: " +
        phone +
        "\nimageUrl: " +
        imageUrl +
        "\neducation: " +
        education +
        "\nparents: " +
        parents.toString();
  }
}
