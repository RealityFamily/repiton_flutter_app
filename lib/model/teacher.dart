import 'package:intl/intl.dart';

class Teacher {
  late String id;
  late String name;
  late String lastName;
  late String fatherName;
  late DateTime birthDay;
  late String email;
  late String phone;
  late String imageUrl;
  late String education;

  String get fullName => "$lastName $name $fatherName";

  Teacher.empty() {
    id = "";
    name = "";
    lastName = "";
    fatherName = "";
    birthDay = DateTime.now();
    email = "";
    phone = "";
    imageUrl = "";
    education = "";
  }

  Teacher({
    required this.id,
    required this.name,
    required this.lastName,
    required this.fatherName,
    required this.birthDay,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.education,
  });

  @override
  String toString() {
    return "id: " +
        id +
        "\nname: " +
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
        "\nimageUrl: " +
        imageUrl +
        "\neducation: " +
        education;
  }

  @override
  bool operator ==(Object other) {
    if (other is Teacher) {
      return id == other.id;
    } else {
      return false;
    }
  }

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;
}
