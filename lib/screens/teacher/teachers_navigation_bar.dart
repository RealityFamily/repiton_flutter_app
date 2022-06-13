import 'package:flutter/material.dart';
import 'package:repiton/screens/main_screen.dart';
import 'package:repiton/screens/teacher/students_screen.dart';
import 'package:repiton/screens/teacher/timetable_screen.dart';

import '../settings_screen.dart';

class TeachersBottomNavigationController extends NavigationController {
  final List<Widget> _pages = [
    const StudentsScreen(),
    const TimeTableScreen(),
    const SettingsScreen(),
  ];

  @override
  List<NavigationControllerButton> buttons = const [
    NavigationControllerButton(
      icon: Icon(Icons.people_alt_outlined),
      focusIcon: Icon(Icons.people_alt),
      title: "Ученики",
    ),
    NavigationControllerButton(
      icon: Icon(Icons.calendar_today_outlined),
      focusIcon: Icon(Icons.calendar_today),
      title: "Расписание",
    ),
    NavigationControllerButton(
      icon: Icon(Icons.settings_outlined),
      focusIcon: Icon(Icons.settings),
      title: "Настроики",
    ),
  ];

  @override
  Widget getPage(int index) => _pages[index];
}
