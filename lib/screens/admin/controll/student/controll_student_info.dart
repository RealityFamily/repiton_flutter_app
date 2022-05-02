import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/model/info_visualisation_state.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/provider/admin/students_statistics.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/widgets/controll_learn_statistics_widget.dart';
import 'package:repiton/widgets/state_chooser.dart';

class ControllStudentInfo extends StatefulWidget {
  final String id;
  const ControllStudentInfo({required this.id, Key? key}) : super(key: key);

  @override
  State<ControllStudentInfo> createState() => _ControllTeacherInfoState();
}

class _ControllTeacherInfoState extends State<ControllStudentInfo> {
  InfoVisualisationState state = InfoVisualisationState.week;

  final List<String> _states = ["Неделя", "Месяц", "Выбрать..."];
  late String _state = _states[0];

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    FutureBuilder<Student>(
                      future: RootProvider.getStudentsStatistics().getCachedStudent(widget.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                          return RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Ученик ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                TextSpan(
                                  text: snapshot.data!.name + " " + snapshot.data!.lastName,
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
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
                    (() {
                      if (_states.indexOf(_state) == 0) {
                        return const ControllLearnStatisticsWidget(state: InfoVisualisationState.week);
                      } else if (_states.indexOf(_state) == 1) {
                        return const ControllLearnStatisticsWidget(state: InfoVisualisationState.month);
                      } else {
                        return const ControllLearnStatisticsWidget(state: InfoVisualisationState.custom);
                      }
                    }())
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
