import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:frontend/constants/global_variables.dart';
import 'package:frontend/models/profile.model.dart';
import 'package:frontend/models/user.model.dart';
import 'package:frontend/screens/admin_screens/admin_homepage.dart';
import 'package:frontend/widgets/bottom_bar.dart';
import 'package:frontend/widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  //register method
  Future<void> registerUser(
      /* final String username,
    final String email,
    final String password, */
      {required UserModel userModel}
      // final File image,//if you want to pass image
      ) async {
    try {
      setState(() {
        isLoading = true;
      });
      //create dio object
      Dio dio = Dio();
      //create data (user formdata only when you want to pass image file)
      /*  var data = {
        "username": username,
        "email": email,
        "password": password,
      }; */

      // Create FormData
      /* FormData formData = FormData.fromMap({
      'username': user.username,
      'email': user.email,
      'password': user.password,
      'address': user.address,
      'type': user.type,
      'token': user.token,
      'image': await MultipartFile.fromFile(image.path, filename: 'user_image.jpg'),
    }); */

      var data = userModel.toMap();

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

  //save accessToken to sharedpreference
  Future<void> saveAccessTokenToSharedPreference(String accessToken) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', accessToken);
      log("Access Token saved successfully in shared preference $accessToken");
    } catch (e) {
      print("Error while saving accessToken to shared preference $e");
    }
  }

  Future<void> saveCurrentUserToSharedPreference(
      ProfileModel profileModel) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('currentUser', profileModel.toJson());
      print("Current user details saved successfully ${profileModel.toJson()}");
    } catch (e) {
      print("Error while saving current user to shared preference $e");
    }
  }

  Future<void> saveUserType(String usertype) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('type', usertype);
      log("user type saved :- $usertype");
    } catch (e) {
      print("Error while saving user type in sharedPreference $e");
    }
  }

  //getCurrent User method
  Future<void> getCurrentUser(String accessToken) async {
    try {
      //create dio instance
      Dio dio = Dio();
      //make dio get request
      Response response = await dio.get(getCurrentUserApi,
          options: Options(
            headers: {"Authorization": "Bearer $accessToken"},
          ));
      //handle response
      if (response.statusCode == 200) {
        log("Current user details fetched successfully ${response.data}");
        //get the current user data and save to shared preference
        final currentUser = ProfileModel.fromMap(response.data['data']);
        final userType = response.data['data']['type'];
        await saveCurrentUserToSharedPreference(currentUser);
        await saveUserType(userType);
      } else {
        print("Error while getting current user ${response.statusCode}");
      }
    } catch (e) {
      print("Error while getting current user details");
    }
  }

  //login method
  Future<String?> loginUser({
    required UserModel userModel,
    // required String email,
    // required String password,
  }
      // required String email,
      // required String password,
      ) async {
    try {
      setState(() {
        isLoading = true;
      });
//get the user type from share preference

      //create dio instance
      Dio dio = Dio();
      //create form data or normal data
      var data = userModel.toMap();
      // var data = {
      //   'email': email,
      //   'password': password,
      // };
      //make dio post request
      Response response = await dio.post(loginApi, data: data);
      //handle the response
      if (response.statusCode == 200) {
        log("user logged in successfully ${response.data}");
        final String? accessToken = response.data['data']['accessToken'];
        if (accessToken != null) {
          await saveAccessTokenToSharedPreference(accessToken);
          await getCurrentUser(accessToken);
          var prefs = await SharedPreferences.getInstance();
          final String? userType = prefs.getString('type');
          if (userType == "user") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()),
                (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AdminHomePage()),
                (route) => false);
          }

          return accessToken;
        } else {
          print("Error while saving access token to shared preference");
        }

        print(accessToken);
      } else {
        print("Something went wrong while logging user");
      }
    } catch (e) {
      print("Somehthing went wrong while logging user $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return null;
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
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            await registerUser(
                                userModel: UserModel(
                              email: emailCtrl.text,
                              password: passwordCtrl.text,
                              username: usernameCtrl.text,
                            ));
                            usernameCtrl.clear();
                            emailCtrl.clear();
                            passwordCtrl.clear();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "User Registered Successfully")));
                            }
                          },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.maxFinite, 50)),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Sign Up"),
                  ),
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
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            await loginUser(
                                userModel: UserModel(
                              email: emailCtrl.text,
                              password: passwordCtrl.text,
                            ));
                          },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.maxFinite, 50)),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Sign In"),
                  ),
                  // CustomButtom(ontap: () {}, text: "Sign In")
                ],
              ),
          ],
        ),
      )),
    );
  }
}
