import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/provider/teacher/teachers.dart';
import 'package:repiton/screens/adding_account_screen.dart';
import 'package:repiton/widgets/controll_list_widget.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  "Ученики",
                  style: TextStyle(
                    fontSize: 34,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(16),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddingAccountScreen(state: AddingState.student),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 23,
            ),
            Expanded(
              child: FutureBuilder(
                future: Provider.of<Teachers>(context, listen: false).fetchTeacherStudents(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Consumer<Teachers>(
                      builder: (context, teacher, child) => ListView.separated(
                        itemBuilder: (context, index) => ControllListWidget(
                          name: teacher.teachersStudents[index].lastName + " " + teacher.teachersStudents[index].name,
                          imageUrl: teacher.teachersStudents[index].imageUrl,
                          id: teacher.teachersStudents[index].id,
                          page: (id) => Container(),
                        ),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: teacher.teachersStudents.length,
                      ),
                    );
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
