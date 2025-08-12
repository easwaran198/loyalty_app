import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart'; // Add in pubspec.yaml

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isPassword;
  final Color textColor;
  final Color backgroundColor;
  final TextStyle? fontStyle;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.keyboardType,
    this.inputFormatters,
    this.isPassword = false,
    this.textColor = Colors.white,
    this.backgroundColor = const Color(0x66000000), // semi-transparent black
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: fontStyle ??
          GoogleFonts.comicNeue( // Comic Neue font style
            color: textColor,
            fontSize: 16,
          ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: textColor),
        labelStyle: GoogleFonts.comicNeue(
          color: Colors.black,
          fontSize: 14,
        ),
        hintText: "Enter your $label",
        hintStyle: GoogleFonts.comicNeue(
          color: textColor.withOpacity(0.5),
        ),
        filled: true,
        fillColor: backgroundColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey, width: 0.1),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }
}
