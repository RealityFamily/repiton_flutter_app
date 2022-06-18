import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/provider/auth.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/admin/admin_navigation_bar.dart';
import 'package:repiton/screens/student/students_navigation_bar.dart';
import 'package:repiton/screens/teacher/teachers_navigation_bar.dart';
import 'package:repiton/widgets/bottom_navigation.dart';
import 'package:repiton/widgets/side_bar_menu.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  Widget? content;
  int pageIndex = 1;

  List<NavigationControllerButton> _getBottomNavigationControllerButtons(String role) {
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

  void _onPageChanged(int newPage, String role) {
    final newContent = _getBottomNavigationControllerNewContent(role, newPage);
    setState(() {
      pageIndex = newPage;
      if (newContent != null) content = newContent;
    });
  }

  @override
  void initState() {
    content = _getBottomNavigationControllerNewContent(RootProvider.getAuth().userRole, pageIndex);
    super.initState();
  }

  double get sideBarWidth => MediaQuery.of(context).size.width * 0.25;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(RootProvider.getAuthProvider());

    if (kIsWeb) {
      return Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: sideBarWidth,
              constraints: const BoxConstraints(minWidth: 200, maxWidth: 300),
              child: SideBarMenu(
                pageIndex: pageIndex,
                buttons: _getBottomNavigationControllerButtons(auth.userRole),
                onPageChanged: (newPage) => _onPageChanged(newPage, auth.userRole),
              ),
            ),
            const VerticalDivider(),
            Expanded(child: content ?? Container())
          ],
        ),
      );
    } else {
      return Scaffold(
        bottomNavigationBar: PhoneBottomNavigation(
          pageIndex: pageIndex,
          buttons: _getBottomNavigationControllerButtons(auth.userRole),
          onPageChanged: (newPage) => _onPageChanged(newPage, auth.userRole),
        ),
        body: content,
      );
    }
  }
}

abstract class NavigationController {
  List<NavigationControllerButton> get buttons;

  Widget getPage(int index);
}

class NavigationControllerButton {
  final String title;
  final Icon icon;
  final Icon focusIcon;

  const NavigationControllerButton({required this.title, required this.icon, required this.focusIcon});
}
