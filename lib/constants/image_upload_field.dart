import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loyalty_app/constants/constants.dart';
import 'package:path/path.dart' as path;

class ImageUploadField extends StatefulWidget {
  final Function(String base64Value) onImageSelected;

  // Add labelText param with default value
  final String labelText;

  const ImageUploadField({
    super.key,
    required this.onImageSelected,
    this.labelText = "Select an image",
  });

  @override
  _ImageUploadFieldState createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  File? _selectedImage;
  String? _fileName;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _fileName = path.basename(image.path);
      });

      final bytes = await _selectedImage!.readAsBytes();
      String base64Image = base64Encode(bytes);
      widget.onImageSelected(base64Image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: lightRed,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.upload_file, color: Colors.black),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _fileName ?? widget.labelText,   // Use widget.labelText here
                style: TextStyle(
                  color: _fileName != null ? Colors.black : Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (_selectedImage != null)
              const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
