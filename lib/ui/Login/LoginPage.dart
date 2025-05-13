import 'package:flutter/material.dart';
import '../core/ui/CustomButton.dart';
import '../core/ui/CustomInput.dart';
import '../core/ui/CustomCheckBox.dart';
import '../Register/Register.dart';
import '../FindPassword/FindPassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked1 = false;

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
            CustomInput(labelText: 'Username'),
            SizedBox(height: 16),
            CustomInput(labelText: 'Password', obscureText: true),
            SizedBox(height: 16),
            CustomButton(
              type: ButtonType.black,
              child: Text('로그인'),
              onPressed: () {},
            ),
            SizedBox(height: 16),
            CustomButton(
              type: ButtonType.white,
              child: Text('Login with Google'),
              onPressed: () {},
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
