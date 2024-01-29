import 'package:flutter/material.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/screens/auth/auth_screen.dart';
import 'package:frontend/widgets/bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //get the access token
  var prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('accessToken');
  print("Access Token Retrived $token");
  runApp(MyApp(accessToken: token));
}

class MyApp extends StatelessWidget {
  final String? accessToken;
  const MyApp({super.key, this.accessToken});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        iconTheme: const IconThemeData(color: Colors.black),
        appBarTheme: const AppBarTheme(elevation: 0),
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
      ),
      title: 'Flutter Demo',
      home: accessToken != null ? const BottomNavBar() : const AuthScreen(),
    );
  }
}
