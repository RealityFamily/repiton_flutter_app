import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/adding_account_screen.dart';
import 'package:repiton/widgets/controll_list_widget.dart';
import 'package:repiton/widgets/state_chooser.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final List<String> _states = ["Преподаватели", "Ученики"];
  late String _state = _states[0];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  "Пользователи",
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
                            builder: (context) => AddingAccountScreen(
                                state: _states.indexOf(_state) == 0 ? AddingState.teacher : AddingState.student),
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
              height: 16,
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  labelText: "Поиск",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.cancel_outlined,
                    ),
                    onPressed: () {
                      debugPrint("Cancel search");
                    },
                  )),
            ),
            StateChooser(
              items: _states,
              onStateChange: (newValue) {
                setState(() {
                  _state = newValue;
                });
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: _states.indexOf(_state) == 1
                    ? RootProvider.getUsers().fetchStudents()
                    : RootProvider.getUsers().fetchTeachers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Consumer(
                      builder: (context, ref, _) {
                        final users = ref.watch(RootProvider.getUsersProvider());

                        return _states.indexOf(_state) == 1
                            ? ListView.separated(
                                itemBuilder: (context, index) => ControllListWidget(
                                  name: users.studentsList[index].lastName + " " + users.studentsList[index].name,
                                  imageUrl: users.studentsList[index].imageUrl,
                                  id: users.studentsList[index].id,
                                  // TODO: Change to Students info screen
                                  page: (id) => Container(),
                                ),
                                separatorBuilder: (context, index) => const Divider(),
                                itemCount: users.studentsList.length,
                              )
                            : ListView.separated(
                                itemBuilder: (context, index) => ControllListWidget(
                                  name: users.teachersList[index].lastName +
                                      " " +
                                      users.teachersList[index].name +
                                      " " +
                                      users.teachersList[index].fatherName,
                                  imageUrl: users.teachersList[index].imageUrl,
                                  id: users.teachersList[index].id,
                                  // TODO: Change to Teacher info screen
                                  page: (id) => Container(),
                                ),
                                separatorBuilder: (context, index) => const Divider(),
                                itemCount: users.teachersList.length,
                              );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
