import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:frontend/models/product.model.dart';
import 'package:frontend/screens/admin_screens/add_product_screen.dart';
import 'package:frontend/widgets/single_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isLoading = false;
  List<ProductModel>? products;

  Future<List<ProductModel>?> getAllProducts() async {
    try {
      setState(() {
        isLoading = true;
      });

      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('accessToken');

      Dio dio = Dio();
      Response response = await dio.get(
        getAllProductsApi,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        List<dynamic> productsDataList = response.data['data'];
        List<ProductModel> products = productsDataList
            .map((productsData) => ProductModel.fromMap(productsData))
            .toList();
        log("All Products Fetched Successfully: $products");
        setState(() {
          this.products =
              products; //first approach to assing the global product var to return var data
        });

        return products;
      } else {
        log("Error while fetching all products: ${response.statusCode}");
      }
    } catch (e) {
      log("Error while fetching all products: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return null;
  }

  void deletedProduct({required id}) async {
    try {
      setState(() {
        isLoading = true;
      });
      //get the saved access token
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('accessToken');
      //create dio instance
      Dio dio = Dio();
      //no need to create form data or body
      //make the dio request
      Response response = await dio.delete(deleteProductApi(id),
          options: Options(headers: {"Authorization": "Bearer $token"}));
      //handle the response
      if (response.statusCode == 200) {
        print("Product  Deleted Successfully ${response.data}");
      } else {
        log("error while deleting product ${response.statusCode}");
      }
    } catch (e) {
      log("Error while deleting product $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllProducts();
    //second approach to assign the return products to global variable
    /*  getAllProducts().then((fetchedProducts) {
      setState(() {
        products = fetchedProducts;
      });
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: products != null
          ? GridView.builder(
              padding: const EdgeInsets.all(30),
              itemCount: products!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5 / 2,
                crossAxisSpacing: 20,
                mainAxisExtent: 230,
              ),
              itemBuilder: (context, index) {
                final productsData = products![index];
                return Column(
                  children: [
                    SizedBox(
                      height: 180,
                      child: SingleProduct(image: productsData.images[0]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(productsData.name),
                        IconButton(
                          onPressed: () async {
                            // Delete the product
                            deletedProduct(id: productsData.id);
                            // After deleting, fetch all products again
                            await getAllProducts();
                            // Update the UI with the fetched products
                            setState(() {});
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ],
                );
              },
            )
          : const Center(
              child:
                  CircularProgressIndicator()), // Show loading indicator when products are null
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => const AddProductScreen()),
          );
          setState(() {
            getAllProducts();
          });
        },
        tooltip: "Add a product",
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
