import 'package:flutter/material.dart';
import '../core/ui/CustomInput.dart'; 
import '../core/ui/CustomButton.dart';
import 'category.dart';
import 'WeekNavigator.dart';
import 'TodoCategory.dart';
import '../TodoAdd/TodoAdd.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  
  List<Category> categories = [Category(name: "에시")];
 // 카테고리 관리가 마이페이지에 생기면 이건 필요 없음
//   void _addCategory() {
//     final controller = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('카테고리 추가'),
//         content: CustomInput( 
//           controller: controller,
//           hintText: '카테고리 이름 입력',
//         ),
//         actions: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               CustomButton(
//                 onPressed: () => Navigator.of(ctx).pop(),
//                 child: const Text('취소'),
//                 type: ButtonType.white,
//                 width: 80,
//                 height: 40,
//                 padding: EdgeInsets.zero,
//               ),
//               const SizedBox(width: 8),
//               CustomButton(
//                 onPressed: () {
//                   final name = controller.text.trim();
//                   if (name.isNotEmpty) {
//                     setState(() {
//                       categories.add(Category(name: name));
//                     });
//                   }
//                   Navigator.of(ctx).pop();
//                 },
//                 child: const Text('추가'),
//                 type: ButtonType.black,
//                 width: 80,
//                 height: 40,
//                 padding: EdgeInsets.zero,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
 // 카테고리 관리 생기면 필요없음
  void _deleteCategory(int index) {
    setState(() {
      categories.removeAt(index);
    });
  }

  void _goToTodoAddPage () {
    Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const TodoAdd(),
              ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        actions: [
          CustomButton(
            onPressed: _goToTodoAddPage,
            child: const Icon(Icons.add, size: 20),
            type: ButtonType.black,
            width: 45,
            height: 40,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const WeekNavigator(),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                return TodoCategorySection(
                  title: cat.name,
                  items: cat.todos,
                  onDelete: () => _deleteCategory(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}