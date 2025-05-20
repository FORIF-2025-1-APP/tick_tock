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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked1 = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  final String serverUrl = 'https://example.com/api/auth';

  Future<void> login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      showErrorDialog('입력 오류', '아이디와 비밀번호를 모두 입력해주세요.');
      return;
    }

    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': usernameController.text,
          'password': passwordController.text,
        }),
      );
      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await saveTokenAndUserInfo(data['token'], data['user']);
          if (isChecked1) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('autoLogin', true);
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CustomNavigationBar()),
          );
        } else {
          showErrorDialog('로그인 실패', data['message'] ?? '로그인에 실패했습니다.');
        }
      } else {
        showErrorDialog('서버 에러', '서버에 문제가 발생했습니다.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog('네트워크 에러', '인터넷 연결을 확인해주세요.');
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.idToken == null) {
        setState(() {
          isLoading = false;
        });
        showErrorDialog('로그인 실패', '구글 인증 토큰을 가져오지 못했습니다.');
        return;
      }
      final response = await http.post(
        Uri.parse('$serverUrl/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': googleAuth.idToken}),
      );
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await saveTokenAndUserInfo(data['token'], data['user']);
          if (isChecked1) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('autoLogin', true);
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CustomNavigationBar()),
          );
        } else {
          showErrorDialog('로그인 실패', data['message'] ?? '구글 로그인에 실패했습니다.');
        }
      } else {
        showErrorDialog('서버 에러', '서버에 문제가 발생했습니다.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog('로그인 에러', '구글 로그인 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> saveTokenAndUserInfo(
    String token,
    Map<String, dynamic> user,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userId', user['id']);
    await prefs.setString('userEmail', user['email']);
    await prefs.setString('userNickname', user['nickname']);
  }

  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('확인'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
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
            Icon(Icons.person, size: 64),
            SizedBox(height: 32),
            CustomInput(labelText: 'Username', controller: usernameController),
            SizedBox(height: 16),
            CustomInput(
              labelText: 'Password',
              obscureText: true,
              controller: passwordController,
            ),
            SizedBox(height: 16),
            CustomButton(
              type: ButtonType.black,
              child: Text('로그인'),
              onPressed: login,
            ),
            SizedBox(height: 16),
            CustomButton(
              type: ButtonType.white,
              child: Text('Login with Google'),
              onPressed: signInWithGoogle,
            ),
            SizedBox(height: 16),
            CustomButton(
              type: ButtonType.white,
              child: Text('Login with Kakao'),
              onPressed: () {},
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
                    // 회원가입 화면으로 이동
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
                    // 비밀번호 찾기 화면으로 이동
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
