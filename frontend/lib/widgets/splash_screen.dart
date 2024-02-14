import 'package:flutter/material.dart';
import 'package:frontend/screens/admin_screens/admin_homepage.dart';
import 'package:frontend/screens/auth/auth_screen.dart';
import 'package:frontend/widgets/bottom_bar.dart';

class SplashScreen extends StatelessWidget {
  final String? accessToken;
  final String? userType;
  const SplashScreen({super.key, this.accessToken, this.userType});

  @override
  Widget build(BuildContext context) {
    if (accessToken != null) {
      if (userType == "user") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const BottomNavBar()));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AdminHomePage()));
      }
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const AuthScreen()));
    }
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
