import 'package:flutter/material.dart';
import '../../data/services/calendar_api.dart';
import '../../data/services/calendar_service.dart';
import '../core/ui/CustomInput.dart';
import '../core/ui/CustomButton.dart';
import '../core/ui/CustomChips.dart';
import '../core/ui/CustomSelect.dart';

class ScheduleAdd extends StatefulWidget {
  final Map<String, dynamic>? schedule; // 기존 일정 데이터 (수정용)
  const ScheduleAdd({super.key, this.schedule});

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

  bool _loading = false;
  String? _error;

  late final CalendarService _calendarService;

  @override
  void initState() {
    super.initState();
    final calendarApi = CalendarApi(accessToken: 'your_access_token');
    _calendarService = CalendarService(calendarApi: calendarApi);
    // 기존 일정 데이터가 있으면 입력값 세팅
    if (widget.schedule != null) {
      titleController.text = widget.schedule!["title"] ?? "";
      startController.text = widget.schedule!["startTime"] ?? "";
      endController.text = widget.schedule!["endTime"] ?? "";
      selectedRepeat = widget.schedule!["repeat"] ?? '안함';
      // 카테고리 태그 세팅 (예시)
      if (widget.schedule!["categories"] != null) {
        for (var cat in widget.schedule!["categories"]) {
          final idx = _tagLabels.indexOf(cat);
          if (idx != -1) _selectedTagIndices.add(idx);
        }
      }
    }
  }

  Future<void> _submitSchedule() async {
    setState(() { _loading = true; _error = null; });
    try {
      final selectedTags = _selectedTagIndices.map((i) => _tagLabels[i]).toList();
      if (widget.schedule != null && widget.schedule!["id"] != null) {
        // 수정
        await _calendarService.updateSchedule(
          id: widget.schedule!["id"],
          title: titleController.text,
          startTime: startController.text,
          endTime: endController.text,
          repeat: selectedRepeat,
          categories: selectedTags,
        );
      } else {
        // 추가
        await _calendarService.addSchedule(
          title: titleController.text,
          startTime: startController.text,
          endTime: endController.text,
          repeat: selectedRepeat,
          categories: selectedTags,
        );
      }
      Navigator.pop(context, true);
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.schedule != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "일정 수정" : "일정 추가")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomInput(labelText: "제목", controller: titleController),
            const SizedBox(height: 16),
            CustomInput(labelText: "시작", controller: startController),
            const SizedBox(height: 16),
            CustomInput(labelText: "종료", controller: endController),
            const SizedBox(height: 16),
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
            if (_error != null) ...[
              Text('에러: $_error', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
            ],
            _loading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    onPressed: _submitSchedule,
                    child: Text(isEdit ? "수정 완료" : "추가 완료"),
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
