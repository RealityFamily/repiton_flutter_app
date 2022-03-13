class Parent {
  late String name;
  late String lastName;
  late String fatherName;
  late String phone;

  Parent.empty() {
    name = "";
    lastName = "";
    fatherName = "";
    phone = "";
  }

  Parent({
    required this.name,
    required this.lastName,
    required this.fatherName,
    required this.phone,
  });

  @override
  String toString() {
    return "name: " +
        name +
        "\nlastName: " +
        lastName +
        "\nfatherName: " +
        fatherName +
        "\nphone: " +
        phone;
  }
}
