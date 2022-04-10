import 'package:flutter/material.dart';
import 'package:repiton/model/home_task.dart';
import 'package:repiton/widgets/choose_test_widget.dart';
import 'package:repiton/widgets/create_task_widget.dart';
import 'package:repiton/widgets/state_chooser.dart';

class CreateHometaskScreen extends StatefulWidget {
  const CreateHometaskScreen({Key? key}) : super(key: key);

  @override
  State<CreateHometaskScreen> createState() => _CreateHometaskScreenState();
}

class _CreateHometaskScreenState extends State<CreateHometaskScreen> {
  final HomeTask _homeTask = HomeTask.empty();

  void creationHomeTaskCallBack(HomeTask? newHomeTask) {
    if (newHomeTask == null) return;

    // TODO: Send hometask to server

    Navigator.of(context).pop(newHomeTask);
  }

  final List<String> _states = ["Задание", "Тест"];
  late String _state = _states[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 8.0,
                    left: 56,
                    right: 56,
                  ),
                  child: Text(
                    "Создать домашнее задание",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                    ),
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.all(16),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: StateChooser(
                items: _states,
                onStateChange: (newState) {
                  setState(() {
                    _state = newState;
                  });
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: (() {
                  if (_state == _states[0]) {
                    return CreateTaskWidget(
                      callBack: creationHomeTaskCallBack,
                    );
                  } else {
                    return const ChooseTestWidget();
                  }
                }()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
