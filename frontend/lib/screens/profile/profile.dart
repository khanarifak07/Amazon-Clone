import 'package:flutter/material.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/widgets/custom_bottom_appbar.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
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
                  alignment: Alignment.topLeft,
                  width: 120,
                  height: 45,
                  child: Image.asset(
                    'assets/images/amazon_in.png',
                    color: Colors.black,
                  ),
                ),
                Container(
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
                )
              ],
            ),
          )),
      body: const Column(
        children: [
          CustomBottomAppBar(),
        ],
      ),
    );
  }
}
