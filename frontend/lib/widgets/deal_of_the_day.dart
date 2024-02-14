import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/models/product.model.dart';
import 'package:frontend/screens/product_details_page/products_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DealOfTheDay extends StatefulWidget {
  const DealOfTheDay({super.key});

  @override
  State<DealOfTheDay> createState() => _DealOfTheDayState();
}

class _DealOfTheDayState extends State<DealOfTheDay> {
  ProductModel? product;
  bool isLoading = false;
  Future<ProductModel?> dealOfTheDay() async {
    try {
      setState(() {
        isLoading = true;
      });
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('accessToken');
      Dio dio = Dio();
      Response response = await dio.get(dealOfTheDayApi,
          options: Options(headers: {"Authorization": "Bearer $token"}));
      if (response.statusCode == 200) {
        log("deal of the day product fetched successfully ${response.data}");
        if (response.data != null) {
          setState(() {
            product = ProductModel.fromMap(response.data['data']);
          });
        } else {
          log("Error: Response data is null");
        }
      } else {
        log("error while fetching deal of the day product ${response.statusCode}");
      }
    } catch (e) {
      log("Error while getting deal of the day $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    dealOfTheDay();
  }

  @override
  Widget build(BuildContext context) {
    return product != null
        ? Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Deal of the day",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsPage(productModel: product!)));
                  },
                  child: Center(
                    child: Image.network(
                      product!.images[0],
                      width: 200,
                    ),
                  ),
                ),
                Text(
                  "\$\t${product!.price}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Text(
                  product!.description,
                ),
                const SizedBox(height: 20),
                Text(
                  "See All Deals",
                  style: TextStyle(
                      color: GlobalVariables.selectedNavBarColor,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Image.network(
                        "https://images.unsplash.com/photo-1682685797742-42c9987a2c34?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxMXx8fGVufDB8fHx8fA%3D%3D",
                        width: 100,
                        fit: BoxFit.fitWidth,
                      ),
                      const SizedBox(width: 10),
                      Image.network(
                        "https://images.unsplash.com/photo-1682685797742-42c9987a2c34?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxMXx8fGVufDB8fHx8fA%3D%3D",
                        width: 100,
                        fit: BoxFit.fitWidth,
                      ),
                      const SizedBox(width: 10),
                      Image.network(
                        "https://images.unsplash.com/photo-1682685797742-42c9987a2c34?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxMXx8fGVufDB8fHx8fA%3D%3D",
                        width: 100,
                        fit: BoxFit.fitWidth,
                      ),
                      const SizedBox(width: 10),
                      Image.network(
                        "https://images.unsplash.com/photo-1682685797742-42c9987a2c34?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxMXx8fGVufDB8fHx8fA%3D%3D",
                        width: 100,
                        fit: BoxFit.fitWidth,
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                )
              ],
            ),
          )
        : const CircularProgressIndicator();
  }
}
