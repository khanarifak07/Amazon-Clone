import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final int? maxLines;
  final TextEditingController controller;
  const CustomTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
        hintText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
