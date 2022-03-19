import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateChooser extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime?) callBack;

  const DateChooser({
    required this.firstDate,
    required this.lastDate,
    required this.callBack,
    Key? key,
  }) : super(key: key);

  @override
  State<DateChooser> createState() => _DateChooserState();
}

class _DateChooserState extends State<DateChooser> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _choosedDate;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(
        suffixIcon: Icon(
          Icons.keyboard_arrow_down,
        ),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? _pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now().isBefore(widget.lastDate)
              ? DateTime.now()
              : widget.lastDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          locale: const Locale("ru"),
        );

        if (_pickedDate != null) {
          String formattedDate = DateFormat('dd.MM.yyyy').format(_pickedDate);
          _controller.text = formattedDate;

          setState(() {
            _choosedDate = _pickedDate;
          });

          widget.callBack(_choosedDate);
        }
      },
    );
  }
}
