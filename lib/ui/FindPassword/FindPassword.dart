import 'package:flutter/material.dart';
import '../core/ui/CustomButton.dart';
import '../core/ui/CustomInput.dart';

class FindPassword extends StatelessWidget {
  const FindPassword({super.key});

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
              CustomInput(labelText: 'Email'),
              Spacer(),
              CustomButton(
                type: ButtonType.black,
                child: Text('임시 비밀번호 전송'),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
