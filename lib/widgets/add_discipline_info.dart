import 'package:flutter/material.dart';
import 'package:repiton/model/discipline.dart';

class AddDisciplineInfo extends StatefulWidget {
  final Discipline result;
  final GlobalKey<FormState> formKey;

  const AddDisciplineInfo({required this.result, required this.formKey, Key? key}) : super(key: key);

  @override
  State<AddDisciplineInfo> createState() => _AddDisciplineInfoState();
}

class _AddDisciplineInfoState extends State<AddDisciplineInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Информация о проведении занятий",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Ставка",
                  suffixText: "₽ в час",
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return "Введите ставку";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  widget.result.price = double.parse(newValue!);
                },
              ),
            ),
            const SizedBox(
              width: 23,
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Количество занятий",
                  suffixText: "ч. в нед.",
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null) {
                    return "Введите количество занятий";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  widget.result.minutes = int.parse(newValue!);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
