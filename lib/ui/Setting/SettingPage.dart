// import 'package:flutter/material.dart';
// import 'package:tick_tock/ui/core/themes/theme.dart';
// import 'package:tick_tock/ui/ChangeName/ChangeNamePage.dart';
// import 'package:tick_tock/ui/PasswordChange/PasswordChangePage.dart';

// class SettingPage extends StatelessWidget {
//   const SettingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('설정'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//              Navigator.of(context).pop();
//           },   
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//           GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const ChangeNamePage()),
//                 );
//               },
//               child: const Text(
//                 '닉네임 변경',
//                 style: TextStyle(fontSize: 14),
//               ),
//             ),
//             const SizedBox(height: 30),
//                       GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const PasswordChangePage()),
//               );
//             },
//             child: const Text(
//               '비밀번호 변경',
//               style: TextStyle(fontSize: 14),
//             ),
//           ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   '알림 설정',
//                   style: TextStyle(fontSize: 14),
//                 ),
//                 Switch(
//                   value: true,
//                   onChanged: null, 
//                 ),
//               ],
//             ),
//             const Spacer(),
//             Center(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: const [
//                   Text(
//                     '로그아웃',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   SizedBox(width: 20),
//                   Text(
//                     '탈퇴하기',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:tick_tock/ui/core/themes/theme.dart';
import 'package:tick_tock/ui/ChangeName/ChangeNamePage.dart';
import 'package:tick_tock/ui/PasswordChange/PasswordChangePage.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // 알림 설정 상태 변수
  bool _isAlarmOn = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.inversePrimary,
        elevation: 0,
        title: const Text('설정'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // 닉네임 변경
          GestureDetector(
            onTap: () async {
              final newName = await Navigator.push<String>(
                context,
                MaterialPageRoute(builder: (_) => const ChangeNamePage()),
              );

              if (newName != null && newName.isNotEmpty) {
                Navigator.of(context).pop(newName);   // ★ 키포인트!
              }
            },
            child: const Text('닉네임 변경', style: TextStyle(fontSize: 14)),
          ),

            const SizedBox(height: 30),

            // 비밀번호 변경
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PasswordChangePage()),
              ),
              child: const Text('비밀번호 변경', style: TextStyle(fontSize: 14)),
            ),

            const SizedBox(height: 20),

            // 알림 설정 토글
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('알림 설정', style: TextStyle(fontSize: 14)),
                Switch(
                  value: _isAlarmOn,
                  onChanged: (bool newValue) {
                    setState(() {
                      _isAlarmOn = newValue;
                    });
                  },
                ),
              ],
            ),

            const Spacer(),

            // 로그아웃 / 탈퇴
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text('로그아웃',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  SizedBox(width: 20),
                  Text('탈퇴하기',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
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