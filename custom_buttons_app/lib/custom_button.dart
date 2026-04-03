import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, outline, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final IconData? icon;
  final bool isLoading;
  final ButtonVariant variant;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.icon,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
  });

  // Decide colours based on the chosen variant
  Color _bgColor(BuildContext ctx) {
    if (color != null) return color!;
    switch (variant) {
      case ButtonVariant.primary:
        return Theme.of(ctx).colorScheme.primary;
      case ButtonVariant.secondary:
        return Theme.of(ctx).colorScheme.secondary;
      case ButtonVariant.outline:
      case ButtonVariant.text:
        return Colors.transparent;
    }
  }

  Color _fgColor(BuildContext ctx) {
    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
        return Colors.white;
      case ButtonVariant.outline:
        return color ?? Theme.of(ctx).colorScheme.primary;
      case ButtonVariant.text:
        return color ?? Theme.of(ctx).colorScheme.primary;
    }
  }

  Widget _buildChild(Color fg) {
    // Show a small spinner while loading
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(fg),
        ),
      );
    }

    if (icon == null) return Text(text);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 18), const SizedBox(width: 8), Text(text)],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = _bgColor(context);
    final fg = _fgColor(context);

    final style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return bg.withOpacity(0.4);
        }
        return bg;
      }),
      foregroundColor: WidgetStateProperty.all(fg),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (variant == ButtonVariant.outline || variant == ButtonVariant.text) {
          return 0;
        }
        return states.contains(WidgetState.pressed) ? 6 : 2;
      }),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: variant == ButtonVariant.outline
              ? BorderSide(color: fg, width: 2)
              : BorderSide.none,
        ),
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
      overlayColor: WidgetStateProperty.all(fg.withOpacity(0.12)),
      animationDuration: const Duration(milliseconds: 150),
    );

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: _buildChild(fg),
    );
  }
}

/// A bold, filled primary button.
class PrimaryButton extends CustomButton {
  const PrimaryButton({
    super.key,
    required super.text,
    required super.onPressed,
    super.icon,
    super.isLoading,
    super.color,
  }) : super(variant: ButtonVariant.primary);
}

/// A softer secondary button.
class SecondaryButton extends CustomButton {
  const SecondaryButton({
    super.key,
    required super.text,
    required super.onPressed,
    super.icon,
    super.isLoading,
    super.color,
  }) : super(variant: ButtonVariant.secondary);
}

/// A bordered outline button with no fill.
class OutlineButton extends CustomButton {
  const OutlineButton({
    super.key,
    required super.text,
    required super.onPressed,
    super.icon,
    super.isLoading,
    super.color,
  }) : super(variant: ButtonVariant.outline);
}

/// A flat text-only button (no border, no fill).
class TextOnlyButton extends CustomButton {
  const TextOnlyButton({
    super.key,
    required super.text,
    required super.onPressed,
    super.icon,
    super.isLoading,
    super.color,
  }) : super(variant: ButtonVariant.text);
}
