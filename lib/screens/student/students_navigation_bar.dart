import 'package:flutter/material.dart';
import 'package:repiton/screens/main_screen.dart';
import 'package:repiton/screens/student/student_self_controll_info.dart';
import 'package:repiton/screens/student/student_timetable_screen.dart';

import '../settings_screen.dart';

class StudentsBottomNavigationController extends NavigationController {
  final List<Widget> _pages = [
    const StudentSelfControllInfo(),
    const StudentTimeTableScreen(),
    const SettingsScreen(),
  ];

  @override
  List<NavigationControllerButton> buttons = const [
    NavigationControllerButton(
      icon: Icon(Icons.stacked_bar_chart_outlined),
      focusIcon: Icon(Icons.stacked_bar_chart),
      title: "Успеваемость",
    ),
    NavigationControllerButton(
      icon: Icon(Icons.calendar_today_outlined),
      focusIcon: Icon(Icons.calendar_today),
      title: "Занятия",
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
