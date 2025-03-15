import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';

class GradientElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text; 
  final List<Color> gradientColors; 
  final List<Color>? disabledGradientColors;
  final double borderRadius;
  final TextStyle textStyle; 
  final TextStyle? disabledTextStyle;
  final bool isEnabled;

  const GradientElevatedButton({
    required this.onPressed,
    required this.text,
    this.gradientColors = const [jvButtonL, jvButtonR],
    this.disabledGradientColors,
    this.borderRadius = 10,
    this.textStyle = const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    this.disabledTextStyle,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = isEnabled
        ? gradientColors
        : disabledGradientColors ?? [Colors.grey, Colors.grey.shade700];

    final style = isEnabled
        ? textStyle
        : disabledTextStyle ?? textStyle.copyWith(color: Colors.grey.shade400);

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.6,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              text,
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}