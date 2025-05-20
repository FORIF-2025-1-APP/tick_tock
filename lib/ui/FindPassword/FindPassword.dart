import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/ui/CustomButton.dart';
import '../core/ui/CustomInput.dart';

class FindPassword extends StatefulWidget {
  const FindPassword({super.key});

  @override
  State<FindPassword> createState() => _FindPasswordState();
}

class _FindPasswordState extends State<FindPassword> {
  final TextEditingController emailController = TextEditingController();
  final String serverUrl = 'https://example.com/api/auth/resetpassword';
  bool isLoading = false;

  Future<void> sendTempPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      showErrorDialog('입력 오류', '이메일을 입력해주세요.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      setState(() {
        isLoading = false;
      });

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        showResultDialog('성공', data['message']);
      } else {
        showResultDialog('오류', data['message'] ?? '요청에 실패했습니다.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog('네트워크 오류', '인터넷 연결을 확인해주세요.');
    }
  }

  void showResultDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  void showErrorDialog(String title, String message) {
    showResultDialog(title, message);
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingController, 이메일 전송 로직 등 추가 필요
    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: Text('비밀번호 찾기')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              CustomInput(labelText: 'Email', controller: emailController),
              Spacer(),
              CustomButton(
                type: ButtonType.black,
                child:
                    isLoading
                        ? CircularProgressIndicator()
                        : Text('임시 비밀번호 전송'),
                onPressed: isLoading ? null : sendTempPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
