import 'package:flutter/material.dart';
import 'package:tick_tock/ui/core/themes/theme.dart';
import 'package:tick_tock/ui/core/ui/CustomInput.dart';
import 'package:tick_tock/ui/Setting/SettingPage.dart';
import 'package:tick_tock/ui/ManageCategory/ManageCategoryPage.dart';
import 'package:tick_tock/ui/ChangeName/ChangeNamePage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/* ================= 친구 목록 API ================= */
Future<List<String>> fetchFriends() async {
  final url =
      Uri.parse('https://forifitkokapi.seongjinemong.app/api/friend');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item['friendNickname'] as String).toList();
    } else {
      print('친구 목록 불러오기 실패: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('예외 발생: $e');
    return [];
  }
}

/* ================= ProfilePage ================= */
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  /* 닉네임 상태값 */
  String nickname = 'tic_tock';

  List<String> friends = [];

  /* ChangeNamePage 다녀와서 결과 받기 */
  Future<void> _goToChangeName() async {
    final newName = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const ChangeNamePage()),
    );

    if (newName != null && newName.isNotEmpty) {
      setState(() => nickname = newName);
    }
  }

  /* 친구 리스트 로딩 & 팝업 */
  void _loadAndShowFriends() async {
    await fetchFriends(); // 실제 API 호출은 유지
    setState(() {
      friends = ['friend1', 'friend2']; // 데모용 하드코딩
    });
    _openDraggableSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.inversePrimary,
        elevation: 0,
        titleSpacing: 16,
        title: const Text('Profile'),
        actions: [
          /* 카테고리 관리 */
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManageCategoryPage()),
            ),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.edit, size: 16),
                  SizedBox(width: 4),
                  Text('카테고리')
                ],
              ),
            ),
          ),
          /* 설정 페이지 */
          IconButton(
            icon: const Icon(Icons.settings),
              onPressed: () async {
                final newName = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingPage()),
                );

                if (newName != null && newName.isNotEmpty) {
                  setState(() => nickname = newName);   // ★ 즉시 갱신
                }
              },
            ),
          ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* 프로필 헤더 */
            Row(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: colors.primary.withOpacity(0.1),
                      child: const Icon(Icons.person, size: 40),
                    ),
                    /* 닉네임 수정 아이콘 */
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: _goToChangeName,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: colors.primary,
                          child: const Icon(Icons.edit,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nickname,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'HYU@hanyang.ac.kr',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            /* 중앙 이미지 */
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/realseed.jpg',
                  height: 450,
                  width: 400,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            /* 친구 검색 */
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _loadAndShowFriends,
                    child: AbsorbPointer(
                      child: CustomInput(
                        controller: TextEditingController(),
                        labelText: '이름',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _loadAndShowFriends,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /* 친구 리스트 드래그 시트 */
  void _openDraggableSheet(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.3,
          minChildSize: 0.1,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(friends[index][0]),
                        ),
                        title: Text(friends[index]),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
