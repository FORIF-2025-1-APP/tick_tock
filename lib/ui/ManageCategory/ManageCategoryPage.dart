import 'package:flutter/material.dart';
import 'package:tick_tock/ui/core/ui/CustomInput.dart';
import 'package:tick_tock/ui/core/ui/CustomButton.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/* ── API 함수: 기존과 동일 ── */
Future<List<Map<String, dynamic>>> getCategories(String calendarId) async {
  final url = Uri.parse(
      'https://forifitkokapi.seongjinemong.app/api/calendar/$calendarId/category');
  try {
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      final list = decoded['calendar'] as List<dynamic>;
      return list
          .map<Map<String, dynamic>>((e) => {
                'title': e['category']['name'],
                'id': e['category']['id'],
              })
          .toList();
    }
  } catch (_) {}
  return [];
}

Future<void> addCategory(String title, String hex) async {
  final url = Uri.parse('https://forifitkokapi.seongjinemong.app/api/category');
  try {
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'color': hex}),
    );
  } catch (_) {}
}

/* ── 페이지 ── */
class ManageCategoryPage extends StatefulWidget {
  const ManageCategoryPage({super.key});
  @override
  State<ManageCategoryPage> createState() => _ManageCategoryPageState();
}

class _ManageCategoryPageState extends State<ManageCategoryPage> {
  final titleCtrl = TextEditingController();
  Color? selectedColor;
  final List<Map<String, dynamic>> categoryList = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    categoryList.addAll(await getCategories('test'));
    setState(() {});
  }

  /* 색상 팔레트 */
  Future<void> _pickColor() async {
    const palette = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.brown,
      Colors.grey,
      Colors.black,
    ];

    final chosen = await showDialog<Color>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('색상 선택'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: palette
              .map((c) => GestureDetector(
                    onTap: () => Navigator.pop(dialogCtx, c), // 다이얼로그만 pop
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );

    if (chosen != null) setState(() => selectedColor = chosen);
  }

  /* 칩 삭제 */
  void _removeChip(int i) => setState(() => categoryList.removeAt(i));

  @override
  Widget build(BuildContext context) {
    final preview = selectedColor ?? Colors.grey[300];

    return Scaffold(
      appBar: AppBar(
        title: const Text('카테고리 관리'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInput(controller: titleCtrl, labelText: '제목'),
            const SizedBox(height: 16),

            /* 색상 선택 */
            GestureDetector(
              onTap: _pickColor,
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: preview,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selectedColor == null
                        ? '색상 선택'
                        : '#${selectedColor!.value.toRadixString(16).substring(2).toUpperCase()}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /* 추가 버튼 */
            CustomButton(
              type: ButtonType.black,
              child: const Text('추가'),
              onPressed: () async {
                final title = titleCtrl.text.trim();
                final col = selectedColor;
                if (title.isEmpty || col == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('제목과 색상을 모두 입력하세요')),
                  );
                  return;
                }

                final hex = '#${col.value.toRadixString(16).substring(2)}';
                await addCategory(title, hex).catchError((_) {});

                setState(() {
                  categoryList.add({'title': title, 'color': col});
                  titleCtrl.clear();
                  selectedColor = null;
                });
              },
            ),
            const SizedBox(height: 20),

            /* Chip 리스트 */
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(categoryList.length, (i) {
                    final item = categoryList[i];
                    return Chip(
                      label: Text(item['title']),
                      backgroundColor:
                          (item['color'] as Color?) ?? Colors.grey[300],
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () => _removeChip(i),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
