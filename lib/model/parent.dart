class Parent {
  late String id;
  late String name;
  late String lastName;
  late String fatherName;
  late String phone;

  Parent.empty() {
    id = "";
    name = "";
    lastName = "";
    fatherName = "";
    phone = "";
  }

  Parent({
    required this.id,
    required this.name,
    required this.lastName,
    required this.fatherName,
    required this.phone,
  });

  @override
  String toString() {
    return "id: " +
        id +
        "name: " +
        name +
        "\nlastName: " +
        lastName +
        "\nfatherName: " +
        fatherName +
        "\nphone: " +
        phone;
  }
}
