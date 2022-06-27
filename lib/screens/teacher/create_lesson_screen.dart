import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/lesson.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/utils/device_size.dart';
import 'package:repiton/widgets/calendar_widget.dart';

class CreateLessonScreen extends StatefulWidget {
  final String? studentId;

  const CreateLessonScreen({this.studentId, Key? key}) : super(key: key);

  @override
  State<CreateLessonScreen> createState() => _CreateLessonScreenState();
}

class _CreateLessonScreenState extends State<CreateLessonScreen> {
  Lesson newLesson = Lesson.empty();

  bool isLoading = false;
  List<Discipline> disciplinesForSelect = [];
  List<Discipline> allTeacherDisciplinesAndLessons = [];
  Discipline? selectedDiscipline;

  final formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  DateTime? lessonStartDateTime;
  String? repeatSelectedValue;
  final endRepeatDateController = TextEditingController();
  DateTime? endRepeatDateTime;

  Widget _createLessonHeader() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 48.0),
        child: SizedBox(
          width: double.infinity,
          child: Text("Добавление занятий", style: TextStyle(fontSize: 34), textAlign: TextAlign.center),
        ),
      );

  Widget _createLessonHeaderAction(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(padding: const EdgeInsets.all(16), onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back)),
          if (DeviceSize.isTinyScreen(context))
            IconButton(padding: const EdgeInsets.all(16), onPressed: () => _openTeacherTimeTable(context), icon: const Icon(Icons.calendar_month)),
        ],
      );

  void _openTeacherTimeTable(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _teacherTimeTable(),
        ),
      ),
    );
  }

  Widget _teacherTimeTable() {
    return SingleChildScrollView(
      child: Column(children: [AddLessonCalendar(selectAction: (date) {}, disciplines: allTeacherDisciplinesAndLessons, lastDay: _lastLessonDayInAllDisciplines)]),
    );
  }

  DateTime? get _lastLessonDayInAllDisciplines {
    List<Lesson> lessons = [];
    for (var discipline in allTeacherDisciplinesAndLessons) {
      lessons.addAll(discipline.lessons);
    }
    lessons.sort((b, a) => a.dateTimeStart.compareTo(b.dateTimeStart));

    DateTime lastDay = lessons.isNotEmpty ? lessons.first.dateTimeStart : DateTime.now();
    return lastDay.month == DateTime.now().month && lastDay.year == DateTime.now().year ? null : lastDay;
  }

  Widget _buildScreen(BuildContext context) {
    if (DeviceSize.isTinyScreen(context)) {
      return _tinyCreateLessonScreen();
    } else {
      return _wideCreateLessonScreen();
    }
  }

  Widget _tinyCreateLessonScreen() {
    return Column(
      children: [
        const Text("Информация о создаваемом занятии", style: TextStyle(fontSize: 22)),
        const SizedBox(height: 16),
        Expanded(child: SingleChildScrollView(child: _newLessonForm())),
      ],
    );
  }

  Widget _wideCreateLessonScreen() => Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text("Информация о создаваемом занятии", textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
                      const SizedBox(height: 16),
                      Expanded(child: SingleChildScrollView(child: _newLessonForm())),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Expanded(child: Column(children: [const Text("Мое расписание", style: TextStyle(fontSize: 22)), Expanded(child: _teacherTimeTable())]))
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(8.0), child: _addLessonsButton()),
        ],
      );

  Widget get _disciplineChooser {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      if (disciplinesForSelect.isNotEmpty) {
        return SizedBox(
          width: double.infinity,
          child: DropdownButton<Discipline>(
            hint: const Text("Выберите дисциплину для создания урока"),
            isExpanded: true,
            value: selectedDiscipline,
            onChanged: (value) => setState(() => selectedDiscipline = value),
            items: disciplinesForSelect.map((discipline) => DropdownMenuItem<Discipline>(child: Text(discipline.name), value: discipline)).toList(),
          ),
        );
      } else {
        return const Text("Произошла ошибка при получении данных преподавателей");
      }
    }
  }

  Widget _newLessonForm() => Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _disciplineChooser,
            if (selectedDiscipline != null) ...[
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Название урока (Если название не задано, то будет автоматически выставлено \"Урок №...\")",
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                ),
                keyboardType: TextInputType.name,
                onSaved: (newValue) => newLesson.name = newValue ?? "Урок №${selectedDiscipline!.lessons.length + 1}",
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Описание урока",
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                ),
                keyboardType: TextInputType.name,
                onSaved: (newValue) => newLesson.description = newValue ?? "",
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Начало занятия", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                controller: dateController,
                keyboardType: TextInputType.datetime,
                readOnly: true,
                onTap: () async {
                  DateTime? _pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );

                  TimeOfDay? _pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child ?? Container()),
                  );

                  if (_pickedDate != null && _pickedTime != null) {
                    final resultDateTime = DateTime(_pickedDate.year, _pickedDate.month, _pickedDate.day, _pickedTime.hour, _pickedTime.minute);
                    String formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(resultDateTime);
                    dateController.text = formattedDate;

                    setState(() => lessonStartDateTime = resultDateTime);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty || lessonStartDateTime == null) {
                    return "Введите дату и время начала занятия";
                  }
                  return null;
                },
                onSaved: (_) => newLesson.dateTimeStart = lessonStartDateTime!,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Длительность урока",
                  suffixText: "минут",
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null) {
                    return "Введите продолжительность урока";
                  }
                  return null;
                },
                onSaved: (newValue) => newLesson.dateTimeStart = lessonStartDateTime!.add(Duration(minutes: int.parse(newValue!))),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: DropdownButton<String?>(
                  isExpanded: true,
                  value: repeatSelectedValue,
                  onChanged: (value) => setState(() => repeatSelectedValue = value),
                  items: [null, "Повторять каждую неделю", "Повторять через неделю", "Повторять каждый месяц"]
                      .map((repeatValue) => DropdownMenuItem<String?>(child: Text(repeatValue ?? "Не повторять"), value: repeatValue))
                      .toList(),
                ),
              ),
              if (repeatSelectedValue != null) ...[
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text("При повторении добавляемого урока к его названию будет добавлена \"№ ...\"",
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Дата окончания повторения", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                  controller: endRepeatDateController,
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  onTap: () async {
                    DateTime? _pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );

                    if (_pickedDate != null) {
                      String formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(_pickedDate);
                      endRepeatDateController.text = formattedDate;

                      setState(() => endRepeatDateTime = _pickedDate);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty || endRepeatDateTime == null) {
                      return "Введите дату окончания повторения";
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _checkLessonsOnTimeTable,
                  child: const Padding(padding: EdgeInsets.all(8.0), child: Text("Проверить на собственном расписании", style: TextStyle(fontSize: 18))),
                ),
              )
            ],
          ],
        ),
      );

  void _checkLessonsOnTimeTable() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      setState(() {
        allTeacherDisciplinesAndLessons.firstWhere((discipline) => discipline.id == selectedDiscipline?.id).lessons.add(newLesson);
      });
    }
  }

  Widget _addLessonsButton() => ElevatedButton(
        onPressed: () {},
        child: const Padding(padding: EdgeInsets.all(8.0), child: Text("Сохранить", style: TextStyle(fontSize: 18))),
      );

  void _loadAllData() async {
    setState(() => isLoading = true);

    await RootProvider.getTeachers().cachedTeacher;
    final disciplines = RootProvider.getTeachers().teacherDisciplines;

    setState(() {
      isLoading = false;
      disciplinesForSelect = widget.studentId != null ? disciplines.where((discipline) => discipline.student?.id == widget.studentId).toList() : disciplines;
      allTeacherDisciplinesAndLessons = disciplines;
    });
  }

  @override
  void initState() {
    _loadAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Stack(alignment: Alignment.center, children: [_createLessonHeader(), _createLessonHeaderAction(context)]),
              const SizedBox(height: 16),
              Expanded(child: _buildScreen(context)),
            ],
          ),
        ),
      ),
    );
  }
}
