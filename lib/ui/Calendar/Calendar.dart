import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../data/services/calendar_api.dart';
import '../../data/services/calendar_service.dart';
import '../ScheduleDetails/ScheduleDetails.dart';
import '../ScheduleAdd/ScheduleAdd.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late final CalendarService _calendarService;
  List<Meeting> _meetings = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // 실제 토큰으로 교체 필요
    final calendarApi = CalendarApi(accessToken: 'your_access_token');
    _calendarService = CalendarService(calendarApi: calendarApi);
    _fetchMeetings();
  }

  Future<void> _fetchMeetings() async {
    print("fetchMeetings called");
    try {
      final events = await _calendarService.fetchCalendars();
      print(events);
      // events를 Meeting 리스트로 변환 (API 응답 구조에 맞게 수정 필요)
      final meetings = <Meeting>[];
      for (var event in events) {
        // 예시: API 응답에 따라 key 이름 맞게 수정
        meetings.add(Meeting(
          event['title'] ?? '제목 없음',
          DateTime.parse(event['date'] ?? DateTime.now().toIso8601String()),
          DateTime.parse(event['date'] ?? DateTime.now().toIso8601String()).add(const Duration(hours: 1)),
          Colors.blue,
          false,
        ));
      }
      setState(() {
        _meetings = meetings;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('캘린더')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('에러 발생: $_error'))
              : SfCalendar(
                  view: CalendarView.month,
                  dataSource: MeetingDataSource(_meetings),
                  headerStyle: CalendarHeaderStyle(
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  showNavigationArrow: true,
                  monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                    showAgenda: true,
                  ),
                  appointmentBuilder: (context, details) {
                    final Meeting meeting = details.appointments.first;
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: meeting.background,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        meeting.eventName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                  onTap: (CalendarTapDetails details) {
                    if (details.targetElement == CalendarElement.calendarCell &&
                        details.date != null) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (_) => ScheduleDetails(date: details.date!),
                      );
                    }
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ScheduleAdd(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class Meeting {
  Meeting(
    this.eventName,
    this.from,
    this.to,
    this.background,
    this.isAllDay, {
    this.recurrenceRule,
  });

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final String? recurrenceRule;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].from;

  @override
  DateTime getEndTime(int index) => appointments![index].to;

  @override
  String getSubject(int index) => appointments![index].eventName;

  @override
  Color getColor(int index) => appointments![index].background;

  @override
  bool isAllDay(int index) => appointments![index].isAllDay;

  @override
  String? getRecurrenceRule(int index) => appointments![index].recurrenceRule;
}