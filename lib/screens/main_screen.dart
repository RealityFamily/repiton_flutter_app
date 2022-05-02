import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/provider/auth.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/admin/controll/controll_screen.dart';
import 'package:repiton/screens/settings_screen.dart';
import 'package:repiton/screens/teacher/students_screen.dart';
import 'package:repiton/screens/teacher/timetable_screen.dart';
import 'package:repiton/screens/admin/users_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final pages = {
    AuthProvider.adminRole: [
      const UsersScreen(),
      const ControllScreen(),
      const SettingsScreen(),
    ],
    AuthProvider.teacherRole: [
      const StudentsScreen(),
      const TimeTableScreen(),
      const SettingsScreen(),
    ],
    AuthProvider.studentRole: [
      Container(),
      Container(),
      const SettingsScreen(),
    ],
  };
  final buttons = {
    AuthProvider.adminRole: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.people_alt_outlined),
        activeIcon: Icon(Icons.people_alt),
        label: "Пользователи",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.stacked_bar_chart_outlined),
        activeIcon: Icon(Icons.stacked_bar_chart),
        label: "Статистика",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings_outlined),
        activeIcon: Icon(Icons.settings),
        label: "Настроики",
      ),
    ],
    AuthProvider.teacherRole: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.people_alt_outlined),
        activeIcon: Icon(Icons.people_alt),
        label: "Ученики",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today_outlined),
        activeIcon: Icon(Icons.calendar_today),
        label: "Расписание",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings_outlined),
        activeIcon: Icon(Icons.settings),
        label: "Настроики",
      ),
    ],
    AuthProvider.studentRole: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.add_outlined),
        activeIcon: Icon(Icons.add),
        label: "Добавление",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people_alt_outlined),
        activeIcon: Icon(Icons.people),
        label: "Ведение",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings_outlined),
        activeIcon: Icon(Icons.settings),
        label: "Настроики",
      ),
    ],
  };
  int pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(RootProvider.getAuthProvider);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        items: buttons[auth.userRole[0]]!,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
      ),
      body: pages[auth.userRole[0]]![pageIndex],
    );
  }
}
