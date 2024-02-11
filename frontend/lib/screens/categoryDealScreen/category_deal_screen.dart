import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/models/product.model.dart';
import 'package:frontend/widgets/single_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryDealScreen extends StatefulWidget {
  final String category;
  const CategoryDealScreen({super.key, required this.category});

  @override
  State<CategoryDealScreen> createState() => _CategoryDealScreenState();
}

class _CategoryDealScreenState extends State<CategoryDealScreen> {
  List<ProductModel>? products;
  Future<List<ProductModel>?> getProductsByCategory({
    required String category,
  }) async {
    try {
      //get the access token from shared preference
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('accessToken');
      //create dio instance
      Dio dio = Dio();
      //make dio get request
      Response response = await dio.get(
        getProductsByCategoryApi(category),
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      //handle the response
      if (response.statusCode == 200) {
        List<dynamic> productDataList = response.data['data'];
        List<ProductModel> products = productDataList
            .map((productData) => ProductModel.fromMap(productData))
            .toList();
        log("Products by category fetched successfully ${response.data}");

        return products;
      } else {
        log("Error while fetching products by category ${response.statusCode}");
      }
    } catch (e) {
      log("Error while showing products by category $e");
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getProductsByCategory(category: widget.category).then((fetchedProducts) {
      setState(() {
        products = fetchedProducts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Text(
            widget.category,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: products == null
          ? const CircularProgressIndicator()
          : Column(
              children: [
                Center(
                  child: Text("Keep shopping for ${widget.category}"),
                ),
                SizedBox(
                  height: 200,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1.4,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: products!.length,
                    itemBuilder: (context, index) {
                      final productsData = products![index];
                      return Column(
                        children: [
                          SizedBox(
                            height: 120,
                            child: SingleProduct(image: productsData.images[0]),
                          ),
                          const SizedBox(height: 6),
                          Text(productsData.name)
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
