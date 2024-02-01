import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/screens/admin_screens/product_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
 
  int page = 0;
  List<Widget> pages = [
    const ProductScreen(),
    const Center(
      child: Text("Analytics Page"),
    ),
    const Center(
      child: Text("Cart Page"),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.maxFinite, 50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/amazon_in.png',
                height: 45,
                color: Colors.black,
              ),
              const Text(
                "Admin",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              page = value;
            });
          },
          selectedItemColor: GlobalVariables.selectedNavBarColor,
          unselectedItemColor: GlobalVariables.unselectedNavBarColor,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                  width: 42,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    width: 5,
                    color: page == 0
                        ? GlobalVariables.selectedNavBarColor
                        : Colors.white,
                  ))),
                  child: const Icon(Icons.post_add_outlined)),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Container(
                  width: 42,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    width: 5,
                    color: page == 1
                        ? GlobalVariables.selectedNavBarColor
                        : Colors.white,
                  ))),
                  child: const Icon(Icons.analytics_outlined)),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Container(
                  width: 42,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    width: 5,
                    color: page == 2
                        ? GlobalVariables.selectedNavBarColor
                        : Colors.white,
                  ))),
                  child: const Icon(Icons.all_inbox_outlined)),
              label: "",
            )
          ]),
      body: pages[page],
    );
  }
}
