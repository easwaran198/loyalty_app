import 'package:flutter/material.dart';
import 'package:loyalty_app/constants/constants.dart';

class CustomButton extends StatelessWidget {
  final IconData? prefixIcon;
  final String? prefixImage;
  final IconData? suffixIcon;
  final String? suffixImage;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final VoidCallback onPressed;
  final double horizontalvalue;
  final double fontSize;

  const CustomButton({
    super.key,
    this.prefixIcon,
    this.prefixImage,
    this.suffixIcon,
    this.suffixImage,
    required this.text,
    required this.horizontalvalue,
    required this.fontSize,
    required this.backgroundColor,
    required this.textColor,
    this.borderRadius = 25.0,
    required this.onPressed,
  });

  Widget? _buildPrefix() {
    if (prefixImage != null) {
      return Image.asset(prefixImage!, height: 20, width: 20);
    } else if (prefixIcon != null) {
      return Icon(prefixIcon, color: textColor, size: 20);
    }
    return null;
  }

  Widget? _buildSuffix() {
    if (suffixImage != null) {
      return Image.asset(suffixImage!, height: 20, width: 20);
    } else if (suffixIcon != null) {
      return Icon(suffixIcon, color: textColor, size: 20);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: horizontalvalue, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_buildPrefix() != null) ...[
            _buildPrefix()!,
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: FontWeight.w500),
          ),
          if (_buildSuffix() != null) ...[
            const SizedBox(width: 8),
            _buildSuffix()!,
          ],
        ],
      ),
    );
  }
}
