import 'package:flutter/material.dart';
import 'package:repiton/screens/main_screen.dart';
import 'package:repiton/screens/teacher/students_screen.dart';
import 'package:repiton/screens/teacher/timetable_screen.dart';

import '../settings_screen.dart';

class TeachersBottomNavigationController extends BottomNavigationController {
  final List<Widget> _pages = [
    const StudentsScreen(),
    const TimeTableScreen(),
    const SettingsScreen(),
  ];

  @override
  List<BottomNavigationBarItem> buttons = const [
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
  ];

  @override
  Widget getPage(int index) => _pages[index];
}
