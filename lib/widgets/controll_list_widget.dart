import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repiton/screens/controll_screen.dart';
import 'package:repiton/screens/controll_student_info.dart';
import 'package:repiton/screens/controll_teacher_info.dart';

class ControllListWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String id;
  final ControllState state;

  const ControllListWidget({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          imageUrl,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => state == ControllState.teacher
                ? ControllTeacherInfo(
                    id: id,
                  )
                : ControllStudentInfo(
                    id: id,
                  ),
          ),
        );
      },
    );
  }
}
