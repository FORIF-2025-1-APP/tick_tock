import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../ScheduleDetails/ScheduleDetails.dart';
import '../ScheduleAdd/ScheduleAdd.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('캘린더')),
      body:SfCalendar(
      view: CalendarView.month,
      dataSource: MeetingDataSource(_getDataSource()),
      monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        showAgenda: true,
      ),
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

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();

    // 반복 일정: 매주 수요일 오전 10시 회의
    meetings.add(Meeting(
      '주간 회의',
      DateTime(today.year, today.month, today.day, 10, 0),
      DateTime(today.year, today.month, today.day, 11, 0),
      const Color(0xFF0F8644),
      false,
      recurrenceRule: 'FREQ=WEEKLY;BYDAY=WE',
    ));

    // 일반 일정: 하루짜리 행사
    meetings.add(Meeting(
      '기획 회의',
      today.add(const Duration(days: 2, hours: 9)),
      today.add(const Duration(days: 2, hours: 10)),
      Colors.blue,
      false,
    ));
    meetings.add(Meeting(
      '어쩌구 회의',
      today.add(const Duration(days: 2, hours: 10)),
      today.add(const Duration(days: 2, hours: 11)),
      Colors.blue,
      false,
    ));

    meetings.add(Meeting(
      '디자인 검토',
      today.add(const Duration(days: 3, hours: 13)),
      today.add(const Duration(days: 3, hours: 14)),
      Colors.purple,
      false,
    ));

    return meetings;
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