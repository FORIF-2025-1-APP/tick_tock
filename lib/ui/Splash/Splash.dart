import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../Login/LoginPage.dart';
import '../NavigationBar/CustomNavigationBar.dart';
import 'package:tick_tock/config/auth_session.dart';

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
    final autoLogin = prefs.getBool('autoLogin') ?? false;

    if (!mounted) return;

    if (token != null && autoLogin) {
      AuthSession.token = token;
      AuthSession.userId = prefs.getString('userId');
      AuthSession.email = prefs.getString('userEmail');
      AuthSession.nickname = prefs.getString('userNickname');

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
