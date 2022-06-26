import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/model/admin.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/auth_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Widget _getUserNameAndRoleFromRole(String userRole) {
    return FutureBuilder<Object?>(
      future: RootProvider.getAuth().cachedUserInfo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          late String userName;
          late String userRole;

          if (snapshot.data is Admin) {
            userName = (snapshot.data as Admin).fullName;
            userRole = "Администратор";
          } else if (snapshot.data is Teacher) {
            userName = (snapshot.data as Teacher).fullName;
            userRole = "Преподаватель";
          } else if (snapshot.data is Student) {
            userName = (snapshot.data as Student).fullName;
            userRole = "Ученик";
          }

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(text: userName, style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.primary)),
                TextSpan(text: "\n" + userRole, style: const TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _logout(BuildContext context) async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthScreen()));
    RootProvider.getAuth().logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _auth = ref.watch(RootProvider.getAuthProvider());

    return SafeArea(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Настройки",
                    style: TextStyle(fontSize: 34),
                  )
                ],
              ),
              if (_auth.isMultiRoleUser)
                IconButton(
                  padding: const EdgeInsets.all(16),
                  onPressed: () => _auth.changeRoles(),
                  icon: const Icon(Icons.change_circle_outlined),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _getUserNameAndRoleFromRole(_auth.userRole),
                  Expanded(child: Container()),
                  TextButton(onPressed: () => _logout(context), child: const Text("Выход")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
