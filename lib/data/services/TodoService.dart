import '../model/TodoEvent.dart';
import 'TodoApi.dart';


class TodoService {
  final TodoApi _api;
  static const String _base = '/api/todo';

  TodoService({required TodoApi api}) : _api = api;

  /// 날짜로 투두 조회
  Future<Map<String, List<TodoEvent>>> fetchTodosByDate(String date) async {
    print('Fetching todos for date: $date (POST)');
    final response = await _api.post('$_base/bringtodo?date=$date', {});
    final List<dynamic> data = response['data'] as List<dynamic>;

    final Map<String, List<TodoEvent>> grouped = {};
    for (var e in data) {
      final todo = TodoEvent.fromJson(e as Map<String, dynamic>);
      for (var cat in todo.categories) {
        grouped.putIfAbsent(cat, () => []).add(todo);
      }
    }
    return grouped;
  }

  /// 새로운 Todo 생성
  /// POST /api/todo/addtodo  
  Future<TodoEvent> createTodo ({
    required String title,
    required String startTime,
    required String endTime,
    required String repeat,
    required List<String> categories,
    }) async {

    print('🚀 전송 JSON: {'
        'title: $title, '
        'startTime: $startTime, '
        'endTime: $endTime, '
        'repeat: $repeat, '
        'categories: $categories, '
        'isDone: false'
        '}');

    final payload = {
      'title': title,
      'startTime': startTime,
      'endTime': endTime,
      'repeat': repeat,
      'categories': categories,
      'isDone': false,
    };
    final response = await _api.post('$_base/addtodo', payload);

    final List<dynamic> dataList = response['data'] as List<dynamic>;
    final Map<String, dynamic> firstItem = dataList.first as Map<String, dynamic>;
    return TodoEvent.fromJson(firstItem);
  }


  /// Todo 완료 상태 업데이트
    /// PATCH /api/schedule/updateTodo  
    Future<bool> completeTodo({
      required String id,
      required bool isDone,
    }) async {
      final response =
          await _api.patch('/api/schedule/updatetodo', {'id': id, 'isDone': isDone});
      print(response);
    
      return response['statusCode'] == 200;
    }


  /// Todo 전체 수정(업데이트)
  /// PUT /api/todo/updateCategory  
  Future<TodoEvent> updateCategory({
    required String id,
    required String title,
    required String startTime,
    required String endTime,
    required String repeat,
    required List<String> categories,
  }) async {

    print('🚀 전송 JSON: {'
    'title: $title, '
    'startTime: $startTime, '
    'endTime: $endTime, '
    'repeat: $repeat, '
    'categories: $categories, '
    'isDone: false'
    '}');

    final payload = {
      'id': id,
      'title': title,
      'startTime': startTime,
      'endTime': endTime,
      'repeat': repeat,
      'categories': categories,
    };
    final response = await _api.patch('$_base/updatecategory', payload);
    return TodoEvent.fromJson(response['data'] as Map<String, dynamic>);
  }


  /// Todo 삭제
  /// DELETE /api/todo/deletetodo
  Future<void> deleteTodo(String id) async {
    await _api.delete('$_base/deletetodo', {'id': id});
  }

  
  /// 해결된(완료된) Todo 개수 조회
  /// GET /api/todo/bringtodonum
  Future<int> fetchCompletedCount() async {
    final response = await _api.get('$_base/bringtodonum');
    return response['data'] as int;
  }
}