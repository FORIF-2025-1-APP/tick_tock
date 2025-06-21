import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // 슬라이드 액션
import '../core/ui/CustomCheckBox.dart';
import '../core/ui/CustomInput.dart';
import '../core/ui/CustomButton.dart';
import 'package:tick_tock/data/services/TodoApi.dart'; 
import 'package:tick_tock/data/services/TodoService.dart'; 
import 'package:tick_tock/data/model/TodoEvent.dart'; 
import '../TodoAdd/TodoAdd.dart';


/// 카테고리별 Todo 목록을 표시하고,
/// + 버튼으로 할 일 추가, 슬라이드로 수정/삭제 기능
class TodoCategorySection extends StatefulWidget {
  final String title;
  final List<TodoEvent> items;
  // final VoidCallback onCategoryDelete;
  final VoidCallback onRefresh;

  const TodoCategorySection({
    Key? key,
    required this.title,
    required this.items,
    // required this.onCategoryDelete,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<TodoCategorySection> createState() => _TodoCategorySectionState();
}

class _TodoCategorySectionState extends State<TodoCategorySection> {
  late List<TodoEvent> _todos;
  late List<bool> _checked;
  late final TodoService _todoService;

  @override
  void initState() {
    super.initState();
    _todos = List.from(widget.items);
    _checked = _todos.map((e) => e.isDone).toList(); 
    final api = TodoApi();
    _todoService = TodoService(api: api);
  }
  
  @override
  void didUpdateWidget(covariant TodoCategorySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _todos = List.from(widget.items);
      _checked = _todos.map((e) => e.isDone).toList();
    }
  }

  /// 새로운 Todo 추가
  void _addTodo() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('할 일 추가'),
        content: CustomInput(
          controller: controller,
          hintText: '할 일을 입력하세요',
        ),
        actions: [
          CustomButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('취소'),
            type: ButtonType.white,
            width: 80,
            height: 40,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 8),
          CustomButton(
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                try {
                  // DateTime을 String으로 변환
                  final startTimeStr = _todos.first.startTime.toUtc().toIso8601String();
                  final endTimeStr = _todos.first.startTime.toUtc().toIso8601String();
                 
                  final newTodo = await _todoService.createTodo(
                    title: text,
                    startTime: startTimeStr,
                    endTime: endTimeStr,
                    repeat: "NONE",
                    categories: ["3dc9bd9d-593f-4f96-858f-3206dd5736cc"], // 나중에 widget.title의 id로 바꿔야함
                  );
                  setState(() {
                    _todos.add(newTodo);
                    _checked.add(false); // 기본적으로 isDone: false로 시작!
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('할 일 추가 중 오류: $e')),
                  );
                }
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('추가'),
            type: ButtonType.black,
            width: 80,
            height: 40,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }


  void _editTodo(int index) {
    final event = _todos[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TodoAdd(existing: event),
      ),
    ).then((_) {
      widget.onRefresh();
    });
  }

  /// Todo 삭제
  void _removeTodo(int index) async {
    final event = _todos[index];
    print('🟡 삭제할 id: ${event.id}');
    
    await _todoService.deleteTodo(event.id);
    setState(() {
      _todos.removeAt(index);
    });
  }

  /// 완료 상태 변경
  void _toggleDone(int index, bool? val) async {
    final event = _todos[index];
    final isDone = val ?? false;
    await _todoService.completeTodo(
      id: event.id,
      isDone: isDone,
    );
    setState(() {
      _checked[index] = isDone;
      _todos[index] = _todos[index].copyWith(isDone: isDone);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      //color: 카테고리마다 다른 색
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Row(
              children: [
                CustomButton(
                  onPressed: _addTodo,
                  child: const Icon(Icons.add),
                  type: ButtonType.black,
                  width: 40,
                  height: 36,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
        children: List.generate(_todos.length, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Slidable(
              key: ValueKey(_todos[i]),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) => _editTodo(i),
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    icon: Icons.edit,
                    label: '수정',
                  ),
                  SlidableAction(
                    onPressed: (_) => _removeTodo(i),
                    backgroundColor: colors.error,
                    foregroundColor: colors.onError,
                    icon: Icons.delete,
                    label: '삭제',
                  ),
                ],
              ),
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TodoAdd(existing: _todos[i]),
                    ),
                  );
                  if (result == true) {
                    widget.onRefresh();
                  }
                },
                child: Row(
                  children: [
                    CustomCheckBox(
                      value: _todos[i].isDone,
                      onChanged: (val) => _toggleDone(i, val),
                      type: CheckBoxType.noLabel,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _todos[i].title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              decoration: _checked[i]
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
