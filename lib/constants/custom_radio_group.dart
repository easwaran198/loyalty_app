import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRadioGroup extends StatelessWidget {
  final List<String> options; // Dynamic data list
  final String? selectedValue;
  final Function(String?) onChanged;
  final Color textColor;
  final Color backgroundColor;
  final TextStyle? fontStyle;
  final String hint;

  const CustomRadioGroup({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.hint,
    required this.onChanged,
    this.textColor = Colors.black,
    this.backgroundColor = const Color(0x66000000),
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xffFFDEDE),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hint,
            style: GoogleFonts.comicNeue(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ...options.map((option) {
            return RadioListTile<String>(
              value: option,
              groupValue: selectedValue,
              onChanged: onChanged,
              activeColor: textColor,
              contentPadding: EdgeInsets.zero,
              title: Text(
                option,
                style: fontStyle ??
                    GoogleFonts.comicNeue(
                      color: textColor,
                      fontSize: 16,
                    ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
