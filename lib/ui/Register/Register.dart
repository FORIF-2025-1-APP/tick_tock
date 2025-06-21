import 'package:flutter/material.dart';
import '../core/ui/CustomButton.dart';
import '../core/ui/CustomInput.dart';
import '../core/ui/CustomCheckBox.dart';
import '../RegisterAllow/RegisterAllow.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isChecked = false;
  bool isEmailValid = false;
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  final String serverUrl = 'https://foriftiktokapi.seongjinemong.app/api/auth';

  Future<void> checkEmailDuplicate() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      showErrorDialog('입력 오류', '이메일을 입력해주세요.');
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      showErrorDialog('입력 오류', '유효한 이메일 형식이 아닙니다.');
      return;
    }
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/checkemail'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      setState(() => isLoading = false);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() => isEmailValid = true);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('확인 완료'),
            content: Text('사용 가능한 이메일입니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('확인'),
              ),
            ],
          ),
        );
      } else {
        setState(() => isEmailValid = false);
        showErrorDialog('중복 확인', data['message'] ?? '이미 사용 중인 이메일입니다.');
      }
    } catch (e) {
      setState(() => isLoading = false);
      showErrorDialog('네트워크 에러', '인터넷 연결을 확인해주세요.');
    }
  }

  Future<void> register() async {
    if (emailController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        passwordConfirmController.text.isEmpty) {
      showErrorDialog('입력 오류', '모든 필드를 입력해주세요.');
      return;
    }
    if (!isEmailValid) {
      showErrorDialog('입력 오류', '이메일 중복 확인을 해주세요.');
      return;
    }
    if (passwordController.text != passwordConfirmController.text) {
      showErrorDialog('입력 오류', '비밀번호가 일치하지 않습니다.');
      return;
    }
    if (!isChecked) {
      showErrorDialog('약관 동의', '약관에 동의해주세요.');
      return;
    }

    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'username': usernameController.text,
          'password': passwordController.text,
        }),
      );
      setState(() => isLoading = false);

      final data = jsonDecode(response.body);
      if (response.statusCode == 201 &&
          data['message'] == 'User created successfully') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('회원가입 성공'),
            content: Text('회원가입이 완료되었습니다. 로그인 페이지로 이동합니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('확인'),
              ),
            ],
          ),
        );
      } else {
        showErrorDialog('회원가입 실패', data['message'] ?? '회원가입에 실패했습니다.');
      }
    } catch (e) {
      setState(() => isLoading = false);
      showErrorDialog('네트워크 에러', '인터넷 연결을 확인해주세요.');
    }
  }

  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('확인'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(leading: BackButton(), title: Text('회원가입')),
//       resizeToAvoidBottomInset: true, // 키보드 올라올 때 자동 inset 조절
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               CustomInput(
//                 labelText: 'Email',
//                 controller: emailController,
//                 onChanged: (_) {
//                   if (isEmailValid) {
//                     setState(() => isEmailValid = false);
//                   }
//                 },
//               ),
//               SizedBox(height: 10),
//               CustomButton(
//                 type: ButtonType.white,
//                 child: Text('중복 확인'),
//                 onPressed: checkEmailDuplicate,
//               ),
//               SizedBox(height: 10),
//               CustomInput(
//                 labelText: 'Username',
//                 controller: usernameController,
//               ),
//               SizedBox(height: 10),
//               CustomInput(
//                 labelText: 'Password',
//                 obscureText: true,
//                 controller: passwordController,
//               ),
//               SizedBox(height: 10),
//               CustomInput(
//                 labelText: 'Password Confirm',
//                 obscureText: true,
//                 controller: passwordConfirmController,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CustomCheckBox(
//                     value: isChecked,
//                     type: CheckBoxType.label,
//                     onChanged: (val) => setState(() => isChecked = val!),
//                     label: 'Terms and Service 1',
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.arrow_forward),
//                     onPressed: () async {
//                       final result = await Navigator.push<bool>(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const RegisterAllow(),
//                         ),
//                       );
//                       if (result == true) {
//                         setState(() => isChecked = true);
//                       }
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(height: 40), // 버튼 위 여백
//               CustomButton(
//                 type: ButtonType.black,
//                 child: isLoading
//                     ? CircularProgressIndicator(color: Colors.white)
//                     : Text('회원가입'),
//                 onPressed: isLoading ? null : register,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: Text('회원가입')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              CustomInput(
                labelText: 'Email',
                controller: emailController,
                onChanged: (_) {
                  if (isEmailValid) {
                    setState(() => isEmailValid = false);
                  }
                },
              ),
              SizedBox(height: 10),
              CustomButton(
                type: ButtonType.white,
                child: Text('중복 확인'),
                onPressed: checkEmailDuplicate,
              ),
              SizedBox(height: 10),
              CustomInput(
                labelText: 'Username',
                controller: usernameController,
              ),
              SizedBox(height: 10),
              CustomInput(
                labelText: 'Password',
                obscureText: true,
                controller: passwordController,
              ),
              SizedBox(height: 10),
              CustomInput(
                labelText: 'Password Confirm',
                obscureText: true,
                controller: passwordConfirmController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomCheckBox(
                    value: isChecked,
                    type: CheckBoxType.label,
                    onChanged: (val) => setState(() => isChecked = val!),
                    label: 'Terms and Service 1',
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterAllow(),
                        ),
                      );
                      if (result == true) {
                        setState(() => isChecked = true);
                      }
                    },
                  ),
                ],
              ),
              Spacer(),
              CustomButton(
                type: ButtonType.black,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('회원가입'),
                onPressed: isLoading ? null : register,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
