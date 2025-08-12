import 'package:flutter/material.dart';

class CustomKeyValueContainerWithoutBg extends StatelessWidget {
  final Widget label;
  final Widget value;
  final Color backgroundColor;
  final double borderRadius;
  final double colonSpacing;

  const CustomKeyValueContainerWithoutBg({
    super.key,
    required this.label,
    required this.value,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.borderRadius = 8.0,
    this.colonSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: screenWidth * 0.2,
            alignment: Alignment.centerLeft,
            child: Flexible(child: label),
          ),
          SizedBox(width: screenWidth * 0.01),
          Container(
            width: screenHeight * 0.04,
            child: const Text(
              ":",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: screenWidth * 0.2,
            child: Flexible(child: value),
          ),
        ],
      ),
    );
  }
}
