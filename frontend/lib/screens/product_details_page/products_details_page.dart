import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/config.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/models/product.model.dart';
import 'package:frontend/screens/search_screen/search_screen.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/ratings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel productModel;
  const ProductDetailsPage({super.key, required this.productModel});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  void navigateToSearchScreen(String query) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SearchScreen(searchQuery: query)));
  }

  void rateProduct({
    required ProductModel productModel,
    required double rating,
  }) async {
    try {
      //get the saved access Token
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('accessToken');
      //create dio instance
      Dio dio = Dio();
      //create formdata
      var data = {
        'prodId': productModel.id,
        'rating': rating,
      };
      /*  FormData formData = FormData.fromMap({
        'id': productModel.id,
        'rating': rating,
      }); */
      //make dio post request
      Response response = await dio.post(rateProductApi,
          data: data,
          options: Options(headers: {"Authorization": "Bearer $token"}));

      //handle the response
      if (response.statusCode == 200) {
        log("Rating given successfully ${response.data}");
      } else {
        log("Error while rating product ${response.statusCode}");
      }
    } catch (e) {
      log("Error while giving rating $e");
    }
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
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.productModel.id),
                  const RatingStars(rating: 4)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.productModel.name,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            CarouselSlider(
                items: widget.productModel.images.map((i) {
                  return Builder(
                      builder: (context) => Image.network(
                            i,
                            fit: BoxFit.cover,
                            height: 200,
                          ));
                }).toList(),
                options: CarouselOptions(viewportFraction: 1, height: 400)),
            const SizedBox(height: 10),
            Container(
              height: 3,
              color: Colors.black12,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                  text: TextSpan(
                      text: "Deal Price:\t\t",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      children: [
                    TextSpan(
                        text: '\$\t${widget.productModel.price}',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 195, 15, 12)))
                  ])),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.productModel.description),
            ),
            Container(
              height: 3,
              color: Colors.black12,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomButtom(ontap: () {}, child: const Text("Buy Now")),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomButtom(
                ontap: () {},
                color: const Color.fromRGBO(254, 216, 19, 1),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Rate the product",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                allowHalfRating: true,
                direction: Axis.horizontal,
                itemBuilder: (context, index) {
                  return const Icon(
                    Icons.star,
                    color: Colors.orangeAccent,
                  );
                },
                onRatingUpdate: (rating) {
                  rateProduct(
                    productModel: widget.productModel,
                    rating: rating,
                  );
                }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
