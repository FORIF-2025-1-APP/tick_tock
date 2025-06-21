import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../ScheduleAdd/ScheduleAdd2.dart';
import "ScheduleDetailsPage.dart";

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<Meeting> _meetings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('캘린더')),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: MeetingDataSource(_meetings),
        headerStyle: const CalendarHeaderStyle(
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
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          );
        },

        // ✅ 날짜나 일정 아무 곳이나 누르면 상세 페이지로 이동하도록 onTap 추가한 부분
        onTap: (CalendarTapDetails details) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ScheduleDetailsPage(),
            ),
          );
        },
        // ✅ 여기까지가 추가된 onTap
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TodoAdd()),
          );

          // 일정 추가: 6월 21일 "포리프 해커톤"
          final DateTime startTime = DateTime(2025, 6, 21, 10, 0);
          final DateTime endTime = DateTime(2025, 6, 21, 18, 0);

          final alreadyExists = _meetings.any((m) =>
              m.eventName == "포리프 해커톤" &&
              m.from == startTime &&
              m.to == endTime);

          if (!alreadyExists) {
            setState(() {
              _meetings.add(
                Meeting(
                  "포리프 해커톤",
                  startTime,
                  endTime,
                  const Color.fromARGB(255, 77, 133, 13),
                  false,
                ),
              );
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
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
