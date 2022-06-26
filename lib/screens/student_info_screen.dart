import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/provider/auth.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/adding_discipline_screen.dart';
import 'package:repiton/utils/separated_list.dart';
import 'package:repiton/widgets/student_info.dart';

class StudentInfoScreen extends StatelessWidget {
  final String studentId;

  const StudentInfoScreen({required this.studentId, Key? key}) : super(key: key);

  Widget _studentInfoHeader(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(children: [
            const Text("Информация о пользователе", style: TextStyle(fontSize: 34), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            _studentInfoHeaderSubTitle(context),
          ]),
        ),
      );

  Widget _studentInfoHeaderSubTitle(BuildContext context) => Consumer(builder: (context, ref, _) {
        final studentInfoProvider = ref.watch(RootProvider.getStudentInfoProvider());

        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              const TextSpan(text: "Ученик ", style: TextStyle(fontSize: 18, color: Colors.grey)),
              TextSpan(text: studentInfoProvider.student?.fullName ?? "", style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.primary)),
            ],
          ),
        );
      });

  Widget _studentInfoHeaderAction(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [_studentInfoActionBackButton(context)],
      );

  Widget _studentInfoActionBackButton(BuildContext context) => IconButton(
        padding: const EdgeInsets.all(16),
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back),
      );

  Widget _buildScreen(BuildContext context) {
    if (MediaQuery.of(context).size.width < 1500) {
      return _tinyScreen(context);
    } else {
      return _wideScreen(context);
    }
  }

  Widget _tinyScreen(BuildContext context) => SeparatedList(
        children: [const StudentInfo(), _studentsDisciplines(context), _studentTimeTable()],
        separatorBuilder: (_, __) => const Divider(),
      );

  Widget _wideScreen(BuildContext context) => Row(
        children: [
          const Expanded(child: SingleChildScrollView(child: StudentInfo())),
          const VerticalDivider(),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _studentsDisciplines(context)),
                const Divider(),
                Expanded(child: _studentTimeTable()),
              ],
            ),
          )
        ],
      );

  Widget _studentsDisciplines(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Связанные дисциплины с учеником", style: TextStyle(fontSize: 22)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddingDisciplineScreen(initStudent: RootProvider.getStudentInfo().student!)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            child: Consumer(
              builder: (context, ref, child) {
                final studentInfoProvider = RootProvider.getStudentInfo();

                return SeparatedList(
                  separatorBuilder: (_, __) => const Divider(),
                  children: studentInfoProvider.studentDisciplines.map((discipline) => _studentDiscipline(context, discipline)).toList(),
                );
              },
            ),
          )
        ],
      );

  Widget _studentDiscipline(BuildContext context, Discipline discipline) => InkWell(
        onTap: () => _openDisciplineInfo(context, discipline),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(discipline.name, style: const TextStyle(fontSize: 18)),
                  if (RootProvider.getAuth().userRole == AuthProvider.adminRole) const SizedBox(height: 8),
                  if (RootProvider.getAuth().userRole == AuthProvider.adminRole) Text(discipline.teacher?.fullName ?? ""),
                ],
              ),
              IconButton(onPressed: null, icon: const Icon(Icons.delete, color: Colors.red))
            ],
          ),
        ),
      );

  void _openDisciplineInfo(BuildContext context, Discipline discipline) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Информация о дисциплине"),
        content: SeparatedList(
          mainAxisSize: MainAxisSize.min,
          separatorBuilder: (_, __) => const Divider(),
          children: [
            _disciplineInfoField("Название дисциплины", discipline.name),
            _disciplineInfoField("Ставка", "${discipline.price.toStringAsFixed(2)} руб/ч"),
            _disciplineInfoField("Длительность", discipline.minutes.toString()),
          ],
        ),
        actions: [
          TextButton(onPressed: () => _openChangingDisciplineInfo(context, discipline), child: const Text("Изменить")),
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Закрыть")),
        ],
      ),
    );
  }

  Widget _disciplineInfoField(String title, String value) => SizedBox(
        width: 400,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(title, style: const TextStyle(fontSize: 18)), Text(value)],
        ),
      );

  void _openChangingDisciplineInfo(BuildContext context, Discipline discipline) async {
    final newDiscipline = await showDialog<Discipline>(
      context: context,
      builder: (ctx) {
        final newDiscipline = discipline.copyWith();
        final formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: const Text("Введите новую информацию о дисциплине"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: newDiscipline.name,
                  decoration: const InputDecoration(labelText: "Название дисциплины", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Введите ставку";
                    }
                    return null;
                  },
                  onSaved: (newValue) => newDiscipline.name = newValue!,
                ),
                const SizedBox(
                  width: 23,
                ),
                TextFormField(
                  initialValue: newDiscipline.price.toStringAsFixed(2),
                  decoration: const InputDecoration(labelText: "Ставка", suffixText: "₽ в час", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty || double.tryParse(value) == null) {
                      return "Введите ставку";
                    }
                    return null;
                  },
                  onSaved: (newValue) => newDiscipline.price = double.parse(newValue!),
                ),
                const SizedBox(
                  width: 23,
                ),
                TextFormField(
                  initialValue: newDiscipline.minutes.toString(),
                  decoration: const InputDecoration(labelText: "Количество занятий", suffixText: "ч. в нед.", contentPadding: EdgeInsets.symmetric(vertical: 5)),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || int.tryParse(value) == null) {
                      return "Введите количество занятий";
                    }
                    return null;
                  },
                  onSaved: (newValue) => newDiscipline.minutes = int.parse(newValue!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  Navigator.of(ctx).pop<Discipline>(newDiscipline);
                }
              },
              child: const Text("Сохранить"),
            ),
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Отмена")),
          ],
        );
      },
    );

    if (newDiscipline != null) RootProvider.getStudentInfo().updateDisciplineInfo(newDiscipline);
  }

  Widget _studentTimeTable() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Занятия с учеником", style: TextStyle(fontSize: 22)),
              IconButton(icon: const Icon(Icons.add), onPressed: null),
            ],
          ),
          SingleChildScrollView(),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder(
            future: RootProvider.getStudentInfo().fetchAndSetStudentForInfo(studentId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    Stack(alignment: Alignment.center, children: [_studentInfoHeader(context), _studentInfoHeaderAction(context)]),
                    const SizedBox(height: 16),
                    Expanded(child: _buildScreen(context)),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
