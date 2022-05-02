import 'package:flutter/material.dart';
import 'package:repiton/screens/teacher/students_screen.dart';
import 'package:repiton/screens/teacher/timetable_screen.dart';

import '../settings_screen.dart';

class TeachersNavigationBar extends StatefulWidget {
  final Function(Widget?) onPageChanged;

  const TeachersNavigationBar({required this.onPageChanged, Key? key}) : super(key: key);

  @override
  State<TeachersNavigationBar> createState() => _TeachersNavigationBarState();
}

class _TeachersNavigationBarState extends State<TeachersNavigationBar> {
  int pageIndex = 1;

  final pages = [
    const StudentsScreen(),
    const TimeTableScreen(),
    const SettingsScreen(),
  ];
  final buttons = const [
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
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: pageIndex,
      items: buttons,
      onTap: (value) {
        setState(() {
          pageIndex = value;
        });
        widget.onPageChanged(pages[pageIndex]);
      },
    );
  }
}
