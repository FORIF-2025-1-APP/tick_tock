import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // 슬라이드 액션
import '../core/ui/CustomCheckBox.dart';
import '../core/ui/CustomInput.dart';
import '../core/ui/CustomButton.dart';

/// 카테고리별 Todo 목록을 표시하고,
/// + 버튼으로 할 일 추가, 슬라이드로 수정/삭제 기능
class TodoCategorySection extends StatefulWidget {
  final String title;
  final List<String> items;
  final VoidCallback onDelete;

  const TodoCategorySection({
    Key? key,
    required this.title,
    required this.items,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<TodoCategorySection> createState() => _TodoCategorySectionState();
}

class _TodoCategorySectionState extends State<TodoCategorySection> {
  late List<String> _todos;
  late List<bool> _checked;

  @override
  void initState() {
    super.initState();
    _todos = List.from(widget.items);
    _checked = List<bool>.filled(_todos.length, false, growable: true);
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
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  _todos.add(text);
                  _checked.add(false);
                });
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

  /// Todo 수정기능 -> TodoAdd 페이지 나오게 수정해야함
  /// 
  /// 
  /// 
  /// 
  /// 수정
  /// 
  /// 
  /// 
  /// 
  void _editTodo(int index) {
    final controller = TextEditingController(text: _todos[index]);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('할 일 수정'),
        content: CustomInput(
          controller: controller,
          hintText: '할 일을 수정하세요',
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
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                setState(() {
                  _todos[index] = text;
                });
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('수정'),
            type: ButtonType.black,
            width: 80,
            height: 40,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  /// Todo 삭제
  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
      _checked.removeAt(index);
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
                const SizedBox(width: 8),
                CustomButton(
                  onPressed: widget.onDelete,
                  child: const Icon(Icons.delete_outline),
                  type: ButtonType.white,
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
              child: Row(
                children: [
                  CustomCheckBox(
                    value: _checked[i],
                    onChanged: (val) {
                      setState(() {
                        _checked[i] = val ?? false;
                      });
                    },
                    type: CheckBoxType.noLabel,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _todos[i],
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
          );
        }),
      ),
    );
  }
}
