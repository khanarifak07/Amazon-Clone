import 'package:dio/dio.dart';
import 'package:frontend/config.dart';

AuthServices authServices = AuthServices();
class AuthServices {
/*   Future<void> registerUser(
    final String username,
    final String email,
    final String password,
  ) async {
    try {

      
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
    }
  } */
}
