import 'package:flutter/material.dart';
import 'package:repiton/screens/main_screen.dart';

class PhoneBottomNavigation extends StatelessWidget {
  final int pageIndex;
  final List<NavigationControllerButton> buttons;
  final Function(int) onPageChanged;
  const PhoneBottomNavigation({
    required this.pageIndex,
    required this.buttons,
    required this.onPageChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: pageIndex,
        items: buttons
            .map((buttom) => BottomNavigationBarItem(
                  icon: buttom.icon,
                  activeIcon: buttom.focusIcon,
                  label: buttom.title,
                ))
            .toList(),
        onTap: onPageChanged);
  }
}
