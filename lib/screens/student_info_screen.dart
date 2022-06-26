import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/model/discipline.dart';
import 'package:repiton/provider/auth.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/adding_discipline_screen.dart';
import 'package:repiton/utils/separated_list.dart';
import 'package:repiton/widgets/student_disciplines_info.dart';
import 'package:repiton/widgets/student_info.dart';

class StudentInfoScreen extends StatelessWidget {
  final String studentId;

  const StudentInfoScreen({required this.studentId, Key? key}) : super(key: key);

  Widget _studentInfoHeader(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(children: [
            const Text("Информация о пользователе", style: TextStyle(fontSize: 34), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            _studentInfoHeaderSubTitle(context),
          ]),
        ),
      );

  Widget _studentInfoHeaderSubTitle(BuildContext context) => Consumer(builder: (context, ref, _) {
        final studentInfoProvider = ref.watch(RootProvider.getStudentInfoProvider());

        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              const TextSpan(text: "Ученик ", style: TextStyle(fontSize: 18, color: Colors.grey)),
              TextSpan(text: studentInfoProvider.student?.fullName ?? "", style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.primary)),
            ],
          ),
        );
      });

  Widget _studentInfoHeaderAction(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [_studentInfoActionBackButton(context)],
      );

  Widget _studentInfoActionBackButton(BuildContext context) => IconButton(
        padding: const EdgeInsets.all(16),
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back),
      );

  Widget _buildScreen(BuildContext context) {
    if (MediaQuery.of(context).size.width < 1500) {
      return _tinyScreen(context);
    } else {
      return _wideScreen(context);
    }
  }

  Widget _tinyScreen(BuildContext context) => SeparatedList(
        children: [const StudentInfo(), const StudentDisciplinesInfo(), _studentTimeTable()],
        separatorBuilder: (_, __) => const Divider(),
      );

  Widget _wideScreen(BuildContext context) => Row(
        children: [
          const Expanded(child: SingleChildScrollView(child: StudentInfo())),
          const VerticalDivider(),
          Expanded(
            child: Column(
              children: [
                const Expanded(child: StudentDisciplinesInfo()),
                const Divider(),
                Expanded(child: _studentTimeTable()),
              ],
            ),
          )
        ],
      );

  Widget _studentTimeTable() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Занятия с учеником", style: TextStyle(fontSize: 22)),
              IconButton(icon: const Icon(Icons.add), onPressed: null),
            ],
          ),
          SingleChildScrollView(),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder(
            future: RootProvider.getStudentInfo().fetchAndSetStudentForInfo(studentId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    Stack(alignment: Alignment.center, children: [_studentInfoHeader(context), _studentInfoHeaderAction(context)]),
                    const SizedBox(height: 16),
                    Expanded(child: _buildScreen(context)),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
