import 'package:flutter/material.dart';
import '../core/ui/CustomButton.dart';
import '../core/ui/CustomInput.dart';
import '../core/ui/CustomCheckBox.dart';
import '../RegisterAllow/RegisterAllow.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isChecked1 = false;
  bool isChecked2 = false;

  @override
  Widget build(BuildContext context) {
    // 실제로는 TextEditingController, 중복확인 로직, 상태관리 등 추가 필요
    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: Text('회원가입')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              CustomInput(labelText: 'Email'),
              SizedBox(height: 16),
              CustomButton(
                type: ButtonType.white,
                child: Text('중복 확인'),
                onPressed: () {},
              ),
              SizedBox(height: 16),
              CustomInput(labelText: 'Username'),
              SizedBox(height: 16),
              CustomInput(labelText: 'Password', obscureText: true),
              SizedBox(height: 16),
              CustomInput(labelText: 'Password Confirm', obscureText: true),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomCheckBox(
                    value: isChecked1,
                    type: CheckBoxType.label,
                    onChanged: (val) => setState(() => isChecked1 = val!),
                    label: 'Terms and Service 1',
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward), // → 아이콘
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterAllow(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomCheckBox(
                    value: isChecked2,
                    type: CheckBoxType.label,
                    onChanged: (val) => setState(() => isChecked2 = val!),
                    label: 'Terms and Service 2',
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward), // → 아이콘
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterAllow(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Spacer(),
              CustomButton(
                type: ButtonType.black,
                child: Text('회원가입'),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
