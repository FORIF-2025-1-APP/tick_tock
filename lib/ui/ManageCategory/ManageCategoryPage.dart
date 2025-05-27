import 'package:flutter/material.dart';
import 'package:tick_tock/ui/core/themes/theme.dart';
import 'package:tick_tock/ui/core/ui/CustomInput.dart';
import 'package:tick_tock/ui/core/ui/CustomButton.dart';
import 'package:tick_tock/ui/core/ui/CustomChips.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//카테고리 조회 함수
Future<List<Map<String, dynamic>>> getCategories(String calendarId) async {
  final url = Uri.parse('https://forifitkokapi.seongjinemong.app/api/calendar/$calendarId/category');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> calendarList = decoded['calendar'];

      // category만 추출
      final categories = calendarList.map<Map<String, dynamic>>((calendar) {
        return {
          'title': calendar['category']['name'],
          'id': calendar['category']['id'],
          'deletable': true // 이건 필요 시 조정
        };
      }).toList();

      return categories;
    } else {
      print('카테고리 불러오기 실패: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('에러 발생: $e');
    return [];
  }
}



// 카테고리 추가 함수
Future<void> addCategory(String title, String color) async {
  final url = Uri.parse('https://forifitkokapi.seongjinemong.app/api/category');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'color': color,
      }),
    );

    if (response.statusCode == 201) {
      print('카테고리 생성 성공!');
    } else {
      print('실패: ${response.statusCode}');
      print('서버 응답: ${response.body}');
    }
  } catch (e) {
    print('에러 발생: $e');
  }
}

class ManageCategoryPage extends StatefulWidget {
  const ManageCategoryPage({Key? key}) : super(key: key);

  @override
  State<ManageCategoryPage> createState() => _ManageCategoryPageState();
}

class _ManageCategoryPageState extends State<ManageCategoryPage> {
  // 입력용 컨트롤러
  final titleCtrl = TextEditingController();
  final colorCtrl = TextEditingController();


  // 선택 상태 추적
  final Set<String> selectedTags = {};
  final Set<String> selectedLabels = {};

    List<Map<String, dynamic>> categoryList = [];
//카테고리 ui반영영
  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    final result = await getCategories('test'); //여기에 api 아이디 넣으면 됑됑
      print("받은 카테고리 목록: $result"); // ← 이거 추가

    setState(() {
      categoryList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카테고리 관리'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목 입력
            CustomInput(
              controller: titleCtrl,
              labelText: '제목',
              
            ),
            const SizedBox(height: 16),

            // 색상 입력
            CustomInput(
              controller: colorCtrl,
              labelText: '색상',
              
            ),
            const SizedBox(height: 20),

            // 추가 버튼
         CustomButton(
  type: ButtonType.black,
  onPressed: () {
    final title = titleCtrl.text.trim();
    final color = colorCtrl.text.trim();

    if (title.isEmpty || color.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 색상을 모두 입력해주세요')),
      );
      return;
    }

    addCategory(title, color).then((_) {
      titleCtrl.clear();
      colorCtrl.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('카테고리가 성공적으로 추가되었습니다')),
      );
    });
  },
  child: const Text('추가'),
),
            const SizedBox(height: 20),

            // 기존에 등록된 태그, 레이블
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: categoryList.map((category) {
    final String title = category['title'];
    final bool isDeletable = category['deletable'] ?? true;

    return CustomChips(
      label: title,
      selected: false,
      type: isDeletable ? ChipType.deletable : ChipType.normal,
      onTap: () {},
      onDelete: isDeletable ? () {} : null,
    );
  }).toList(),
),
          ],
        ),
      ),
    );
  }
}

