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

  Widget _getSideBarMenuButton(NavigationControllerButton button, int index) {
    final isSelected = index == pageIndex;

    return InkWell(
      onTap: () => onPageChanged(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: isSelected ? Colors.grey[100] : Colors.transparent,
        child: Row(
          children: [
            isSelected ? button.focusIcon : button.icon,
            const SizedBox(width: 16),
            Text(button.title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Repiton", style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => _getSideBarMenuButton(buttons[index], index),
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemCount: buttons.length,
          )
        ],
      ),
    );
  }
}
