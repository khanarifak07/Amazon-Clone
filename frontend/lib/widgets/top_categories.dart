import 'package:flutter/material.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/screens/categoryDealScreen/category_deal_screen.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: GlobalVariables.categoryImages.length,
          itemExtent: 85,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryDealScreen(
                            category: GlobalVariables.categoryImages[index]
                                ['title']!)));
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                          GlobalVariables.categoryImages[index]['image']!),
                    ),
                  ),
                  Text(
                    GlobalVariables.categoryImages[index]['title']!,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            );
          }),
    );
  }
}
