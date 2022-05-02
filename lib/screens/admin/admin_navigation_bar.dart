import 'package:flutter/material.dart';
import 'package:repiton/screens/admin/users_screen.dart';

import '../settings_screen.dart';
import 'controll/controll_screen.dart';

class AdminsNavigationBar extends StatefulWidget {
  final Function(Widget?) onPageChanged;

  const AdminsNavigationBar({required this.onPageChanged, Key? key}) : super(key: key);

  @override
  State<AdminsNavigationBar> createState() => _AdminsNavigationBarState();
}

class _AdminsNavigationBarState extends State<AdminsNavigationBar> {
  int pageIndex = 1;

  final pages = [
    const UsersScreen(),
    const ControllScreen(),
    const SettingsScreen(),
  ];
  final buttons = const [
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
