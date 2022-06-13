import 'package:flutter/material.dart';
import 'package:repiton/screens/main_screen.dart';

class SideBarMenu extends StatelessWidget {
  final int pageIndex;
  final List<NavigationControllerButton> buttons;
  final Function(int) onPageChanged;

  const SideBarMenu({
    required this.pageIndex,
    required this.buttons,
    required this.onPageChanged,
    Key? key,
  }) : super(key: key);

  Widget _getSideBarMenuButton(NavigationControllerButton button, bool isSelected) {
    return Container(
      child: Row(
        children: [isSelected ? button.focusIcon : button.icon, const SizedBox(width: 8), Text(button.title)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text("Repiton"),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => _getSideBarMenuButton(buttons[index], index == pageIndex),
            itemCount: buttons.length,
          )
        ],
      ),
    );
  }
}
