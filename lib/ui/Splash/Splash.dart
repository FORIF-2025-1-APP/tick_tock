import 'package:flutter/material.dart';
import 'dart:async';
import '../Login/LoginPage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // 서버 구현 전이므로 3초 후 바로 LoginPage로 이동
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Icon(Icons.person, size: 64)));
  }
}
