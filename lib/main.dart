import 'package:flutter/material.dart';
import 'package:repiton/widgets/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF393939),
        ),
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const MainScreen(),
    );
  }
}
