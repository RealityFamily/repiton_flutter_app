import 'package:flutter/material.dart';

import '../settings_screen.dart';

class StudentsNavigationBar extends StatefulWidget {
  final Function(Widget?) onPageChanged;
  static Widget get initPage => Container();

  const StudentsNavigationBar({required this.onPageChanged, Key? key}) : super(key: key);

  @override
  State<StudentsNavigationBar> createState() => _StudentsNavigationBarState();
}

class _StudentsNavigationBarState extends State<StudentsNavigationBar> {
  int pageIndex = 1;

  final pages = [
    Container(),
    Container(),
    const SettingsScreen(),
  ];
  final buttons = const [
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
