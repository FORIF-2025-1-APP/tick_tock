import 'package:flutter/material.dart';

// Define an enum for button types for better type safety and readability
enum ButtonType { primary, secondary }

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool autofocus;
  final Widget child;
  final ButtonType type;

  const CustomButton({
    super.key,
    required this.onPressed, // onPressed is usually required for a button
    this.onLongPress,
    this.autofocus = false, // Default autofocus to false
    required this.child,
    this.type = ButtonType.primary, // Default type to primary
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    // Define styles based on the type
    ButtonStyle style;
    switch (type) {
      case ButtonType.primary:
        style = ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary, // Text color for primary
          // Add other primary styling if needed
          shape: RoundedRectangleBorder(
            // Maintain rounded corners if desired
            borderRadius: BorderRadius.circular(20),
          ),
        );
        break;
      case ButtonType.secondary:
        style = ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary, // Text color for secondary
          // Add other secondary styling if needed
          shape: RoundedRectangleBorder(
            // Maintain rounded corners if desired
            borderRadius: BorderRadius.circular(20),
          ),
        );
        break;
      // Add cases for other types if necessary
    }

    return ElevatedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      autofocus: autofocus,
      style: style,
      child: child,
    );
  }
}
