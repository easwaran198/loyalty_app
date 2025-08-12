import 'package:flutter/material.dart';

class KeyValueContainer extends StatelessWidget {
  final String label;
  final String value;
  final Color backgroundColor;
  final Color textColor1;
  final Color textColor2;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double fontSize;

  const KeyValueContainer({
    super.key,
    required this.label,
    required this.value,
    this.backgroundColor = const Color(0xFFE0E0E0),
    required this.textColor1,
    required this.textColor2,
    required this.borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label + " :",
            style: TextStyle(
              color: textColor1,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: textColor2,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
