import 'package:flutter/material.dart';

class JitsyActionButton extends StatefulWidget {
  final Function onPressed;
  final IconData icon;
  final IconData? iconAlt;
  final Color? background;
  final bool stateful;
  final bool initState;

  const JitsyActionButton({
    required this.icon,
    this.iconAlt,
    required this.onPressed,
    this.background,
    this.stateful = true,
    this.initState = false,
    Key? key,
  }) : super(key: key);

  @override
  State<JitsyActionButton> createState() => _JitsyActionButtonState();
}

class _JitsyActionButtonState extends State<JitsyActionButton> {
  late bool isActive;

  Color inactiveColor = const Color(0xFF4C4C4C);
  Color activeColor = Colors.white;

  Color get backgroundColor => (isActive ? activeColor : inactiveColor);
  Color get iconColor => (isActive ? inactiveColor : activeColor);

  @override
  void initState() {
    isActive = widget.initState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.stateful) {
          setState(() {
            isActive = !isActive;
          });
        }
        widget.onPressed();
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: widget.background ?? backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          widget.iconAlt != null ? (isActive ? widget.iconAlt : widget.icon) : widget.icon,
          color: iconColor,
        ),
      ),
    );
  }
}
