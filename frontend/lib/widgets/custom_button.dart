import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final Function() ontap;
  final String text;
  const CustomButtom({super.key, required this.ontap, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(
        double.maxFinite,
        50,
      )),
      child: Text(text),
    );
  }
}
