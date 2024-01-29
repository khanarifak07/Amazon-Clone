import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:frontend/screens/auth/auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  //logout method
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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("HomePage"),
          ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      await logoutUser();
                      //remove the saved access token
                      var prefs = await SharedPreferences.getInstance();
                      prefs.remove('accessToken');
                      //check the saved access token
                      var prefss = await SharedPreferences.getInstance();
                      final String? token = prefss.getString('accessToken');
                      print("Access token after logout $token");
                      if (mounted) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthScreen()),
                            (route) => false);
                      }
                    },
              child: const Text("Logout"))
        ]),
      ),
    );
  }
}
