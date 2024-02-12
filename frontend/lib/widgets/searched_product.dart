import 'package:flutter/material.dart';
import 'package:frontend/models/product.model.dart';

class SearchedProduct extends StatelessWidget {
  final ProductModel productModel;
  const SearchedProduct({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        child: Row(
          children: [
            SizedBox(
              height: 150,
              child: Image.network(productModel.images[0]),
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                Text(
                  productModel.name,
                  style: const TextStyle(fontSize: 16),
                ),
                Text('\$\t${productModel.price.toString()}'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
