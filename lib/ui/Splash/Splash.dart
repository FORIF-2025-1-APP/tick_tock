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
    return Scaffold(
      backgroundColor: Colors.white, // 배경 흰색
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 이미지
            Image.asset(
              'assets/images/logo.png', // ← 실제 경로
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),

            // "TICK TOCK" 텍스트
            const Text(
              'TICK TOCK',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF678D58), // 녹색 계열 HEX
              ),
            ),
            const SizedBox(height: 8),

            // 설명 텍스트
            const Text(
              '스마트한 일정 관리 플랫폼',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
