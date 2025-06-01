import 'package:flutter/material.dart';
import './ui/Login/LoginPage.dart';
import './ui/NavigationBar/CustomNavigationBar.dart';
import './ui/Splash/Splash.dart';
import './ui/core/themes/theme.dart'; // 커스텀 테마가 있다면
import './ui/Splash/Splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            MediaQuery.platformBrightnessOf(context) == Brightness.light
                ? MaterialTheme.lightScheme().toColorScheme()
                : MaterialTheme.darkScheme().toColorScheme(),
      ),
      home: const Splash(), // 최초 로그인 화면
    );
  }
}
