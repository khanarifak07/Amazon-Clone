import 'package:flutter/material.dart';
import 'package:frontend/models/profile.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressBox extends StatefulWidget {
  const AddressBox({super.key});

  @override
  State<AddressBox> createState() => _AddressBoxState();
}

class _AddressBoxState extends State<AddressBox> {
  ProfileModel? model;
  bool isDataLoaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<void> getData() async {
    //get the current user data from shared preference
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
            height: 40,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 114, 226, 221),
              Color.fromARGB(255, 162, 236, 233)
            ], stops: [
              0.5,
              1.0
            ])),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(Icons.location_on_outlined),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Delivery To ${model!.username} - ${model!.address}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )),
                const Icon(
                  Icons.arrow_drop_down_outlined,
                )
              ],
            ),
          )
        : isDataLoaded
            ? const Text(
                "something went wrong while fetching current user address")
            : const CircularProgressIndicator();
  }
}
