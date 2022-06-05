import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/provider/auth.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/admin/admin_navigation_bar.dart';
import 'package:repiton/screens/student/students_navigation_bar.dart';
import 'package:repiton/screens/teacher/teachers_navigation_bar.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  Widget? content;
  int pageIndex = 1;

  List<BottomNavigationBarItem> _getBottomNavigationControllerButtons(String role) {
    if (role == AuthProvider.adminRole) {
      return AdminsBottomNavigationController().buttons;
    } else if (role == AuthProvider.teacherRole) {
      return TeachersBottomNavigationController().buttons;
    } else if (role == AuthProvider.studentRole) {
      return StudentsBottomNavigationController().buttons;
    } else {
      throw Exception("[MainScreen] Unidentified user role - $role");
    }
  }

  Widget? _getBottomNavigationControllerNewContent(String role, int index) {
    if (role == AuthProvider.adminRole) {
      return AdminsBottomNavigationController().getPage(index);
    } else if (role == AuthProvider.teacherRole) {
      return TeachersBottomNavigationController().getPage(index);
    } else if (role == AuthProvider.studentRole) {
      return StudentsBottomNavigationController().getPage(index);
    } else {
      throw Exception("[MainScreen] Unidentified user role - $role");
    }
  }

  Widget _bottomNavBar(String role) {
    return BottomNavigationBar(
      currentIndex: pageIndex,
      items: _getBottomNavigationControllerButtons(role),
      onTap: (value) {
        final newContent = _getBottomNavigationControllerNewContent(role, value);
        setState(() {
          pageIndex = value;
          if (newContent != null) content = newContent;
        });
      },
    );
  }

  @override
  void initState() {
    content = _getBottomNavigationControllerNewContent(RootProvider.getAuth().userRole, pageIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(RootProvider.getAuthProvider());

    return Scaffold(
      bottomNavigationBar: _bottomNavBar(auth.userRole),
      body: content,
    );
  }
}

abstract class BottomNavigationController {
  List<BottomNavigationBarItem> get buttons;

  Widget getPage(int index);
}
