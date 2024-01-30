import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/screens/auth/auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopFourBottons extends StatefulWidget {
  const TopFourBottons({super.key});

  @override
  State<TopFourBottons> createState() => _TopFourBottonsState();
}

class _TopFourBottonsState extends State<TopFourBottons> {
  bool isLoading = false;
  //logout Method
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              containerButton(text: "Your Orders", ontap: () {}),
              containerButton(text: "Turn Sellers", ontap: () {})
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
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
              containerButton(text: "Your Wish List", ontap: () {})
            ],
          ),
        ],
      ),
    );
  }

  //custom container button
  Widget containerButton({required String text, required VoidCallback ontap}) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 50,
        width: 180,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400, width: 1),
            color: GlobalVariables.greyBackgroundColor,
            borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
