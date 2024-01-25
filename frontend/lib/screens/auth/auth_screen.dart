import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_textfield.dart';

enum Auth {
  signup,
  singin,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signup;
  bool isLoading = false;
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  //dispose the controller to prevent memory leakage
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailCtrl.dispose();
    usernameCtrl.dispose();
    passwordCtrl.dispose();
  }

  Future<void> registerUser(
    final String username,
    final String email,
    final String password,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      //create dio object
      Dio dio = Dio();
      //create data (user formdata only when you want to pass image file)
      var data = {
        "username": username,
        "email": email,
        "password": password,
      };

      //make dio post request
      Response response = await dio.post(registerApi, data: data);
      //handle the response
      if (response.statusCode == 200) {
        print("User regsitered successfully ${response.data}");
      } else {
        print("User registeration failed ${response.statusCode}");
      }
    } catch (e) {
      print("Error while registering user $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            ListTile(
              title: const Text(
                "Create Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Radio(
                  value: Auth.signup,
                  groupValue: _auth,
                  activeColor: GlobalVariables.secondaryColor,
                  onChanged: (Auth? val) {
                    setState(() {
                      _auth = val!;
                    });
                  }),
            ),
            if (_auth == Auth.signup)
              Column(
                children: [
                  CustomTextField(
                    labelText: "Username",
                    controller: usernameCtrl,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    labelText: "Email",
                    controller: emailCtrl,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    labelText: "Password",
                    controller: passwordCtrl,
                  ),
                  const SizedBox(height: 12),
                  CustomButtom(
                    ontap: () async {
                      await registerUser(
                        usernameCtrl.text,
                        emailCtrl.text,
                        passwordCtrl.text,
                      );
                      usernameCtrl.clear();
                      emailCtrl.clear();
                      passwordCtrl.clear();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("User Registered Successfully")));
                      }
                    },
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Sign Up"),
                  )
                ],
              ),
            ListTile(
              title: const Text(
                "Sign-In",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Radio(
                  value: Auth.singin,
                  groupValue: _auth,
                  activeColor: GlobalVariables.secondaryColor,
                  onChanged: (Auth? val) {
                    setState(() {
                      _auth = val!;
                    });
                  }),
            ),
            if (_auth == Auth.singin)
              Column(
                children: [
                  CustomTextField(
                    labelText: "Email",
                    controller: emailCtrl,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    labelText: "Password",
                    controller: passwordCtrl,
                  ),
                  const SizedBox(height: 12),
                  // CustomButtom(ontap: () {}, text: "Sign In")
                ],
              ),
          ],
        ),
      )),
    );
  }
}
