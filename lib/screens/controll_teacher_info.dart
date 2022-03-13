import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repiton/model/info_visualisation_state.dart';
import 'package:repiton/model/teacher.dart';
import 'package:repiton/provider/teachers.dart';
import 'package:repiton/widgets/controll_financinal_statistics_widget.dart';

class ControllTeacherInfo extends StatefulWidget {
  final String id;
  const ControllTeacherInfo({required this.id, Key? key}) : super(key: key);

  @override
  State<ControllTeacherInfo> createState() => _ControllTeacherInfoState();
}

class _ControllTeacherInfoState extends State<ControllTeacherInfo> {
  InfoVisualisationState state = InfoVisualisationState.week;
  late Teachers teachers;
  Teacher? teacher;

  Future<Teacher> getCachedTeacher() async {
    teacher ??= await teachers.findById(widget.id);
    return teacher!;
  }

  @override
  Widget build(BuildContext context) {
    teachers = Provider.of<Teachers>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                height: 23,
              ),
              FutureBuilder<Teacher>(
                future: getCachedTeacher(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Text(
                      snapshot.data!.lastName +
                          " " +
                          snapshot.data!.name +
                          " " +
                          snapshot.data!.fatherName,
                      style: const TextStyle(fontSize: 22),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 21,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          primary: state == InfoVisualisationState.week
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.zero,
                              bottomRight: Radius.zero,
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            state = InfoVisualisationState.week;
                          });
                        },
                        child: Text(
                          "Неделя",
                          style: TextStyle(
                            color: state != InfoVisualisationState.week
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          primary: state == InfoVisualisationState.month
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.zero,
                              topRight: Radius.zero,
                              bottomRight: Radius.zero,
                              bottomLeft: Radius.zero,
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            state = InfoVisualisationState.month;
                          });
                        },
                        child: Text(
                          "Месяц",
                          style: TextStyle(
                            color: state != InfoVisualisationState.month
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          primary: state == InfoVisualisationState.custom
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.zero,
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                              bottomLeft: Radius.zero,
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            state = InfoVisualisationState.custom;
                          });
                        },
                        child: Text(
                          "Выбрать...",
                          style: TextStyle(
                            color: state != InfoVisualisationState.custom
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ControllFinancinalStatisticsWidget(state: state),
            ],
          ),
        ),
      ),
    );
  }
}
