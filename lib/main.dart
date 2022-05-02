import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:repiton/core/app_init.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repiton/provider/root_provider.dart';
import 'package:repiton/screens/auth_screen.dart';
import 'package:repiton/screens/main_screen.dart';

void main() async {
  await preInit();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    final auth = ref.watch(RootProvider.getAuthProvider());

    return MaterialApp(
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
      home: auth.isAuthenticated ? const MainScreen() : AuthScreen(),
    );
  }
}
