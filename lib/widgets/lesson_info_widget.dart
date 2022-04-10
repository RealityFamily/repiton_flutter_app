import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/provider/lessons.dart';
import 'package:repiton/screens/jitsy_call_screen.dart';

class LessonInfoWidget extends StatefulWidget {
  const LessonInfoWidget({Key? key}) : super(key: key);

  @override
  State<LessonInfoWidget> createState() => _LessonInfoWidgetState();
}

class _LessonInfoWidgetState extends State<LessonInfoWidget> {
  bool _isLoading = false;

  Widget getEditDialog() {
    String? result;
    GlobalKey<FormState> _formKey = GlobalKey();
    return AlertDialog(
      title: const Text("Введите описание к уроку"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          validator: (value) => value == null || value.isEmpty ? "Введите описание урока!" : null,
          onSaved: (_newValue) => result = _newValue,
          decoration: const InputDecoration(
            labelText: "Описание урока...",
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("ОТМЕНА"),
        ),
        TextButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            _formKey.currentState!.save();
            Navigator.of(context).pop(result);
          },
          child: const Text("ОК"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  "Описание",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  String? _newDescription = await showDialog<String>(
                    context: context,
                    builder: (context) => getEditDialog(),
                  );

                  if (_newDescription == null) return;
                  setState(() {
                    Provider.of<Lessons>(context, listen: false).lesson.description = _newDescription;
                  });
                },
                icon: const Icon(Icons.edit),
              )
            ],
          ),
        ),
        const Divider(
          color: Color(0xFFB4B4B4),
          thickness: 1,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Consumer<Lessons>(
                builder: (context, lessons, _) => Text(
                  lessons.lesson.description,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Divider(
          color: Color(0xFFB4B4B4),
          thickness: 1,
        ),
        const SizedBox(
          height: 14,
        ),
        Consumer<Lessons>(
          builder: (context, lessons, _) => _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  onPressed: () async {
                    if (lessons.lesson.jitsyLink == null) {
                      setState(() {
                        _isLoading = true;
                      });
                      await lessons.setJitsyLink();
                      setState(() {
                        _isLoading = false;
                      });
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const JitsyCallScreen(),
                        ),
                      );
                    }
                  },
                  child: Text(
                    lessons.lesson.jitsyLink == null ? "Начать занятие" : "Подключиться к занятию",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
