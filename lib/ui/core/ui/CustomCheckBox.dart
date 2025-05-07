import 'package:flutter/material.dart';

enum CheckBoxType { label, noLabel }

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String? label;
  final CheckBoxType type;
  final double? width;
  final double? height;

  const CustomCheckBox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.label,
    this.type = CheckBoxType.label,
    this.width,
    this.height = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 14);

    return SizedBox(
      width: width,
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: colorScheme.primary,
            checkColor: colorScheme.onPrimary,
            side: BorderSide(color: colorScheme.outline, width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          if (type == CheckBoxType.label && label != null) ...[
            const SizedBox(width: 8),
            Text(label!, style: textStyle),
          ],
        ],
      ),
    );
  }
}
