import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/screens/home/homepage.dart';
import 'package:frontend/screens/profile/profile.dart';

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
    const Center(
      child: Text("Cart Page"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: const badges.Badge(
                badgeContent: Text("2"),
                badgeStyle: badges.BadgeStyle(badgeColor: Colors.white),
                child: Icon(Icons.shopping_cart_outlined),
              ),
            ),
            label: "",
          ),
        ],
      ),
      body: pages[pageIndex],
    );
  }
}
