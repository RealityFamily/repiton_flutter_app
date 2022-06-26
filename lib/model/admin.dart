class Admin {
  String? id;
  String? userName;
  late String name;
  late String lastName;
  String? fatherName;

  String get fullName => "$lastName $name $fatherName";

  Admin.empty() {
    id = null;
    userName = null;
    name = "";
    lastName = "";
    fatherName = null;
  }

  Admin({
    this.id,
    this.userName,
    required this.name,
    required this.lastName,
    this.fatherName,
  });

  @override
  String toString() {
    return "id: " + (id ?? "null") + "\nuserName: " + (userName ?? "null") + "\nname: " + name + "\nlastName: " + lastName + "\nfatherName: " + (fatherName ?? "null");
  }
}
