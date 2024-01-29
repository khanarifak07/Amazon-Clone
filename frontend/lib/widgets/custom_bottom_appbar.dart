import 'package:flutter/material.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/models/profile.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomBottomAppBar extends StatefulWidget {
  const CustomBottomAppBar({super.key});

  @override
  State<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  ProfileModel? model;
  bool isDataLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<void> getData() async {
    //get the saved user data from share preferene
    var prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('currentUser');
    if (user != null) {
      model = ProfileModel.fromJson(user);
    }
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return model != null
        ? Container(
            height: 50,
            width: double.maxFinite,
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: RichText(
                  text: TextSpan(
                      text: "Hello,\t",
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 30,
                          color: Colors.black),
                      children: [
                    TextSpan(
                        text: model!.username,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black)),
                  ])),
            ),
          )
        : isDataLoaded
            ? const Center(
                child: Text(
                    "something went wrong while fetching current user data"),
              )
            : const CircularProgressIndicator();
  }
}
