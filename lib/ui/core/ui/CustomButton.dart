import 'package:flutter/material.dart';

// Define an enum for button types for better type safety and readability
enum ButtonType { black, white }

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool autofocus;
  final Widget child;
  final ButtonType type;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.onPressed, // onPressed is usually required for a button
    this.autofocus = false, // Default autofocus to false
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.type = ButtonType.black, // Default type to primary
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final textStyle = Theme.of(
      context,
    ).textTheme.labelLarge?.copyWith(fontSize: 13);

    // Define styles based on the type
    ButtonStyle style;
    switch (type) {
      case ButtonType.black:
        style = ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary, // Text color for primary
          textStyle: textStyle,
          // fixedSize: const Size(320, 55),
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
          // Add other primary styling if needed
          shape: RoundedRectangleBorder(
            // Maintain rounded corners if desired
            borderRadius: BorderRadius.circular(5),
          ),
        );
        break;
      case ButtonType.white:
        style = ElevatedButton.styleFrom(
          backgroundColor: colorScheme.onPrimary,
          foregroundColor: colorScheme.primary, // Text color for secondary
          textStyle: textStyle,
          // fixedSize: const Size(320, 55),
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
          // Add other secondary styling if needed
          shape: RoundedRectangleBorder(
            // Maintain rounded corners if desired
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: colorScheme.outline, width: 1.2),
          ),
        );
        break;
      // Add cases for other types if necessary
    }

    return SizedBox(
      width: width ?? 320,
      height: height ?? 55,
      child: ElevatedButton(
        onPressed: onPressed,
        autofocus: autofocus,
        style: style,
        child: child,
      ),
    );
  }
}
