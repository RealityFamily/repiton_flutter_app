import 'package:flutter/material.dart';
import 'package:repiton/screens/main_screen.dart';

import '../settings_screen.dart';

class StudentsBottomNavigationController extends BottomNavigationController {
  final List<Widget> _pages = [
    Container(),
    Container(),
    const SettingsScreen(),
  ];

  @override
  List<BottomNavigationBarItem> buttons = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.stacked_bar_chart_outlined),
      activeIcon: Icon(Icons.stacked_bar_chart),
      label: "Успеваемость",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.calendar_today_outlined),
      activeIcon: Icon(Icons.calendar_today),
      label: "Занятия",
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
