import 'package:flutter/material.dart';
import '../core/ui/CustomInput.dart';
import '../core/ui/CustomButton.dart';
import '../core/ui/CustomChips.dart';
import '../core/ui/CustomSelect.dart'; // ✅ 추가

class ScheduleAdd extends StatefulWidget {
  const ScheduleAdd({super.key});

  @override
  State<ScheduleAdd> createState() => _ScheduleAddState();
}

class _ScheduleAddState extends State<ScheduleAdd> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();

  final List<String> repeatOptions = ['안함', '매일', '매주', '매월', '매년'];
  String selectedRepeat = '안함';

  final Set<int> _selectedTagIndices = {};
  final List<String> _tagLabels = ["Tag1", "Tag2", "Tag3", "Tag4", "Tag5"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("일정 추가/수정")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomInput(labelText: "제목", controller: titleController),
            const SizedBox(height: 16),
            CustomInput(labelText: "시작", controller: startController),
            const SizedBox(height: 16),
            CustomInput(labelText: "종료", controller: endController),
            const SizedBox(height: 16),

            // ✅ 커스텀 셀렉트 사용
            CustomSelect(
              label: "반복",
              value: selectedRepeat,
              items: repeatOptions,
              onChanged: (val) {
                if (val != null) {
                  setState(() => selectedRepeat = val);
                }
              },
            ),

            const SizedBox(height: 16),

            Wrap(
              children: List.generate(_tagLabels.length, (i) {
                return CustomChips(
                  label: _tagLabels[i],
                  selected: _selectedTagIndices.contains(i),
                  onTap: () {
                    setState(() {
                      if (_selectedTagIndices.contains(i)) {
                        _selectedTagIndices.remove(i);
                      } else {
                        _selectedTagIndices.add(i);
                      }
                    });
                  },
                );
              }),
            ),

            const Spacer(),

            CustomButton(
              onPressed: () {
                final selectedTags = _selectedTagIndices.map((i) => _tagLabels[i]).toList();
                print("제목: ${titleController.text}");
                print("반복: $selectedRepeat");
                print("태그: $selectedTags");
                Navigator.pop(context);
              },
              child: const Text("완료"),
            ),
            const SizedBox(height: 8),
            CustomButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("취소/삭제"),
              type: ButtonType.white,
            ),
          ],
        ),
      ),
    );
  }
}
