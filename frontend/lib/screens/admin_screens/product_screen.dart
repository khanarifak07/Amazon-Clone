import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/screens/admin_screens/add_product_screen.dart';
import 'package:frontend/screens/auth/auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isLoading = false;

  Future<void> logoutUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      //get the saved access token
      var prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('accessToken');
      //create dio instance
      Dio dio = Dio();
      //make dio post request
      Response response = await dio.post(logoutApi,
          options: Options(headers: {"Authorization": "Bearer $token"}));
      //handle response
      if (response.statusCode == 200) {
        print("user logout successfully ${response.data}");
      } else {
        print("error while logout user ${response.statusCode}");
      }
    } catch (e) {
      print("Error while logout $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: isLoading
              ? null
              : () async {
                  await logoutUser();
                  //remove the saved access token
                  var prefs = await SharedPreferences.getInstance();
                  prefs.remove('accessToken');
                  //remove the user type
                  prefs.remove('type');
                  //check the saved access token
                  var prefss = await SharedPreferences.getInstance();
                  final String? token = prefss.getString('accessToken');
                  final String? userType = prefss.getString('type');
                  print("Access token after logout $token");
                  print("user type after logout $userType");

                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AuthScreen()),
                        (route) => false);
                  }
                },
          child: Container(
            height: 50,
            width: 180,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 1),
                color: GlobalVariables.greyBackgroundColor,
                borderRadius: BorderRadius.circular(30)),
            child: const Center(
              child: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => const AddProductScreen()));
        },
        tooltip: "Add a product",
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
