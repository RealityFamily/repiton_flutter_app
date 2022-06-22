import 'package:intl/intl.dart';

class Teacher {
  String? id;
  String? userName;
  late String name;
  late String lastName;
  String? fatherName;
  DateTime? birthDay;
  late String email;
  String? phone;
  String? imageUrl;
  String? education;

  String get fullName => "$lastName $name $fatherName";

  Teacher.empty() {
    id = null;
    userName = null;
    name = "";
    lastName = "";
    fatherName = null;
    birthDay = DateTime.now();
    email = "";
    phone = null;
    imageUrl = null;
    education = null;
  }

  Teacher({
    this.id,
    this.userName,
    required this.name,
    required this.lastName,
    this.fatherName,
    this.birthDay,
    required this.email,
    this.phone,
    this.imageUrl,
    this.education,
  });

  @override
  String toString() {
    return "id: " +
        (id ?? "null") +
        "\nuserName: " +
        (userName ?? "null") +
        "\nname: " +
        name +
        "\nlastName: " +
        lastName +
        "\nfatherName: " +
        (fatherName ?? "null") +
        "\nbirthDay: " +
        (birthDay != null ? DateFormat("dd.MM.yyyy").format(birthDay!) : "null") +
        "\nemail: " +
        email +
        "\nphone: " +
        (phone ?? "null") +
        "\nimageUrl: " +
        (imageUrl ?? "null") +
        "\neducation: " +
        (education ?? "null");
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
