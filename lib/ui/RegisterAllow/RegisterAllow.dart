import 'package:flutter/material.dart';
import '../core/ui/CustomButton.dart';

class RegisterAllow extends StatelessWidget {
  const RegisterAllow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: Text('이용약관')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    '여기에 약관 내용을 입력하세요.\n\n어쩌구 저쩌구 ...',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              CustomButton(
                type: ButtonType.black,
                child: Text('동의'),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
