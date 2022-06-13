import 'package:flutter/material.dart';
import 'package:repiton/screens/admin/users_screen.dart';
import 'package:repiton/screens/main_screen.dart';

import '../settings_screen.dart';
import 'controll/controll_screen.dart';

class AdminsBottomNavigationController extends NavigationController {
  final List<Widget> _pages = [
    const UsersScreen(),
    const ControllScreen(),
    const SettingsScreen(),
  ];

  @override
  List<NavigationControllerButton> buttons = const [
    NavigationControllerButton(
      icon: Icon(Icons.people_alt_outlined),
      focusIcon: Icon(Icons.people_alt),
      title: "Пользователи",
    ),
    NavigationControllerButton(
      icon: Icon(Icons.stacked_bar_chart_outlined),
      focusIcon: Icon(Icons.stacked_bar_chart),
      title: "Статистика",
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
