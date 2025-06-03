import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/ui/CustomInput.dart';
import '../core/ui/CustomButton.dart';
import '../core/ui/CustomChips.dart';
import '../core/ui/CustomSelect.dart';
import 'package:tick_tock/data/services/TodoApi.dart';
import 'package:tick_tock/data/services/TodoService.dart';
import 'package:tick_tock/data/model/TodoEvent.dart';

/// “할일 추가/수정” 화면
/// If [existing] is non-null, 수정 모드로 동작
class TodoAdd extends StatefulWidget {
  final TodoEvent? existing;
  const TodoAdd({Key? key, this.existing}) : super(key: key);

  @override
  State<TodoAdd> createState() => _TodoAddState();
}

class _TodoAddState extends State<TodoAdd> {
  final _titleController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();

  final _storage = const FlutterSecureStorage();

  final List<String> _repeatOptions = ['안함', '매일', '매주', '매월', '매년'];
  String _selectedRepeat = '안함';

  final Set<int> _selectedTagIndices = {};
  final List<String> _tagLabels = ["Tag1", "Tag2", "Tag3", "Tag4", "Tag5"];

  late final TodoService _todoService;
  
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initService();
  }

  Future<void> _initService() async {
    final token = await _storage.read(key: 'auth_token'); 
    final api = TodoApi(accessToken: token); 
    _todoService = TodoService(api: api);

    if (widget.existing != null) {
      print(widget.existing);
      final e = widget.existing!;
      _titleController.text = e.title;
      _startController.text = e.startTime.toUtc().toIso8601String().split('T').first.replaceAll('-', '/');
      _endController.text = e.endTime.toUtc().toIso8601String().split('T').first.replaceAll('-', '/');
      _selectedRepeat = e.repeat;
      for (int i = 0; i < _tagLabels.length; i++) {
        if (e.categories.contains(_tagLabels[i])) {
          _selectedTagIndices.add(i);
        }
      }
    }
  }


  @override
  void dispose() {
    _titleController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 3650)),
      lastDate: now.add(const Duration(days: 3650)),
    );
    if (picked != null) {
      controller.text =
          '${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}';
    }
  }

  String _mapRepeat(String repeat) {
  switch (repeat) {
    case '안함': return 'NONE';
    case '매일': return 'DAILY';
    case '매주': return 'WEEKLY';
    case '매월': return 'MONTHLY';
    case '매년': return 'YEARLY';
    default: return 'NONE';
    }
  }

  // 저장 버튼 눌렀을 때 호출되는 메서드 (신규 생성 or 수정)
  Future<void> _onSave() async {
    final title = _titleController.text.trim();
    final startText = _startController.text.replaceAll('/', '-');
    final endText = _endController.text.replaceAll('/', '-');
    
    
    // 서버에서 받은 UUID로 변환하는 카테고리 매핑 예시
    // 실제 앱에서는 서버에서 categoryMap을 받아서 사용해야 함
    // final Map<String, String> categoryMap = {
    //   "Tag1": "d1f9f97e-xxxx-yyyy-zzzz-abcabcabcabc",
    //   "Tag2": "a2b3c4d5-xxxx-yyyy-zzzz-abcabcabcabc",
    //   "Tag3": "b3c4d5e6-xxxx-yyyy-zzzz-abcabcabcabc",
    //   "Tag4": "c4d5e6f7-xxxx-yyyy-zzzz-abcabcabcabc",
    //   "Tag5": "d5e6f7g8-xxxx-yyyy-zzzz-abcabcabcabc",
    //   };

    if (title.isEmpty || startText.isEmpty || endText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목, 시작/종료 날짜는 필수입니다.')),
      );
      return;
    }

    final start = DateTime.parse(startText).toUtc().toIso8601String();
    final end = DateTime.parse(endText).toUtc().toIso8601String();
    final repeat = _mapRepeat(_selectedRepeat);
    //UUID
    // final categories =
    //     _selectedTagIndices.map((i) => _tagLabels[i]).toList();
    final selectedTags = _selectedTagIndices.map((i) => _tagLabels[i]).toList();

    setState(() => _isSaving = true);

    try {
      if (widget.existing == null) {
        // 신규 Todo 생성 API 호출
        await _todoService.createTodo(
          title: title,
          startTime: start,
          endTime: end,
          repeat: repeat,
          categories: ["3dc9bd9d-593f-4f96-858f-3206dd5736cc"], // 예시의 태그 id 나중에 바꿔야함
        );
      } else {
        // 기존 Todo 수정 API 호출
        await _todoService.updateCategory(
          id: widget.existing!.id,
          title: title,
          startTime: start,
          endTime: end,
          repeat: repeat,
          categories: selectedTags,
        );
      }
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 중 오류가 발생했습니다:\n$e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? '할일 수정' : '할일 추가'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 제목 입력
              const Text('제목'),
              const SizedBox(height: 8),
              CustomInput(
                controller: _titleController,
                hintText: '새로운 할일',
                labelText: '제목',
              ),
              const SizedBox(height: 16),

              // 시작 날짜
              const Text('시작'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _pickDate(_startController),
                child: AbsorbPointer(
                  child: CustomInput(
                    controller: _startController,
                    hintText: '시작 날짜 선택',
                    labelText: '시작 날짜',
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 종료 날짜
              const Text('종료'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _pickDate(_endController),
                child: AbsorbPointer(
                  child: CustomInput(
                    controller: _endController,
                    hintText: '종료 날짜 선택',
                    labelText: '종료 날짜',
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 반복 선택
              CustomSelect(
                label: '반복',
                value: _selectedRepeat,
                items: _repeatOptions,
                onChanged: (val) {
                  if (val != null) setState(() => _selectedRepeat = val);
                },
              ),
              const SizedBox(height: 16),

              // 카테고리 태그
              const Text('카테고리'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_tagLabels.length, (i) {
                  return CustomChips(
                    label: _tagLabels[i],
                    selected: _selectedTagIndices.contains(i),
                    type: ChipType.deletable,
                    onTap: () {
                      setState(() {
                        if (_selectedTagIndices.contains(i)) {
                          _selectedTagIndices.remove(i);
                        } else {
                          _selectedTagIndices.add(i);
                        }
                      });
                    },
                    onDelete: () {
                      setState(() {
                        _selectedTagIndices.remove(i);
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 32),

              // 완료/수정 버튼
              CustomButton(
                onPressed: _isSaving ? null : _onSave, 
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isEdit ? '수정 완료' : '추가 완료'),
                type: ButtonType.black,
                height: 55,
                width: double.infinity,
              ),
              const SizedBox(height: 8),

              // 취소/삭제 버튼 (수정 모드인 경우 “삭제” 로직 추가)
              CustomButton(
                onPressed: () {
                  if (isEdit) {
                    // 삭제 API 호출
                    _todoService.deleteTodo(widget.existing!.id).then((_) {
                      Navigator.of(context).pop(true);
                    }).catchError((e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('삭제 중 오류: $e')),
                      );
                    });
                  } else {
                    Navigator.pop(context, false);
                  }
                },
                child: Text(isEdit ? '삭제' : '취소'),
                type: ButtonType.white,
                height: 55,
                width: double.infinity,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }
}