import 'package:flutter/material.dart';

class StateChooser extends StatefulWidget {
  final List<String> items;
  final Function(String) onStateChange;

  const StateChooser({
    required this.items,
    required this.onStateChange,
    Key? key,
  }) : super(key: key);

  @override
  State<StateChooser> createState() => _StateChooserState();
}

class _StateChooserState extends State<StateChooser> {
  late String state;

  @override
  void initState() {
    super.initState();
    state = widget.items[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 21,
      ),
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color: Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: widget.items
            .map(
              (value) => Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    primary: state == value ? Theme.of(context).colorScheme.primary : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: widget.items.indexOf(value) == 0 ? const Radius.circular(8) : Radius.zero,
                        topRight: widget.items.indexOf(value) == (widget.items.length - 1) ? const Radius.circular(8) : Radius.zero,
                        bottomRight: widget.items.indexOf(value) == (widget.items.length - 1) ? const Radius.circular(8) : Radius.zero,
                        bottomLeft: widget.items.indexOf(value) == 0 ? const Radius.circular(8) : Radius.zero,
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      state = value;
                    });
                    widget.onStateChange(state);
                  },
                  child: Text(
                    value,
                    style: TextStyle(
                      color: state != value ? Theme.of(context).colorScheme.primary : Colors.white,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
