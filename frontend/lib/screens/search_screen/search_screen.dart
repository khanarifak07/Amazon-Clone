import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/models/product.model.dart';
import 'package:frontend/widgets/address_box.dart';
import 'package:frontend/widgets/searched_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  final String searchQuery;
  const SearchScreen({super.key, required this.searchQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = false;
  List<ProductModel>? products;

  void navigateToSearchScreen(String query) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SearchScreen(searchQuery: query)));
  }

  Future<List<ProductModel>?> fetchSearchedProduct({
    required String searchQuery,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });
      //get the saved access token
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('accessToken');
      //create dio instance
      Dio dio = Dio();
      //no need to create form data as we are not passing any data
      //make dio get request
      Response response = await dio.get(searchProductApi(searchQuery),
          options: Options(headers: {"Authorization": "Bearer $token"}));

      //handle the response
      if (response.statusCode == 200) {
        List<dynamic> productDataList = response.data['data'];
        List<ProductModel> products = productDataList
            .map((productsData) => ProductModel.fromMap(productsData))
            .toList();
        log("product searched successfully ${response.data}");
        //first approach to assign value to global variable(this)
        setState(() {
          this.products = products;
        });

        return products;
      } else {
        log("something went wrong while searching product ${response.statusCode}");
      }
    } catch (e) {
      log("error while searching product $e");
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
    fetchSearchedProduct(searchQuery: widget.searchQuery.trim());
    //second approach to assing global product varialble to fetch product values
    /*   .then((fetchProducts) {
      setState(() {
        products = fetchProducts;
      });
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: GlobalVariables.appBarGradient,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    alignment: Alignment.topLeft,
                    width: 300,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: TextField(
                      onSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 10),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: GlobalVariables.selectedNavBarColor)),
                        hintText: "Search Amazon.in",
                      ),
                    ),
                  ),
                  const Icon(Icons.mic, color: Colors.black)
                ],
              ),
            )),
        body: products != null
            ? Column(
                children: [
                  const AddressBox(),
                  const SizedBox(height: 10),
                  Expanded(
                      child: ListView.builder(
                          itemCount: products!.length,
                          itemBuilder: (context, index) {
                            final productData = products![index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SearchedProduct(productModel: productData),
                            );
                          }))
                ],
              )
            : const CircularProgressIndicator());
  }
}
