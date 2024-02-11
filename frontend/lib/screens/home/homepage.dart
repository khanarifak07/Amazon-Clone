import 'package:flutter/material.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/screens/search_screen/search_screen.dart';
import 'package:frontend/widgets/address_box.dart';
import 'package:frontend/widgets/carousel_image.dart';
import 'package:frontend/widgets/deal_of_the_day.dart';
import 'package:frontend/widgets/top_categories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void navigateToSearchScreen(String query) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchScreen(searchQuery: query)));
  }

  TextEditingController searchCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
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
                  /*  Container(
                    child: const Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(width: 20),
                          Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ) */
                ],
              ),
            )),
        body: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddressBox(),
              SizedBox(height: 10),
              TopCategories(),
              SizedBox(height: 10),
              CarouselImage(),
              SizedBox(height: 10),
              DealOfTheDay()
            ],
          ),
        ));
  }
}
