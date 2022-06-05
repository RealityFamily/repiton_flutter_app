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
  ];

  @override
  Widget getPage(int index) => _pages[index];
}
