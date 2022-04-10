import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:repiton/provider/auth.dart';
import 'package:repiton/provider/students.dart';
import 'package:repiton/provider/teachers.dart';
import 'package:repiton/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Teachers>(
          create: (context) => Teachers.empty(),
          update: (context, auth, prevTeachers) => Teachers(
            prevTeachers: prevTeachers!.teachers,
            authToken: auth.authToken,
            userRole: auth.userRole,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Students>(
          create: (context) => Students.empty(),
          update: (context, auth, prevStudents) => Students(
            prevStudents: prevStudents!.students,
            authToken: auth.authToken,
            userRole: auth.userRole,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF393939),
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ru')],
        home: const MainScreen(),
      ),
    );
  }
}
