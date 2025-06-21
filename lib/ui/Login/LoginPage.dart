import 'package:flutter/material.dart';
import '../core/ui/CustomButton.dart';
import '../core/ui/CustomInput.dart';
import '../core/ui/CustomCheckBox.dart';
import '../Register/Register.dart';
import '../FindPassword/FindPassword.dart';
import '../NavigationBar/CustomNavigationBar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:tick_tock/config/auth_session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked1 = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading1 = false;
  bool isLoading2 = false;

  final String serverUrl = 'https://foriftiktokapi.seongjinemong.app/api/auth';

  Future<void> login() async {
    final storage = const FlutterSecureStorage();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showErrorDialog('입력 오류', '이메일과 비밀번호를 모두 입력해주세요.');
      return;
    }

    setState(() => isLoading1 = true);

    try {
      final response = await http.post(
        Uri.parse('$serverUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      setState(() => isLoading1 = false);

      final data = jsonDecode(response.body);

      if (isChecked1) {
        await storage.write(key: 'autoLogin', value: 'true');
      }

      if (response.statusCode == 200 && data['token'] != null) {
        final token = json.decode(response.body)['token'];
        await storage.write(key: 'auth_token', value: token);

        // AuthSession.token = data['token'];
        // AuthSession.userId = data['user']['id'];
        // AuthSession.email = data['user']['email'];
        // AuthSession.nickname = data['user']['nickname'];

        // if (isChecked1) {
        //   final prefs = await SharedPreferences.getInstance();
        //   await prefs.setString('token', data['token']);
        //   await prefs.setBool('autoLogin', true);
        //   await prefs.setString('userId', data['user']['id']);
        //   await prefs.setString('userEmail', data['user']['email']);
        //   await prefs.setString('userNickname', data['user']['nickname']);
        // }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CustomNavigationBar()),
        );
      } else if (response.statusCode == 401) {
        showErrorDialog('로그인 실패', '이메일 또는 비밀번호가 잘못되었습니다.');
      } else {
        showErrorDialog('서버 에러', data['message'] ?? '서버 응답 오류');
      }
    } catch (e) {
      setState(() => isLoading1 = false);
      showErrorDialog('네트워크 에러', '인터넷 연결을 확인해주세요.');
    }
  }

  Future<void> signInWithGoogle() async {
    final storage = const FlutterSecureStorage();
    setState(() => isLoading2 = true);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'openid', 'profile'],
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => isLoading2 = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('😃😄😁😆😅🤣😂 ${googleAuth.accessToken}');

      if (googleAuth.accessToken == null) {
        setState(() => isLoading2 = false);
        showErrorDialog('로그인 실패', '구글 인증 토큰을 가져오지 못했습니다.');
        return;
      }

      final response = await http.post(
        Uri.parse('$serverUrl/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': googleAuth.accessToken}),
      );

      setState(() => isLoading2 = false);

      final data = jsonDecode(response.body);

      if (isChecked1) {
        await storage.write(key: 'autoLogin', value: 'true');
      }

      if (response.statusCode == 200 && data['token'] != null) {
        final token = json.decode(response.body)['token'];
        await storage.write(key: 'auth_token', value: token);
        // AuthSession.token = data['token'];
        // AuthSession.userId = data['user']['id'];
        // AuthSession.email = data['user']['email'];
        // AuthSession.nickname = data['user']['nickname'];

        // if (isChecked1) {
        //   final prefs = await SharedPreferences.getInstance();
        //   await prefs.setString('token', data['token']);
        //   await prefs.setBool('autoLogin', true);
        //   await prefs.setString('userId', data['user']['id']);
        //   await prefs.setString('userEmail', data['user']['email']);
        //   await prefs.setString('userNickname', data['user']['nickname']);
        // }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CustomNavigationBar()),
        );
      } else {
        showErrorDialog('구글 로그인 실패', data['message'] ?? '실패');
      }
    } catch (e) {
      setState(() => isLoading2 = false);
      showErrorDialog('로그인 에러', '구글 로그인 중 오류 발생: $e');
    }
  }

  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png', // ← 실제 경로
              width: 150,
              height: 150,
            ),
            CustomInput(labelText: 'Email', controller: emailController),
            SizedBox(height: 16),
            CustomInput(
              labelText: 'Password',
              obscureText: true,
              controller: passwordController,
            ),
            SizedBox(height: 16),
            CustomButton(
              type: ButtonType.black,
              child: isLoading1
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('로그인'),
              onPressed: login,
            ),
            SizedBox(height: 16),
            CustomButton(
              type: ButtonType.white,
              child: isLoading2
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Login with Google'),
              onPressed: signInWithGoogle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomCheckBox(
                  value: isChecked1,
                  type: CheckBoxType.label,
                  onChanged: (val) => setState(() => isChecked1 = val!),
                  label: '자동 로그인',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text('회원가입'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  },
                ),
                Text('|'),
                TextButton(
                  child: Text('비밀번호 찾기'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FindPassword()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
