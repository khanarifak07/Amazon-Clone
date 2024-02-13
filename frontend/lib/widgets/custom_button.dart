import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final VoidCallback ontap;
  final Widget child;
  final Color? color;
  const CustomButtom(
      {super.key, required this.ontap, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(
            double.maxFinite,
            50,
          )),
      child: child,
    );
  }
}
