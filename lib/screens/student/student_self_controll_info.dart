import 'package:flutter/material.dart';
import 'package:repiton/model/info_visualisation_state.dart';
import 'package:repiton/model/student.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/widgets/controll_learn_statistics_widget.dart';
import 'package:repiton/widgets/state_chooser.dart';

class StudentSelfControllInfo extends StatefulWidget {
  const StudentSelfControllInfo({Key? key}) : super(key: key);

  @override
  State<StudentSelfControllInfo> createState() => _StudentSelfControllInfoState();
}

class _StudentSelfControllInfoState extends State<StudentSelfControllInfo> {
  final List<String> _states = ["Неделя", "Месяц", "Выбрать..."];
  late String _state = _states[0];

  void _setStudentForStatistic() async => RootProvider.getStudentsStatistics().student = await RootProvider.getStudents().cachedStudent();

  Widget _getContent() {
    if (_states.indexOf(_state) == 0) {
      return ControllLearnStatisticsWidget(state: InfoVisualisationState.week, key: ValueKey(_state));
    } else if (_states.indexOf(_state) == 1) {
      return ControllLearnStatisticsWidget(state: InfoVisualisationState.month, key: ValueKey(_state));
    } else {
      return ControllLearnStatisticsWidget(state: InfoVisualisationState.custom, key: ValueKey(_state));
    }
  }

  Widget get _controllHeader => const Text("Моя успеваемость", textAlign: TextAlign.center, style: TextStyle(fontSize: 34));

  @override
  void initState() {
    _setStudentForStatistic();
    super.initState();
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
              Container(width: double.infinity, alignment: Alignment.center, child: _controllHeader),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [StateChooser(items: _states, onStateChange: (state) => setState(() => _state = state)), _getContent()],
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
