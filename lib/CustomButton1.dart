import 'package:flutter/material.dart';

class CustomButton1 extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool autofocus;
  final Widget child;

  const CustomButton1({
    super.key,
    required this.onPressed, // onPressed is usually required for a button
    this.onLongPress,
    this.autofocus = false, // Default autofocus to false
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    // Define style
    ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary, // Text color for primary
      // Add other primary styling if needed
      shape: RoundedRectangleBorder(
        // Maintain rounded corners if desired
        borderRadius: BorderRadius.circular(20),
      ),
    );

    return ElevatedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      autofocus: autofocus,
      style: style,
      child: child,
    );
  }
}
