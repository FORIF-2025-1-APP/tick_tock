import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/ui/CustomInput.dart';
import '../core/ui/CustomButton.dart';
import 'category.dart';
import 'WeekNavigator.dart';
import 'TodoCategory.dart';
import '../TodoAdd/TodoAdd.dart';
import 'package:tick_tock/data/services/TodoApi.dart';
import 'package:tick_tock/data/services/TodoService.dart';
import 'package:tick_tock/data/model/TodoEvent.dart';

class Todo extends StatefulWidget {
  final String? initialToken;
  const Todo({super.key, this.initialToken});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final _storage = const FlutterSecureStorage();
  late final TodoService _todoService;
  DateTime _selectedDate = DateTime.now();
  Future<Map<String, List<TodoEvent>>> _futureTodos = Future.value({});
  Map<String, List<TodoEvent>> _todos = {};

  @override
  void initState() {
    super.initState();
    _initService();
  }

  Future<void> _initService() async {
    final token = await _storage.read(key: 'auth_token');
    print('token = $token');
    final api = TodoApi(accessToken: token);
    _todoService = TodoService(api: api);

    print('tempTodos = $_selectedDate');
    _loadTodosForDate(_selectedDate);
  }

  void _loadTodosForDate(DateTime date) async {
    final dateStr = date.toUtc().toIso8601String().split('T')[0];

    final tempTodos = await _todoService.fetchTodosByDate(dateStr);
    print('tempTodos = $tempTodos');

    setState(() {
      _futureTodos = _todoService.fetchTodosByDate(dateStr);
      _todos = tempTodos;
    });
  }

  void _onPreviousWeek() {
    final newDate = _selectedDate.subtract(const Duration(days: 7));
    _onDateSelected(newDate);
  }

  void _onNextWeek() {
    final newDate = _selectedDate.add(const Duration(days: 7));
    _onDateSelected(newDate);
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
      _loadTodosForDate(_selectedDate);
    });
  }

  // 투두 추가 페이지로 이동
  void _goToTodoAddPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TodoAdd()),
    );

    if (result == true) {
      _loadTodosForDate(_selectedDate);
    }
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
          WeekNavigator(
            selectedDate: _selectedDate,
            onDateSelected: _onDateSelected,
            onPreviousWeek: _onPreviousWeek,
            onNextWeek: _onNextWeek,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Builder(
              builder: (context) {
                // if (!_.hasData || _todos.isEmpty) {
                if (_todos.isEmpty) {
                  return const Center(child: Text('할 일이 없습니다.'));
                }
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return const Center(child: CircularProgressIndicator());
                // }
                // if (snapshot.hasError) {
                //   return Center(child: Text('Error: \${snapshot.error}'));
                // }
                // if (!snapshot.hasData || snapshot.data!.isEmpty) {
                //   return const Center(child: Text('할 일이 없습니다.'));
                // }
                final todos = _todos;
                // 날짜별 TodoEvent를 category별로 묶어서 섹션 생성
                final grouped = _todos;

                return ListView(
                  children: grouped.entries.map((entry) {
                    final categoryName = entry.key;
                    final items = entry.value;
                    return TodoCategorySection(
                      title: categoryName,
                      items: items,
                      onRefresh: () {
                        _loadTodosForDate(_selectedDate);
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
