import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/repos/admin_repo.dart';
import 'package:repiton/widgets/add_student_parent_info.dart';

class AddStudentInfo extends StatefulWidget {
  Student result;
  final String? initStudentId;
  final GlobalKey<FormState> formKey;
  final bool isTitleNeeded;

  AddStudentInfo({
    required this.formKey,
    required this.result,
    this.isTitleNeeded = true,
    this.initStudentId,
    Key? key,
  }) : super(key: key);

  @override
  State<AddStudentInfo> createState() => _AddStudentInfoState();
}

class _AddStudentInfoState extends State<AddStudentInfo> {
  String? selectedEducation;
  DateTime? pickedDate;
  final TextEditingController _dateController = TextEditingController();

  Student? selectedStudent;
  List<Student> studentsForSelect = [];
  bool isLoading = false;

  final parentList = [AddStudentParentInfo(parentTitle: "Родитель 1")];

  Widget get _studentChooser {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      if (studentsForSelect.isNotEmpty) {
        return DropdownButtonFormField<Student>(
          hint: const Text("Выберите ученика из списка или создайте нового"),
          value: selectedStudent,
          validator: (value) {
            if (value == null) {
              return "Выберите ученика";
            }
            return null;
          },
          onSaved: (newValue) => widget.result = newValue!,
          onChanged: widget.initStudentId != null ? null : (value) => setState(() => selectedStudent = value!),
          items: studentsForSelect
              .map((student) => DropdownMenuItem<Student>(
                  child: student.id != null ? Text(student.fullName) : Row(children: const [Icon(Icons.add), SizedBox(width: 8), Text("Новый ученик")]), value: student))
              .toList(),
        );
      } else {
        return const Text("Произошла ошибка при получении данных преподавателей");
      }
    }
  }

  Future<List<Student>> get _getStudentsForSelecting {
    if (widget.initStudentId != null) {
      return RootProvider.getStudents().choosableStudent(widget.initStudentId!);
    } else {
      // TODO: Change to teacher or admin getStudent() method
      return AdminRepo().getStudents();
    }
  }

  void _getStudentsForShow() async {
    setState(() => isLoading = true);
    final result = await _getStudentsForSelecting;

    result.add(Student.empty());

    setState(() {
      isLoading = false;
      studentsForSelect = result;
      if (result.isNotEmpty && widget.initStudentId != null) selectedStudent = result.first;
    });
  }

  Widget get _parentInputForm => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: Text("Введите данные родителя ученика", style: TextStyle(fontSize: 22))),
              IconButton(
                onPressed: () => setState(() => parentList.add(AddStudentParentInfo(parentTitle: "Родитель ${parentList.length + 1}"))),
                icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
              )
            ],
          ),
          const SizedBox(height: 13),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) => _parentListItem(parentList[index]),
            separatorBuilder: (_, __) => const SizedBox(height: 36),
            itemCount: parentList.length,
          ),
        ],
      );

  Widget _parentListItem(AddStudentParentInfo item) {
    if (kIsWeb) {
      item.onDeleteButtonPressed = () => _onDeleteParentItemFromList(item);
      return item;
    } else {
      return Dismissible(
        key: ObjectKey(item),
        background: Container(color: Colors.red),
        child: item,
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) _onDeleteParentItemFromList(item);
        },
      );
    }
  }

  void _onDeleteParentItemFromList(AddStudentParentInfo item) {
    setState(() {
      if (parentList.length > 1) {
        parentList.remove(item);
      }
    });
  }

  @override
  void initState() {
    if (widget.result.id != null) {
      selectedStudent = widget.result;
      selectedStudent!.id = null;
    } else {
      _getStudentsForShow();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedEducation = widget.result.education;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.isTitleNeeded) const Text("Введите данные ученика", style: TextStyle(fontSize: 22)),
        Form(
          key: widget.formKey,
          child: Column(
            children: [
              if (widget.isTitleNeeded) _studentChooser,
              if (selectedStudent != null && selectedStudent!.id == null) ...[
                TextFormField(
                  initialValue: widget.result.lastName,
                  decoration: const InputDecoration(labelText: "Фамилия", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Введите фамилию";
                    }
                    return null;
                  },
                  onSaved: (newValue) => widget.result.lastName = newValue!,
                ),
                TextFormField(
                  initialValue: widget.result.name,
                  decoration: const InputDecoration(labelText: "Имя", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Введите имя";
                    }
                    return null;
                  },
                  onSaved: (newValue) => widget.result.name = newValue!,
                ),
                TextFormField(
                  initialValue: widget.result.birthDay != null ? DateFormat('dd.MM.yyyy').format(widget.result.birthDay!) : null,
                  decoration: const InputDecoration(labelText: "Дата рождения", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                  controller: _dateController,
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  onTap: () async {
                    DateTime? _pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (_pickedDate != null) {
                      String formattedDate = DateFormat('dd.MM.yyyy').format(_pickedDate);
                      _dateController.text = formattedDate;

                      setState(() => pickedDate = _pickedDate);
                    } else {
                      debugPrint("Date is not selected");
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty || pickedDate == null) {
                      return "Введите дату рождения";
                    }
                    return null;
                  },
                  onSaved: (newValue) => widget.result.birthDay = pickedDate!,
                ),
                TextFormField(
                  initialValue: widget.result.email,
                  decoration: const InputDecoration(labelText: "Почта", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains("@")) {
                      return "Введите почту";
                    }
                    return null;
                  },
                  onSaved: (newValue) => widget.result.email = newValue!,
                ),
                TextFormField(
                  initialValue: widget.result.phone,
                  decoration: const InputDecoration(labelText: "Телефон", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Введите телефон";
                    }
                    return null;
                  },
                  onSaved: (newValue) => widget.result.phone = newValue!,
                ),
                DropdownButtonFormField<String>(
                  hint: const Text("В каком вы классе?"),
                  value: selectedEducation,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Выберите полученное образование";
                    }
                    return null;
                  },
                  onSaved: (newValue) => widget.result.education = newValue!,
                  onChanged: (value) => setState(() => selectedEducation = value!),
                  items: const [
                    DropdownMenuItem<String>(child: Text("Дошкольник"), value: "Дошкольник"),
                    DropdownMenuItem<String>(child: Text("1"), value: "1"),
                    DropdownMenuItem<String>(child: Text("2"), value: "2"),
                    DropdownMenuItem<String>(child: Text("3"), value: "3"),
                    DropdownMenuItem<String>(child: Text("4"), value: "4"),
                    DropdownMenuItem<String>(child: Text("5"), value: "5"),
                    DropdownMenuItem<String>(child: Text("6"), value: "6"),
                    DropdownMenuItem<String>(child: Text("7"), value: "7"),
                    DropdownMenuItem<String>(child: Text("8"), value: "8"),
                    DropdownMenuItem<String>(child: Text("9"), value: "9"),
                    DropdownMenuItem<String>(child: Text("10"), value: "10"),
                    DropdownMenuItem<String>(child: Text("11"), value: "11"),
                    DropdownMenuItem<String>(child: Text("Студент"), value: "Студент"),
                  ],
                ),
                const SizedBox(height: 32),
                _parentInputForm
              ],
            ],
          ),
        ),
      ],
    );
  }
}
