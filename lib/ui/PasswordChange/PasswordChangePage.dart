import 'package:flutter/material.dart';
import 'package:tick_tock/ui/core/themes/theme.dart';
import 'package:tick_tock/ui/core/ui/CustomInput.dart';
import 'package:tick_tock/ui/core/ui/CustomButton.dart';
import 'package:tick_tock/ui/ChangeName/ChangeNameConfirm.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> changePassword(String current, String newPass, String confirm) async {
  final url = Uri.parse('https://forifitkokapi.seongjinemong.app/api/user/password');

  try {
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "currentPassword": current,
        "newPassword": newPass,
        "newPasswordConfirm": confirm,
      }),
    );

    if (response.statusCode == 200) {
      print('비밀번호 변경 성공');
    } else {
      print('실패: ${response.statusCode}');
      print('응답: ${response.body}');
    }
  } catch (e) {
    print('에러 발생: $e');
  }
}
class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({super.key});
  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final oldPassCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  @override
  void dispose() {
    oldPassCtrl.dispose();
    newPassCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            CustomInput(
              controller: oldPassCtrl,
              labelText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            CustomInput(
              controller: newPassCtrl,
              labelText: 'New Password',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            CustomInput(
              controller: confirmCtrl,
              labelText: 'New Password Confirm',
              obscureText: true,
            ),
            const Spacer(),

            // ✅ 버튼 동작 확인용 print 추가
            CustomButton(
              type: ButtonType.black,
              onPressed: () async {
                print('✅ 완료 버튼 눌림');

                final oldPass = oldPassCtrl.text.trim();
                final newPass = newPassCtrl.text.trim();
                final confirmPass = confirmCtrl.text.trim();

                if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('모든 항목을 입력해주세요')),
                  );
                  return;
                }

                if (newPass != confirmPass) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('새 비밀번호가 일치하지 않습니다')),
                  );
                  return;
                }

                await changePassword(oldPass, newPass, confirmPass);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('비밀번호가 변경되었습니다')),
                );

                Navigator.of(context).pop();
              },
              child: const Text('완료'),
            ),
            const SizedBox(height: 8),
            CustomButton(
              type: ButtonType.white,
              onPressed: () {
                print("✅ 탈퇴 버튼 눌림");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangeNameConfirmPage()),
                );
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

// class PasswordChangePage extends StatelessWidget {
//   const PasswordChangePage({super.key});

//   @override
//   Widget build(BuildContext context) {
   
//     final oldPassCtrl = TextEditingController();
//     final newPassCtrl = TextEditingController();
//     final confirmCtrl = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('비밀번호 변경'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
//         child: Column(
//           children: [
//             // 기존 비밀번호
//             CustomInput(
//               controller: oldPassCtrl,
//               labelText: 'Password',
          
//               obscureText: true,
//             ),
//             const SizedBox(height: 16),

//             // 새 비밀번호
//             CustomInput(
//               controller: newPassCtrl,
//               labelText: 'New Password',
            
//               obscureText: true,
//             ),
//             const SizedBox(height: 16),

//             // 새 비밀번호 확인
//             CustomInput(
//               controller: confirmCtrl,
//               labelText: 'New Password Confirm',
            
//               obscureText: true,
//             ),

//             const Spacer(),

//             // 검은색 완료 버튼
//             CustomButton(
//               type: ButtonType.black,
//            onPressed: () async {
            
//   final oldPass = oldPassCtrl.text.trim();
//   final newPass = newPassCtrl.text.trim();
//   final confirmPass = confirmCtrl.text.trim();

//   if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('모든 항목을 입력해주세요')),
//     );
//     return;
//   }

//   if (newPass != confirmPass) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('새 비밀번호가 일치하지 않습니다')),
//     );
//     return;
//   }

//   await changePassword(oldPass, newPass, confirmPass);

//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(content: Text('비밀번호가 변경되었습니다')),
//   );

//   Navigator.of(context).pop();
// },
//               child: const Text('완료'),
//             ),
//             const SizedBox(height: 8),

//             // 흰색 탈퇴 버튼 (화면 아래쪽)
//             CustomButton(
//   type: ButtonType.white,
//   onPressed: () {
//     print("aa");
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const ChangeNameConfirmPage()),
//     );
//   },
//   child: const Text('탈퇴'),
// ),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

