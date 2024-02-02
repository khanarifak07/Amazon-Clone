import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:frontend/models/product.model.dart';
import 'package:frontend/screens/admin_screens/add_product_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isLoading = false;

  Future<List<ProductModel>?> getAllProducts() async {
    try {
      setState(() {
        isLoading = true;
      });
      //get the access token from shared preference
      var prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('accessToken');

      //create dio instance
      Dio dio = Dio();
      //no need to send data as we are getting the products
      //make dio get request
      Response response = await dio.get(getAllProductsApi,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      //handle the response
      if (response.statusCode == 200) {
        // Parse the response data into a list of ProductModel
        List<dynamic> productDataList = response.data['data'];
        List<ProductModel> products = productDataList
            .map((productData) => ProductModel.fromMap(productData))
            .toList();
        log("All products fetched successfully ${response.data}");
        return products;
      } else {
        log("Error while fetching all products ${response.statusCode}");
      }
    } catch (e) {
      print("Error while getting all products $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return null;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getAllProducts(),
          builder: (context, snapshot) {
            print("Snapshot Data: ${snapshot.data}");

            if (snapshot.hasError) {
              return Center(child: Text("Error ${snapshot.error}"));
            } else if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.isEmpty) {
                return const Center(child: Text("No products found"));
              } else {
                return ListView(
                  children: snapshot.data!
                      .map((e) => ListTile(
                            title: Text(e.name),
                            subtitle: Column(
                              children: [
                                Text(e.description),
                                Text(e.price.toString()),
                                Text(e.quantity.toString()),
                              ],
                            ),
                          ))
                      .toList(),
                );
              }
            } else {
              return const Center(child: Text("No data available"));
            }
          })

     /*  Column(
        children: [
          TextButton(
              onPressed: () async {
                await getAllProducts();
              },
              child: const Text("Get all products")),
          GestureDetector(
            onTap: isLoading
                ? null
                : () async {
                    await logoutUser();
                    //remove the saved access token
                    var prefs = await SharedPreferences.getInstance();
                    prefs.remove('accessToken');
                    //remove the user type
                    prefs.remove('type');
                    //check the saved access token
                    var prefss = await SharedPreferences.getInstance();
                    final String? token = prefss.getString('accessToken');
                    final String? userType = prefss.getString('type');
                    print("Access token after logout $token");
                    print("user type after logout $userType");

                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AuthScreen()),
                          (route) => false);
                    }
                  },
            child: Container(
              height: 50,
              width: 180,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                  color: GlobalVariables.greyBackgroundColor,
                  borderRadius: BorderRadius.circular(30)),
              child: const Center(
                child: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ) */
      ,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => const AddProductScreen()));
        },
        tooltip: "Add a product",
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
