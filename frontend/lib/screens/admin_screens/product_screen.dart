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
        setState(() {
          this.products = products;
        });
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
    // TODO: implement initState
    super.initState();
    getAllProducts().then((fetchedProducts) {
      setState(() {
        products = fetchedProducts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: GridView.builder(
                // padding: const EdgeInsets.all(30),
                itemCount: products!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5 / 2,
                ),
                itemBuilder: (context, index) {
                  final productsData = products![index];
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 180,
                        child: SingleProduct(image: productsData.images[0]),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(productsData.name),
                          IconButton(
                              onPressed: () async {
                                setState(() {
                                  deletedProduct(id: productsData.id);
                                  getAllProducts();
                                });
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                              ))
                        ],
                      )
                    ],
                  );
                })

            /* FutureBuilder(
          future: getAllProducts(),
          builder: (context, snapshot) {
            print("Snapshot Data: ${snapshot.data}");

            if (snapshot.hasError) {
              return Center(child: Text("Error ${snapshot.error}"));
            } else if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data!.isEmpty) {
                return const Center(child: Text("No products found"));
              } else {
                return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return null;
                        })

                    /* ListView(
                  children: snapshot.data!
                      .map(
                        (e) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 140,
                              child: SingleProduct(
                                image: e.images[0],
                              ),
                            )
                          ],
                        )

                        /* ListTile(
                          title: Text(e.name),
                          subtitle: Column(
                            children: [
                              Text(e.description),
                              Text(e.price.toString()),
                              Text(e.quantity.toString()),
                            ],
                          ),
                        ) */
                        ,
                      )
                      .toList(),
                ) */
                    ;
              }
            } else {
              return const Center(child: Text("No data available"));
            }
          }) */

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
                            builder: (context) => const AddProductScreen()))
                    .then((value) {
                  setState(() {
                    getAllProducts();
                  });
                });
              },
              tooltip: "Add a product",
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
