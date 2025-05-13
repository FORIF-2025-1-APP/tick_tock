import 'package:flutter/material.dart';
import 'package:tick_tock/ui/core/themes/theme.dart';


class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},   // 뒤로가기 동작 없음 (디자인용)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              '닉네임 변경',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 30),
            const Text(
              '비밀번호 변경',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '알림 설정',
                  style: TextStyle(fontSize: 14),
                ),
                Switch(
                  value: false,
                  onChanged: null, 
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    '로그아웃',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    '탈퇴하기',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
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
      home: const SettingPage(),
    );
  }
}