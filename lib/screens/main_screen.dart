import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/provider/auth.dart';
import 'package:repiton/screens/adding_account_screen.dart';
import 'package:repiton/screens/controll_screen.dart';
import 'package:repiton/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final pages = {
    "ADMIN": [
      AddingAccountScreen(),
      const ControllScreen(),
      const SettingsScreen(),
    ],
    "TEACHER": [
      AddingAccountScreen(),
      const ControllScreen(),
      const SettingsScreen(),
    ],
    "STUDENT": [
      AddingAccountScreen(),
      const ControllScreen(),
      const SettingsScreen(),
    ],
  };
  final buttons = {
    "ADMIN": const [
      BottomNavigationBarItem(
        icon: Icon(Icons.add_outlined),
        activeIcon: Icon(Icons.add),
        label: "Добавление",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people_alt_outlined),
        activeIcon: Icon(Icons.people_alt),
        label: "Ведение",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings_outlined),
        activeIcon: Icon(Icons.settings),
        label: "Настроики",
      ),
    ],
    "TEACHER": const [
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
    ],
    "STUDENT": const [
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
    ],
  };
  int pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        items: buttons[auth.userRole[0]]!,
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
      ),
      body: pages[auth.userRole[0]]![pageIndex],
    );
  }
}
