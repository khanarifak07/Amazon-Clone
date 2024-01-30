import 'package:flutter/material.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/screens/auth/auth_screen.dart';
import 'package:frontend/screens/admin_screens/admin_homepage.dart';
import 'package:frontend/widgets/bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //get the access token
  var prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('accessToken');
  print("Access Token Retrived $token");
  //get the use type
  final String? userType = prefs.getString('type');
  print("type : $userType");

  runApp(MyApp(accessToken: token, userType: userType));
}

class MyApp extends StatelessWidget {
  final String? accessToken;
  final String? userType;
  const MyApp({super.key, this.accessToken, this.userType});

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
        home:
            //  accessToken != null ? const BottomNavBar() : const AuthScreen()

            accessToken!.isNotEmpty
                ? userType == "user"
                    ? const BottomNavBar()
                    : AdminHomePage()
                : const AuthScreen());
  }
}
