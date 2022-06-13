import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:repiton/provider/auth.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/auth_screen.dart';
import 'package:repiton/screens/main_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  Future<void> get _minSplashTimeout => Future.delayed(const Duration(milliseconds: 300));

  Future<bool> get _isAuth => RootProvider.getAuth().isAuthenticated();

  void _moveToInitPage(BuildContext context) async {
    bool isAuth = (await Future.wait<dynamic>([_isAuth, _minSplashTimeout]))[0];

    if (!isAuth) RootProvider.getAuth().logout();

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => isAuth ? const MainScreen() : const AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _moveToInitPage(context));

    return Container();
  }
}
