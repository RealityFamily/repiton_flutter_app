import 'package:flutter/material.dart';
import 'package:repiton/provider/root_provider.dart';

abstract class LessonAction {
  final String title;
  final IconData icon;
  final Function() action;
  final bool? isActive;

  LessonAction({required this.title, required this.icon, required this.action, this.isActive});
}

class CancelLessonAction extends LessonAction {
  CancelLessonAction() : super(title: "Отменить занятие", icon: Icons.dnd_forwardslash, action: () => print("Отмена занятия"), isActive: false);
}

class MoveLessonAction extends LessonAction {
  MoveLessonAction() : super(title: "Перенести занятие", icon: Icons.move_down, action: () => print("Перенос занятия"), isActive: false);
}

class EndLessonAction extends LessonAction {
  EndLessonAction() : super(title: "Закончится занятие", icon: Icons.stop, action: () => RootProvider.getLessons().endLesson());
}
