import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:frontend/models/user.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  UserModel? userModel;

  void getCurrentUser() async {
    try {
      //get the saved access token
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('accessToken');
      //create dio instance
      Dio dio = Dio();
      //no need to create body or formdata as we are not passing any data
      //make dio get request
      Response response = await dio.get(getCurrentUserApi,
          options: Options(headers: {"Authorization": "Bearer $token"}));
      //handle the response
      if (response.statusCode == 200) {
        log("Current user fetched successfully on cart page${response.data}");
        if (response.data != null) {
          setState(() {
            userModel = UserModel.fromMap(response.data['data']);
          });
        }
      } else {
        log("Error while gettign current user on cart page ${response.statusCode}");
      }
    } catch (e) {
      print("error while getting current user $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Cart Page"),
      ),
    );
  }
}
