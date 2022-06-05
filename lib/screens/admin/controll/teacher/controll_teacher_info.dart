import 'package:flutter/material.dart';
import 'package:repiton/model/info_visualisation_state.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/widgets/controll_financinal_statistics_widget.dart';
import 'package:repiton/widgets/state_chooser.dart';

class ControllTeacherInfo extends StatefulWidget {
  final String id;
  const ControllTeacherInfo({required this.id, Key? key}) : super(key: key);

  @override
  State<ControllTeacherInfo> createState() => _ControllTeacherInfoState();
}

class _ControllTeacherInfoState extends State<ControllTeacherInfo> {
  final List<String> _states = ["Неделя", "Месяц", "Выбрать..."];
  late String _state = _states[0];

  Widget _getContent() {
    if (_states.indexOf(_state) == 0) {
      return ControllFinancinalStatisticsWidget(state: InfoVisualisationState.week, key: ValueKey(_state));
    } else if (_states.indexOf(_state) == 1) {
      return ControllFinancinalStatisticsWidget(state: InfoVisualisationState.month, key: ValueKey(_state));
    } else {
      return ControllFinancinalStatisticsWidget(state: InfoVisualisationState.custom, key: ValueKey(_state));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Ведение",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 34,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      FutureBuilder<Teacher>(
                        future: RootProvider.getTearchersStatisctics().getCachedTeacher(widget.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                            return Text(
                              snapshot.data!.lastName + " " + snapshot.data!.name + " " + snapshot.data!.fatherName,
                              style: const TextStyle(fontSize: 22),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      StateChooser(
                        items: _states,
                        onStateChange: (state) {
                          setState(() {
                            _state = state;
                          });
                        },
                      ),
                      _getContent(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
