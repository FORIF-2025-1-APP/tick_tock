import 'package:flutter/material.dart';
import '../core/ui/CustomButton.dart';

// 주차 표시(EX - 2025/05/01 ~ 2025/05/07) -> 터치해서 주차 옮길 수 있음
// 일~토 순으로 나열, 주차 이동 버튼
class WeekNavigator extends StatefulWidget {
  const WeekNavigator({Key? key}) : super(key: key);

  @override
  State<WeekNavigator> createState() => _WeekNavigatorState();
}

class _WeekNavigatorState extends State<WeekNavigator> {
  DateTime selectedDate = DateTime.now();
  final List<String> _weekdays = ['일', '월', '화', '수', '목', '금', '토'];

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = DateTime(date.year, date.month, date.day);
    });
  }

  void _onPreviousWeek() {
    _onDateSelected(selectedDate.subtract(const Duration(days: 7)));
  }

  void _onNextWeek() {
    _onDateSelected(selectedDate.add(const Duration(days: 7)));
  }

  DateTime _findFirstDayOfTheWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday % 7));
  }

  String _getKoreanWeekday(DateTime date) {
    return _weekdays[date.weekday % 7];
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString();
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y/$m/$d';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final today = DateTime.now();
    final firstDayOfWeek = _findFirstDayOfTheWeek(selectedDate);
    final lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));
    final weekDates = List.generate(7, (i) => firstDayOfWeek.add(Duration(days: i)));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            onPressed: () async {
              final startBase = _findFirstDayOfTheWeek(selectedDate);
              final weeks = List<DateTime>.generate(
                105,
                (i) => startBase.subtract(Duration(days: 7 * 52)).add(Duration(days: 7 * i)),
              );
              int initialIndex = weeks.indexWhere((w) => w == firstDayOfWeek);
              if (initialIndex < 0) initialIndex = 52;

              await showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  final controller = FixedExtentScrollController(initialItem: initialIndex);
                  return SizedBox(
                    height: 300,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('주차 선택', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: ListWheelScrollView.useDelegate(
                            controller: controller,
                            itemExtent: 50,
                            physics: const FixedExtentScrollPhysics(),
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (ctx, i) {
                                final wStart = weeks[i];
                                final wEnd = wStart.add(const Duration(days: 6));
                                return GestureDetector(
                                  onTap: () {
                                    _onDateSelected(wStart);
                                    Navigator.of(ctx).pop();
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Center(
                                    child: Text(
                                      '${_formatDate(wStart)} ~ ${_formatDate(wEnd)}',
                                      style: textTheme.bodyMedium,
                                    ),
                                  ),
                                );
                              },
                              childCount: weeks.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            type: ButtonType.white,
            height: 36,
            padding: EdgeInsets.zero,
            child: Text(
              '${_formatDate(firstDayOfWeek)} ~ ${_formatDate(lastDayOfWeek)}',
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CustomButton(
                onPressed: _onPreviousWeek,
                child: const Icon(Icons.arrow_back_ios, size: 18),
                type: ButtonType.white,
                width: 36,
                height: 36,
                padding: EdgeInsets.zero,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: weekDates.map((date) {
                    final isSelected = DateUtils.isSameDay(date, selectedDate);
                    final isToday = DateUtils.isSameDay(date, today);
                    final circleColor = isSelected
                        ? colors.primary
                        : colors.surfaceVariant;
                    final border = isToday && !isSelected
                        ? Border.all(color: colors.primary, width: 1.2)
                        : null;

                    return GestureDetector(
                      onTap: () => _onDateSelected(date),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _getKoreanWeekday(date),
                            style: textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? colors.primary
                                  : colors.onSurfaceVariant,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: circleColor,
                              shape: BoxShape.circle,
                              border: border,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day}',
                            style: textTheme.labelSmall?.copyWith(
                              color: isSelected
                                  ? colors.primary
                                  : colors.onSurfaceVariant,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              CustomButton(
                onPressed: _onNextWeek,
                child: const Icon(Icons.arrow_forward_ios, size: 18),
                type: ButtonType.white,
                width: 36,
                height: 36,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
