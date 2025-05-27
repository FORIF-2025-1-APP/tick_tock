import 'package:flutter/material.dart';
import 'package:tick_tock/ui/core/themes/theme.dart';
import 'package:tick_tock/ui/core/ui/CustomInput.dart';
import 'package:tick_tock/ui/core/ui/CustomButton.dart';
import 'package:tick_tock/ui/core/ui/CustomChips.dart';
import 'package:tick_tock/ui/Login/LoginPage.dart';
import 'package:http/http.dart' as http;

Future<void> deleteUser() async {
  final url = Uri.parse('https://forifitkokapi.seongjinemong.app/api/user');

  try {
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('회원 탈퇴 성공');
    } else {
      print('탈퇴 실패: ${response.statusCode}');
      print('응답: ${response.body}');
    }
  } catch (e) {
    print('에러 발생: $e');
  }
}


class ChangeNameConfirmPage extends StatelessWidget {
  const ChangeNameConfirmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.inversePrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '정말 탈퇴 하시겠어요?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '절 버리시면',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              
              Center(
                child: Image.asset(
                  'assets/images/cutyseed.png',
                  height: 100,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '슬퍼요…',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('취소'),
                  ),
                  const SizedBox(width: 8),
         TextButton(
  onPressed: () async {
    await deleteUser();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('탈퇴가 완료되었습니다')),
    );

   
   Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  },
  child: Text(
    '탈퇴',
    style: TextStyle(color: colors.error),
  ),
),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

