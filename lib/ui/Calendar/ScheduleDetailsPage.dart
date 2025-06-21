import 'package:flutter/material.dart';
import 'package:tick_tock/ui/core/ui/CustomCheckBox.dart';

class ScheduleDetailsPage extends StatelessWidget {
  const ScheduleDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dateText = '2025/06/21';
    final todos = [
      {'title': '공부', 'isDone': false},
      {'title': '운동', 'isDone': true},
    ];
    final schedules = [
      {'title': '포리프 해커톤'},
    ];

    final checked = todos.map((e) => e['isDone'] as bool).toList();

    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: CustomScrollView(
            slivers: [
              // 날짜 헤더
              SliverToBoxAdapter(
                child: Text(
                  dateText,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Todo Section
              _sectionLabel('Todo'),
              SliverList.builder(
                itemCount: todos.length,
                itemBuilder: (_, i) => CustomCheckBox(
                  value: checked[i],
                  label: todos[i]['title'] as String? ?? '',
                  onChanged: (_) {},
                ),
              ),
              // Schedule Section
              _sectionLabel('Schedule'),
              SliverList.builder(
                itemCount: schedules.length,
                itemBuilder: (_, i) => ListTile(
                  title: Text(
                    schedules[i]['title'] ?? '',
                    style: const TextStyle(fontSize: 18),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _sectionLabel(String text) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
}
