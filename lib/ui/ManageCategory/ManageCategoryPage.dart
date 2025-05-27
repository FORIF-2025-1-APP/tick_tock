import 'package:flutter/material.dart';
import 'package:tick_tock/ui/core/themes/theme.dart';
import 'package:tick_tock/ui/core/ui/CustomInput.dart';
import 'package:tick_tock/ui/core/ui/CustomButton.dart';
import 'package:tick_tock/ui/core/ui/CustomChips.dart';

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

<<<<<<< Updated upstream
=======
    List<Map<String, dynamic>> categoryList = [];
//카테고리 ui반영영
  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    final result = await getCategories('test'); //여기에 api 아이디 넣으면 됑됑
      print("받은 카테고리 목록: $result"); 

    setState(() {
      categoryList = result;
    });
  }

>>>>>>> Stashed changes
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
            
              },
              child: const Text('추가'),
            ),
            const SizedBox(height: 20),

            // 기존에 등록된 태그, 레이블
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    // 삭제 가능한 칩들
    CustomChips(
      label: 'Tag1',
      selected: false,
      type: ChipType.deletable,
      onTap: () {},              
      onDelete: () {},           
    ),
    CustomChips(
      label: 'Tag2',
      selected: false,
      type: ChipType.deletable,
      onTap: () {},
      onDelete: () {},
    ),
    CustomChips(
      label: 'Tag3',
      selected: false,
      type: ChipType.deletable,
      onTap: () {},
      onDelete: () {},
    ),
    CustomChips(
      label: 'Tag4',
      selected: false,
      type: ChipType.deletable,
      onTap: () {},
      onDelete: () {},
    ),

    // 일반 레이블 칩들 (삭제 불가)
    CustomChips(
      label: 'Label1',
      selected: false,
      type: ChipType.normal,
      onTap: () {},
    ),
    CustomChips(
      label: 'Label2',
      selected: false,
      type: ChipType.normal,
      onTap: () {},
    ),
    CustomChips(
      label: 'Label3',
      selected: false,
      type: ChipType.normal,
      onTap: () {},
    ),
  ],
)
          ],
        ),
      ),
    );
  }
}

