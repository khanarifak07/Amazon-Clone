import 'package:flutter/material.dart';
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
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  //dispose the controller to prevent memory leakage

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailCtrl.dispose();
    nameCtrl.dispose();
    passwordCtrl.dispose();
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
                    labelText: "Name",
                    controller: nameCtrl,
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
                  CustomButtom(ontap: () {}, text: "Sign Up")
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
                  CustomButtom(ontap: () {}, text: "Sign In")
                ],
              ),

            /*  const SizedBox(height: 12),
            const CustomTextField(labelText: "Name"),
            const SizedBox(height: 12),
            const CustomTextField(labelText: "Email"),
            const SizedBox(height: 12),
            const CustomTextField(labelText: "Password"),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () {}, child: const Text("Sign Up")),
            MaterialButton(
              color: GlobalVariables.secondaryColor,
              minWidth: double.maxFinite,
              onPressed: () {},
              child: const Text("Sign Up"),
            ) */
          ],
        ),
      )),
    );
  }
}
