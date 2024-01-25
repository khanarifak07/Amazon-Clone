import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final VoidCallback ontap;
  final Widget child;
  const CustomButtom({super.key, required this.ontap, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(
        double.maxFinite,
        50,
      )),
      child: child,
    );
  }
}
