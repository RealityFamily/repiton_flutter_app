import 'package:intl/intl.dart';
import 'package:repiton/model/parent.dart';

class Student {
  late String name;
  late String lastName;
  late DateTime birthDay;
  late String email;
  late String phone;
  late String education;

  late List<Parent> parents;

  late double price;
  late int hours;

  Student.empty() {
    name = "";
    lastName = "";
    birthDay = DateTime.now();
    email = "";
    phone = "";
    education = "";

    parents = [];

    price = 0;
    hours = 0;
  }

  Student({
    required this.name,
    required this.lastName,
    required this.birthDay,
    required this.email,
    required this.phone,
    required this.education,
    required this.parents,
    required this.price,
    required this.hours,
  });

  @override
  String toString() {
    return "name: " +
        name +
        "\nlastName: " +
        lastName +
        "\nbirthDay: " +
        DateFormat("dd.MM.yyyy").format(birthDay) +
        "\nemail: " +
        email +
        "\nphone: " +
        phone +
        "\neducation: " +
        education +
        "\nparents: " +
        parents.toString() +
        "\nprice: " +
        price.toString() +
        "\nhours: " +
        hours.toString();
  }
}
