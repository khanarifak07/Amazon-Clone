import 'package:flutter/material.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/models/product.model.dart';
import 'package:frontend/screens/product_details_page/products_details_page.dart';
import 'package:frontend/widgets/ratings.dart';

class SearchedProduct extends StatelessWidget {
  final ProductModel productModel;
  const SearchedProduct({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailsPage(productModel: productModel)));
        },
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                height: 150,
                child: Image.network(productModel.images[0]),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productModel.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 5),
                  const RatingStars(rating: 4),
                  const SizedBox(height: 5),
                  Text(
                    '\$\t${productModel.price.toString()}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text("Eligible for FREE shipping"),
                  const SizedBox(height: 5),
                  Text(
                    "In Stock",
                    style:
                        TextStyle(color: GlobalVariables.selectedNavBarColor),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
