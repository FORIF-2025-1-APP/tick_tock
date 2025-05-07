import 'package:flutter/material.dart';

enum ChipType { normal, deletable }

class CustomChips extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ChipType type;
  final VoidCallback? onDelete;

  const CustomChips({
    Key? key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.type = ChipType.normal,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: type == ChipType.deletable ? 70 : 56,
        height: type == ChipType.deletable ? 30 : 30,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        padding:
            type == ChipType.deletable
                ? const EdgeInsets.symmetric(horizontal: 10)
                : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(
            type == ChipType.deletable ? 8 : 8,
          ),
        ),
        child:
            type == ChipType.deletable
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color:
                            selected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        if (onDelete != null) onDelete!();
                      },
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color:
                            selected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                )
                : Center(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                          selected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
      ),
    );
  }
}
