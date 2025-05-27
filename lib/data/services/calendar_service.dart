import 'package:tick_tock/data/services/calendar_api.dart';
import 'package:tick_tock/data/model/calendar_event.dart';

class CalendarService {
  final CalendarApi _calendarApi;
  static const String _baseEndpoint = '/api/calendar';

  CalendarService({required CalendarApi calendarApi}) : _calendarApi = calendarApi;

  // 캘린더 이벤트 목록 조회
  Future<List<CalendarEvent>> getEvents() async {
    final response = await _calendarApi.get('$_baseEndpoint/events');
    final List<dynamic> eventsJson = response['data'];
    return eventsJson.map((json) => CalendarEvent.fromJson(json)).toList();
  }

  // 특정 날짜의 이벤트 조회
  Future<List<CalendarEvent>> getEventsByDate(DateTime date) async {
    final dateStr = date.toIso8601String().split('T')[0];
    final response = await _calendarApi.get('$_baseEndpoint/events/$dateStr');
    final List<dynamic> eventsJson = response['data'];
    return eventsJson.map((json) => CalendarEvent.fromJson(json)).toList();
  }

  // 새 이벤트 생성
  Future<CalendarEvent> createEvent(CalendarEvent event) async {
    final response = await _calendarApi.post(
      '$_baseEndpoint/events',
      event.toJson(),
    );
    return CalendarEvent.fromJson(response['data']);
  }

  // 이벤트 수정
  Future<CalendarEvent> updateEvent(String id, CalendarEvent event) async {
    final response = await _calendarApi.post(
      '$_baseEndpoint/events/$id',
      event.toJson(),
    );
    return CalendarEvent.fromJson(response['data']);
  }

  // 이벤트 삭제
  Future<void> deleteEvent(String id) async {
    await _calendarApi.post('$_baseEndpoint/events/$id/delete', {});
  }

  // 1. 캘린더 전체 가져오기
  Future<List<dynamic>> fetchCalendars() async {
    final res = await _calendarApi.get('/api/calendar');
    return res['data'];
  }

  // 2. 특정 캘린더 및 일정 조회
  Future<List<dynamic>> fetchCalendarDetail(String calendarId) async {
    final res = await _calendarApi.get('/api/calendar/$calendarId/cate');
    return res['calendar'];
  }

  // 3. 특정 날짜의 투두 불러오기
  Future<List<dynamic>> fetchTodosByDate(String date) async {
    final res = await _calendarApi.post('/api/todo/bringtodo', {"date": date});
    return res['data'];
  }

  // 4. 특정 날짜에 일정 추가
  Future<List<dynamic>> addSchedule({
    required String title,
    required String startTime,
    required String endTime,
    required String repeat,
    required List<String> categories,
  }) async {
    final res = await _calendarApi.post('/api/schedule/addschedule', {
      "title": title,
      "startTime": startTime,
      "endTime": endTime,
      "repeat": repeat,
      "categories": categories,
    });
    return res['data'];
  }

  // 5. 일정 수정
  Future<Map<String, dynamic>> updateSchedule({
    required String id,
    required String title,
    required String startTime,
    required String endTime,
    required String repeat,
    required List<String> categories,
  }) async {
    final res = await _calendarApi.put('/api/schedule/updateschedule', {
      "id": id,
      "title": title,
      "startTime": startTime,
      "endTime": endTime,
      "repeat": repeat,
      "categories": categories,
    });
    return res['data'];
  }

  // 6. 투두 완료 처리
  Future<void> completeTodo({
    required String id,
    required bool isDone,
  }) async {
    await _calendarApi.patch('/api/schedule/updatetodo', {
      "id": id,
      "isDone": isDone,
    });
  }
} 