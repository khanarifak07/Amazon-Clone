import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/constants/global_variables.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  const RatingStars({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
        direction: Axis.horizontal,
        itemCount: 5,
        itemSize: 15,
        rating: rating,
        itemBuilder: (context, index) {
          return const Icon(
            Icons.star,
            color: GlobalVariables.secondaryColor,
          );
        });
  }
}
