import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Add in pubspec.yaml

class CustomDatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Color textColor;
  final Color backgroundColor;
  final TextStyle? fontStyle;

  const CustomDatePickerField({
    super.key,
    required this.controller,
    required this.hint,
    this.icon = Icons.calendar_today,
    this.textColor = Colors.black,
    this.backgroundColor = const Color(0x66000000),
    this.fontStyle,
  });

  @override
  State<CustomDatePickerField> createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // Calendar header background color
              onPrimary: Colors.white, // Calendar header text color
              onSurface: Colors.black, // Calendar body text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      widget.controller.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      readOnly: true,
      onTap: () => _selectDate(context),
      style: widget.fontStyle ??
          GoogleFonts.comicNeue(
            color: widget.textColor,
            fontSize: 16,
          ),
      decoration: InputDecoration(
        prefixIcon: Icon(widget.icon, color: Colors.black),
        labelStyle: GoogleFonts.comicNeue(
          color: Colors.black,
          fontSize: 14,
        ),
        hintText: widget.hint,
        hintStyle: GoogleFonts.comicNeue(
          color: Colors.black,
        ),
        filled: true,
        fillColor:Color(0xffFFDEDE),
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
