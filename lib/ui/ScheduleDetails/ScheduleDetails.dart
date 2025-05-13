import 'package:flutter/material.dart';
import '../core/ui/CustomCheckBox.dart';
import '../ScheduleAdd/ScheduleAdd.dart';

class ScheduleDetails extends StatefulWidget {
  final DateTime date;

  const ScheduleDetails({super.key, required this.date});

  @override
  State<ScheduleDetails> createState() => _ScheduleDetailsState();
}

class _ScheduleDetailsState extends State<ScheduleDetails> {
  final List<bool> isCheckedList = [true, true, true]; // 초기값 설정

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
      child: SingleChildScrollView(
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ScheduleAdd(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text("Todo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...List.generate(3, (i) {
              return CustomCheckBox(
                value: isCheckedList[i],
                onChanged: (val) {
                  setState(() {
                    isCheckedList[i] = val ?? false;
                  });
                },
                label: 'List item ${i + 1}',
                type: CheckBoxType.label,
              );
            }),
            const SizedBox(height: 16),
            const Text("Schedule", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...List.generate(3, (i) {
              return ListTile(
                title: Text("List item ${i + 1}"),
                trailing: const Icon(Icons.chevron_right),
                onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ScheduleAdd(),
                  ),
                );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
