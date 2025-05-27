import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Login/LoginPage.dart';
import '../NavigationBar/CustomNavigationBar.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));

    final token = await storage.read(key: 'token');
    final autoLogin = await storage.read(key: 'autoLogin');

    if (!mounted) return;

    if (token != null && autoLogin == 'true') {
      // 로그인 상태 유지 → 홈으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CustomNavigationBar()),
      );
    } else {
      // 로그인 필요 → 로그인 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Icon(Icons.person, size: 64)));
  }
}
