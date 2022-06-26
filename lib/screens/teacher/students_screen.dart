import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/adding_discipline_screen.dart';
import 'package:repiton/widgets/teacher_students_element_widget.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Text("Ученики", style: TextStyle(fontSize: 34)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(16),
                      onPressed: () async {
                        Teacher userInfo = await RootProvider.getAuth().cachedUserInfo as Teacher;
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddingDisciplineScreen(initTeacher: userInfo)));
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 3, color: Theme.of(context).colorScheme.primary)),
                  labelText: "Поиск",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: () => debugPrint("Cancel search"),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder(
                future: RootProvider.getTeachers().fetchTeacherStudents(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Consumer(builder: (context, ref, _) {
                      final teacher = ref.watch(RootProvider.getTeachersProvider());

                      return ListView.separated(
                        itemBuilder: (context, index) => TeacherStudentsElementWidget(
                          studentName: teacher.teachersStudents[index].student?.fullName ?? "",
                          studentId: teacher.teachersStudents[index].student?.id ?? "",
                          disciplineName: teacher.teachersStudents[index].name,
                          nearestLessonDateTime: teacher.getDisciplineNearestLesson(teacher.teachersStudents[index]),
                        ),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: teacher.teachersStudents.length,
                      );
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
