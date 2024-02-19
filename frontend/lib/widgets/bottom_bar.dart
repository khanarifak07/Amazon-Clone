import 'dart:developer';

import 'package:badges/badges.dart' as badges;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/models/user.model.dart';
import 'package:frontend/screens/cart/cart_page.dart';
import 'package:frontend/screens/home/homepage.dart';
import 'package:frontend/screens/profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int pageIndex = 0;
  List<Widget> pages = [
    const HomePage(),
    const Profile(),
    const CartPage(),
  ];
  UserModel? userModel;
  bool isLoaded = false;

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
        log("Current user fetched successfully on bottom bar ${response.data}");
        if (response.data != null) {
          setState(() {
            userModel = UserModel.fromMap(response.data['data']);
          });
          print(userModel);
        }
      } else {
        log("Error while gettign current user on bottom bar ${response.statusCode}");
      }
    } catch (e) {
      print("error while getting current user $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: userModel != null
            ? Scaffold(
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: pageIndex,
                  selectedItemColor: GlobalVariables.selectedNavBarColor,
                  unselectedItemColor: GlobalVariables.unselectedNavBarColor,
                  iconSize: 28,
                  onTap: (value) {
                    setState(() {
                      pageIndex = value;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Container(
                        width: 42,
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                            color: pageIndex == 0
                                ? GlobalVariables.selectedNavBarColor
                                : GlobalVariables.backgroundColor,
                            width: 5,
                          )),
                        ),
                        child: const Icon(Icons.home_outlined),
                      ),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        width: 42,
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                            color: pageIndex == 1
                                ? GlobalVariables.selectedNavBarColor
                                : GlobalVariables.backgroundColor,
                            width: 5,
                          )),
                        ),
                        child: const Icon(Icons.person_outlined),
                      ),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        width: 42,
                        decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                            color: pageIndex == 2
                                ? GlobalVariables.selectedNavBarColor
                                : GlobalVariables.backgroundColor,
                            width: 5,
                          )),
                        ),
                        child: badges.Badge(
                          badgeContent:
                              Text(userModel!.cart!.length.toString()),
                          badgeStyle:
                              const badges.BadgeStyle(badgeColor: Colors.white),
                          child: const Icon(Icons.shopping_cart_outlined),
                        ),
                      ),
                      label: "",
                    ),
                  ],
                ),
                body: pages[pageIndex],
              )
            : isLoaded
                ? const Scaffold()
                : const Text("Error while getting the current user details"));
  }
}
