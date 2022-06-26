import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/provider/auth.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/adding_discipline_screen.dart';
import 'package:repiton/utils/separated_list.dart';

class StudentDisciplinesInfo extends StatelessWidget {
  const StudentDisciplinesInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Связанные дисциплины с учеником", style: TextStyle(fontSize: 22)),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final userInfo = await RootProvider.getAuth().cachedUserInfo;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddingDisciplineScreen(initStudent: RootProvider.getStudentInfo().student!, initTeacher: userInfo is Teacher ? userInfo : null),
                  ),
                );
              },
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
    ;
  }

  Widget _studentDiscipline(BuildContext context, Discipline discipline) => InkWell(
        onTap: () => _openDisciplineInfo(context, discipline.id!),
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
              IconButton(
                onPressed: () async {
                  final check = (await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Удалить дисциплину?"),
                          content: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: Text("Вы уверены, что хотите удалить данную дисциплину?\n\n"
                                    "Вместе с ней удаляться все занятия, проведенные по ней, а также все домашние задания, заданные по ней." +
                                (RootProvider.getStudentInfo().studentDisciplines.length == 1
                                    ? "\n\nВ связи с тем, что это единственная дисциплина у ученика, после её удаления ученик будет также следом удален из системы."
                                    : "")),
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text("Удалить", style: TextStyle(color: Colors.red))),
                            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text("Отмена")),
                          ],
                        ),
                      )) ??
                      false;
                  if (discipline.id != null && check) RootProvider.getStudentInfo().deleteDiscipline(discipline.id!);
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              )
            ],
          ),
        ),
      );

  void _openDisciplineInfo(BuildContext context, String disciplineId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Информация о дисциплине"),
        content: Consumer(
          builder: (context, ref, _) {
            final discipline = ref.watch(RootProvider.getStudentInfoProvider()).disciplineById(disciplineId);

            return SeparatedList(
              mainAxisSize: MainAxisSize.min,
              separatorBuilder: (_, __) => const Divider(),
              children: [
                _disciplineInfoField("Название дисциплины", discipline.name),
                _disciplineInfoField("Ставка", "${discipline.price.toStringAsFixed(2)} руб/ч"),
                _disciplineInfoField("Длительность", discipline.minutes.toString()),
              ],
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => _openChangingDisciplineInfo(context, disciplineId), child: const Text("Изменить")),
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

  void _openChangingDisciplineInfo(BuildContext context, String disciplineId) async {
    final newDiscipline = await showDialog<Discipline>(
      context: context,
      builder: (ctx) {
        final newDiscipline = RootProvider.getStudentInfo().disciplineById(disciplineId).copyWith();
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
}
