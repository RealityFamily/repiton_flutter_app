import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/provider/auth.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/admin/admin_navigation_bar.dart';
import 'package:repiton/screens/admin/controll/controll_screen.dart';
import 'package:repiton/screens/settings_screen.dart';
import 'package:repiton/screens/student/students_navigation_bar.dart';
import 'package:repiton/screens/teacher/students_screen.dart';
import 'package:repiton/screens/teacher/teachers_navigation_bar.dart';
import 'package:repiton/screens/teacher/timetable_screen.dart';
import 'package:repiton/screens/admin/users_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  Widget? content;

  void contentChanged(Widget? newContent) {
    if (newContent == null) return;
    setState(() {
      content = newContent;
    });
  }

  Widget bottomNavigationBarOnRole(String role) {
    if (role == AuthProvider.adminRole) {
      return AdminsNavigationBar(onPageChanged: contentChanged);
    } else if (role == AuthProvider.teacherRole) {
      return TeachersNavigationBar(onPageChanged: contentChanged);
    } else if (role == AuthProvider.studentRole) {
      return StudentsNavigationBar(onPageChanged: contentChanged);
    } else {
      throw Exception("[MainScreen] Unidentified user role - $role");
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(RootProvider.getAuthProvider());

    return Scaffold(
      bottomNavigationBar: bottomNavigationBarOnRole(auth.userRole),
      body: content,
    );
  }
}
