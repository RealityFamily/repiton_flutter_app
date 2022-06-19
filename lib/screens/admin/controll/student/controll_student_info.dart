import 'package:flutter/material.dart';
import 'package:repiton/model/info_visualisation_state.dart';
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
  final List<String> _states = ["Неделя", "Месяц", "Выбрать..."];
  late String _state = _states[0];
  bool isLoading = false;
  String? studentFullName;

  Widget _getContent() {
    if (_states.indexOf(_state) == 0) {
      return ControllLearnStatisticsWidget(state: InfoVisualisationState.week, key: ValueKey(_state));
    } else if (_states.indexOf(_state) == 1) {
      return ControllLearnStatisticsWidget(state: InfoVisualisationState.month, key: ValueKey(_state));
    } else {
      return ControllLearnStatisticsWidget(state: InfoVisualisationState.custom, key: ValueKey(_state));
    }
  }

  void _getStudentFullName() async {
    setState(() => isLoading = true);
    final fullName = (await RootProvider.getStudentsStatistics().getCachedStudent(widget.id)).fullName;
    setState(() {
      isLoading = false;
      studentFullName = fullName;
    });
  }

  Widget get _controllHeader {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Ведение", textAlign: TextAlign.center, style: TextStyle(fontSize: 34)),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(text: "Ученик ", style: TextStyle(fontSize: 18, color: Colors.grey)),
                TextSpan(text: studentFullName, style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.primary)),
              ],
            ),
          ),
        ],
      );
    }
  }

  @override
  void initState() {
    _getStudentFullName();
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
              SizedBox(
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(width: double.infinity, alignment: Alignment.center, child: _controllHeader),
                    IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back)),
                  ],
                ),
              ),
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
