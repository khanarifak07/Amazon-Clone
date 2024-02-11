import 'package:flutter/material.dart';

class SingleProduct extends StatelessWidget {
  final String image;
  const SingleProduct({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 180,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1.5, color: Colors.grey.shade400)),
      child: Image.network(
        image,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
