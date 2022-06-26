import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:repiton/screens/student_info_screen.dart';

class TeacherStudentsElementWidget extends StatelessWidget {
  final String studentId;
  final String studentName;
  final String disciplineName;
  final DateTime? nearestLessonDateTime;

  const TeacherStudentsElementWidget({
    required this.studentId,
    required this.studentName,
    required this.disciplineName,
    this.nearestLessonDateTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => StudentInfoScreen(studentId: studentId))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(studentName, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 10),
                Text(disciplineName, style: const TextStyle(fontSize: 16)),
              ],
            ),
            if (nearestLessonDateTime != null)
              Column(
                children: [
                  Text(DateFormat("HH:mm").format(nearestLessonDateTime!), style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text(DateFormat("dd.MM").format(nearestLessonDateTime!), style: const TextStyle(fontSize: 18)),
                ],
              )
          ],
        ),
      ),
    );
  }
}
