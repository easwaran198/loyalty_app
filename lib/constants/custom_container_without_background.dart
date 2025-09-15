import 'package:flutter/material.dart';

class CustomKeyValueContainerWithoutBg extends StatelessWidget {
  final Widget label;
  final Widget value;
  final double colonSpacing;

  const CustomKeyValueContainerWithoutBg({
    super.key,
    required this.label,
    required this.value,
    this.colonSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Label
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerLeft,
              child: label,
            ),
          ),

          /// Colon
          Padding(
            padding: EdgeInsets.symmetric(horizontal: colonSpacing / 2),
            child: const Text(
              ":",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          /// Value
          Expanded(
            flex: 6,
            child: Align(
              alignment: Alignment.centerLeft,
              child: value,
            ),
          ),
        ],
      ),
    );
  }
}
