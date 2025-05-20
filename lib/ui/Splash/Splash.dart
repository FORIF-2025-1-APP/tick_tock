import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../Login/LoginPage.dart';
import '../NavigationBar/CustomNavigationBar.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (!mounted) return; // context가 여전히 유효한지 확인

    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CustomNavigationBar()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Icon(Icons.person, size: 64)));
  }
}
