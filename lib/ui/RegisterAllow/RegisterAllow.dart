import 'package:flutter/material.dart';
import '../core/ui/CustomButton.dart';

class RegisterAllow extends StatelessWidget {
  const RegisterAllow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('약관 동의')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(child: Text('어쩌구 저쩌구...'))),
            CustomButton(
              type: ButtonType.black,
              child: Text('동의'),
              onPressed: () {
                Navigator.pop(context, true); //
              },
            ),
          ],
        ),
      ),
    );
  }
}
