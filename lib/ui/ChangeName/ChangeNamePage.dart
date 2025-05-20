import 'package:flutter/material.dart';
import 'package:tick_tock/ui/core/themes/theme.dart';
import 'package:tick_tock/ui/core/ui/CustomInput.dart';
import 'package:tick_tock/ui/core/ui/CustomButton.dart';
import 'package:tick_tock/ui/core/ui/CustomChips.dart';


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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:40, vertical: 20),
        child: Column(
          children: [
            // 입력필드
            CustomInput(
              controller: usernameCtrl,
              labelText: 'Username',
              
            ),

            const Spacer(),

            // 완료 버튼 (검은색)
            CustomButton(
              type: ButtonType.black,
              onPressed: () {
                
              },
              child: const Text('완료'),
            ),
            const SizedBox(height: 8),

            // 탈퇴 버튼 (흰색)
            CustomButton(
              type: ButtonType.white,
              onPressed: () {
                
              },
              child: const Text('탈퇴'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}




