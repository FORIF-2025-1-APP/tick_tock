
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tick_tock/ui/core/themes/theme.dart';
import 'package:tick_tock/ui/core/ui/CustomInput.dart';
import 'package:tick_tock/ui/core/ui/CustomButton.dart';
import 'package:tick_tock/ui/ChangeName/ChangeNameConfirm.dart';

// 닉네임 변경 요청 함수
// Future<void> changeNickname(String nickname) async {
//   final url = Uri.parse('https://forifitkokapi.seongjinemong.app/api/user/nickname');

//   try {
//     final response = await http.patch(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'nickname': nickname}),
//     );

//     if (response.statusCode == 200) {
//       print('닉네임 변경 성공');
//     } else {
//       print('실패: ${response.statusCode}');
//       print('응답: ${response.body}');
//     }
//   } catch (e) {
//     print('에러 발생: $e');
//   }
// }

class ChangeNamePage extends StatefulWidget {
  const ChangeNamePage({super.key});
  @override
  State<ChangeNamePage> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  final usernameCtrl = TextEditingController();

  @override
  void dispose() {
    usernameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('닉네임 변경'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomInput(
          controller: usernameCtrl,
          labelText: 'Username',
        ),

        const SizedBox(height: 600), 

        CustomButton(
          type: ButtonType.black,
          onPressed: () async {
            final nickname = usernameCtrl.text.trim();

            if (nickname.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('닉네임을 입력해주세요')),
              );
              return;
            }

            // await changeNickname(nickname);

            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('닉네임이 변경되었습니다')),
            // );

            Navigator.of(context).pop(nickname);
          },
          child: const Text('완료'),
        ),

        const SizedBox(height: 8),

        CustomButton(
          type: ButtonType.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChangeNameConfirmPage()),
            );
          },

          child: const Text('탈퇴'),
        ),
      ],
    ),
  ),
),
    );
  }
}