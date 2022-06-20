import 'package:intl/intl.dart';
import 'package:repiton/model/parent.dart';

class Student {
  late String id;
  String? userName;
  late String name;
  late String lastName;
  DateTime? birthDay;
  late String email;
  String? phone;
  String? imageUrl;
  String? education;

  late List<Parent> parents;

  Student.empty() {
    id = "";
    userName = null;
    name = "";
    lastName = "";
    birthDay = null;
    email = "";
    phone = null;
    imageUrl = null;
    education = null;

    parents = [];
  }

  Student({
    required this.id,
    this.userName,
    required this.name,
    required this.lastName,
    this.birthDay,
    required this.email,
    this.phone,
    this.imageUrl,
    this.education,
    required this.parents,
  });

  String get fullName => "$lastName $name";

  @override
  String toString() {
    return "id: " +
        id +
        "\nuserName: " +
        (userName ?? "null") +
        "\nname: " +
        name +
        "\nlastName: " +
        lastName +
        "\nbirthDay: " +
        (birthDay != null ? DateFormat("dd.MM.yyyy").format(birthDay!) : "null") +
        "\nemail: " +
        email +
        "\nphone: " +
        (phone ?? "null") +
        "\nimageUrl: " +
        (imageUrl ?? "null") +
        "\neducation: " +
        (education ?? "null") +
        "\nparents: " +
        parents.toString();
  }
}
