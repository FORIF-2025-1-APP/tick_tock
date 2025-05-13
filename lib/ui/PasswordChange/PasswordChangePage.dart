import 'package:flutter/material.dart';
import 'package:tick_tock/ui/core/themes/theme.dart';
import 'package:tick_tock/ui/core/ui/CustomInput.dart';
import 'package:tick_tock/ui/core/ui/CustomButton.dart';

class PasswordChangePage extends StatelessWidget {
  const PasswordChangePage({super.key});

  @override
  Widget build(BuildContext context) {
   
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀번호 변경'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Column(
          children: [
            // 기존 비밀번호
            CustomInput(
              controller: oldPassCtrl,
              labelText: 'Password',
          
              obscureText: true,
            ),
            const SizedBox(height: 16),

            // 새 비밀번호
            CustomInput(
              controller: newPassCtrl,
              labelText: 'New Password',
            
              obscureText: true,
            ),
            const SizedBox(height: 16),

            // 새 비밀번호 확인
            CustomInput(
              controller: confirmCtrl,
              labelText: 'New Password Confirm',
            
              obscureText: true,
            ),

            const Spacer(),

            // 검은색 완료 버튼
            CustomButton(
              type: ButtonType.black,
              onPressed: () {
                
              },
              child: const Text('완료'),
            ),
            const SizedBox(height: 8),

            // 흰색 탈퇴 버튼 (화면 아래쪽)
            CustomButton(
              type: ButtonType.white,
              onPressed: () {
                
              },
              child: const Text('탈퇴'),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const SettingApp());
}

class SettingApp extends StatelessWidget {
  const SettingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Setting Preview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: MediaQuery.platformBrightnessOf(context) == Brightness.light
            ? MaterialTheme.darkScheme().toColorScheme()
            : MaterialTheme.lightScheme().toColorScheme(),
      ),
      home: const PasswordChangePage(),
    );
  }
}