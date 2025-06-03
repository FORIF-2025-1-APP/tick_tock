import 'package:flutter/material.dart';
import '../core/ui/CustomButton.dart';

// 주차 표시(EX - 2025/05/01 ~ 2025/05/07) -> 터치해서 주차 옮길 수 있음
// 일~토 순으로 나열, 주차 이동버튼
// 특정 날짜에 대한 투두 나와야함

class WeekNavigator extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  const WeekNavigator({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onPreviousWeek,
    required this.onNextWeek,
  }) : super(key: key);

  // 한국어 요일 배열
  static const List<String> _koreanWeekdays = ['일', '월', '화', '수', '목', '금', '토'];

  // 주의 첫째 날(일요일) 계산
  DateTime _findFirstDayOfTheWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday % 7));
  }

  // 한국어 요일 문자열 반환
  String _getKoreanWeekday(DateTime date) {
    return _koreanWeekdays[date.weekday % 7];
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
          // 1) 주간 범위 표시 버튼 (CustomButton 사용)
          CustomButton(
            onPressed: () async {
              // 선택된 주차 기준으로 52주 전후 리스트 생성
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
                                    onDateSelected(wStart);
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
            child: Text(
              '${_formatDate(firstDayOfWeek)} ~ ${_formatDate(lastDayOfWeek)}',
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            type: ButtonType.white,
            height: 36,
            padding: EdgeInsets.zero,
          ),

          const SizedBox(height: 8),

          // 2) 요일별 날짜 네비게이터
          Row(
            children: [
              // 이전 주 버튼
              CustomButton(
                onPressed: onPreviousWeek,
                child: const Icon(Icons.arrow_back_ios, size: 18),
                type: ButtonType.white,
                width: 36,
                height: 36,
                padding: EdgeInsets.zero,
              ),

              // 요일별 칼럼
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: weekDates.map((date) {
                    final isSelected = DateUtils.isSameDay(date, selectedDate);
                    final isToday = DateUtils.isSameDay(date, today);

                    final circleColor = isSelected ? colors.primary : colors.surfaceVariant;
                    final border = (isToday && !isSelected)
                        ? Border.all(color: colors.primary, width: 1.2)
                        : null;

                    return GestureDetector(
                      onTap: () => onDateSelected(date),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 요일 텍스트
                          Text(
                            _getKoreanWeekday(date),
                            style: textTheme.bodySmall?.copyWith(
                              color: isSelected ? colors.primary : colors.onSurfaceVariant,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // 날짜를 감싸는 빈 원
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
                          // 날짜 숫자
                          Text(
                            '${date.day}',
                            style: textTheme.labelSmall?.copyWith(
                              color: isSelected ? colors.primary : colors.onSurfaceVariant,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              // 다음 주 버튼
              CustomButton(
                onPressed: onNextWeek,
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