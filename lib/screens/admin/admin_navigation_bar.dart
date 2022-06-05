import 'package:flutter/material.dart';
import 'package:repiton/screens/admin/users_screen.dart';
import 'package:repiton/screens/main_screen.dart';

import '../settings_screen.dart';
import 'controll/controll_screen.dart';

class AdminsBottomNavigationController extends BottomNavigationController {
  final List<Widget> _pages = [
    const UsersScreen(),
    const ControllScreen(),
    const SettingsScreen(),
  ];

  @override
  List<BottomNavigationBarItem> buttons = const [
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
  ];

  @override
  Widget getPage(int index) => _pages[index];
}
