import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/services/calendar_api.dart';
import '../../data/services/calendar_service.dart';
import '../core/ui/CustomCheckBox.dart';
import '../ScheduleAdd/ScheduleAdd.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleDetails extends StatefulWidget {
  final DateTime date;

  const ScheduleDetails({super.key, required this.date});

  @override
  State<ScheduleDetails> createState() => _ScheduleDetailsState();
}

class _ScheduleDetailsState extends State<ScheduleDetails> {
  late final CalendarService _calendarService;
  List<dynamic> _todos = [];
  List<dynamic> _schedules = [];
  bool _loading = true;
  String? _error;
  List<bool> isCheckedList = [];

  String get _dateStr => "${widget.date.year.toString().padLeft(4, '0')}-${widget.date.month.toString().padLeft(2, '0')}-${widget.date.day.toString().padLeft(2, '0')}";

  @override
  void initState() {
    super.initState();
    final calendarApi = CalendarApi(accessToken: 'your_access_token');
    _calendarService = CalendarService(calendarApi: calendarApi);
    _loadFromLocal();
    _fetchDetails();
  }

  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final todoStr = prefs.getString('todo_cache_$_dateStr');
    final scheduleStr = prefs.getString('schedule_cache_$_dateStr');
    if (todoStr != null) {
      setState(() {
        _todos = json.decode(todoStr);
        isCheckedList = List.generate(_todos.length, (i) => _todos[i]['isDone'] ?? false);
        _loading = false;
      });
    }
    if (scheduleStr != null) {
      setState(() {
        _schedules = json.decode(scheduleStr);
        _loading = false;
      });
    }
  }

  Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('todo_cache_$_dateStr', json.encode(_todos));
    await prefs.setString('schedule_cache_$_dateStr', json.encode(_schedules));
  }

  Future<void> _fetchDetails() async {
    setState(() { _loading = true; });
    try {
      final todos = await _calendarService.fetchTodosByDate(_dateStr);
      final allSchedules = await _calendarService.fetchCalendars();
      final schedules = allSchedules.where((e) => e['date'] == _dateStr).toList();
      setState(() {
        _todos = todos;
        _schedules = schedules;
        isCheckedList = List.generate(todos.length, (i) => todos[i]['isDone'] ?? false);
        _loading = false;
      });
      await _saveToLocal();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = "${widget.date.year}/${widget.date.month.toString().padLeft(2, '0')}/${widget.date.day.toString().padLeft(2, '0')}";

    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('에러 발생: $_error'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 헤더
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formattedDate, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ScheduleAdd(),
                                ),
                              );
                              if (result == true) {
                                _fetchDetails();
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text("Todo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      ...List.generate(_todos.length, (i) {
                        return CustomCheckBox(
                          value: isCheckedList[i],
                          onChanged: (val) async {
                            setState(() {
                              isCheckedList[i] = val ?? false;
                              _todos[i]['isDone'] = val ?? false;
                            });
                            try {
                              await _calendarService.completeTodo(
                                id: _todos[i]['id'],
                                isDone: val ?? false,
                              );
                              await _saveToLocal();
                            } catch (e) {
                              setState(() {
                                isCheckedList[i] = !isCheckedList[i];
                                _todos[i]['isDone'] = !isCheckedList[i];
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('서버 반영 실패: $e')),
                              );
                            }
                          },
                          label: _todos[i]['title'] ?? '투두',
                          type: CheckBoxType.label,
                        );
                      }),
                      const SizedBox(height: 16),
                      const Text("Schedule", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      ...List.generate(_schedules.length, (i) {
                        return ListTile(
                          title: Text(_schedules[i]['title'] ?? '일정'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ScheduleAdd(schedule: _schedules[i]),
                              ),
                            );
                            if (result == true) {
                              _fetchDetails();
                            }
                          },
                        );
                      }),
                    ],
                  ),
                ),
    );
  }
}
