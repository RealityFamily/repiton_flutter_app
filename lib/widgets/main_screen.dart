import 'package:flutter/material.dart';
import 'package:repiton/screens/adding_account.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final pages = [
    AddingAccount(),
    Container(),
    Container(),
  ];
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        items: const [
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
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
      ),
      body: pages[pageIndex],
    );
  }
}
