import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/main.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/view/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool? isCheckBox = false;
  bool isClickedPasword = true;
  String message = "";

  final userEmail = TextEditingController();
  final userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColor.appMainColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Sign in with your email and password or continue with social media",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: userEmail,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColor.appMainColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Email or Phone number",
                    labelText: "Email or Phone number",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: userPassword,
                  obscureText: isClickedPasword,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColor.appMainColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    suffixIcon: isClickedPasword
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isClickedPasword = false;
                              });
                            },
                            icon: const Icon(
                              Icons.visibility,
                              color: Colors.grey,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                isClickedPasword = true;
                              });
                            },
                            icon: const Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Enter your password",
                    labelText: "Password",
                  ),
                  validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  } else if (message.isNotEmpty) {
    final tempMessage = message;
    message = ""; 
    return tempMessage; 
  }
  return null;
},
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          activeColor: AppColor.appMainColor,
                          value: isCheckBox,
                          onChanged: (value) {
                            setState(() {
                              isCheckBox = value;
                            });
                          },
                        ),
                        const Text("Remember me"),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.bottemNavigationBar);
                      },
                      child: const Text(
                        "Forgot Password",
                        style: TextStyle(
                          color: AppColor.appMainColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: ()async {
                    if (_formKey.currentState!.validate()) {
                      login(userEmail.text, userPassword.text);
                    }
                    isLogged = true;
  final SharedPreferences logged = await SharedPreferences.getInstance();
  logged.setBool("logged", isLogged);

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.appMainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Divider(
                        color: Colors.grey[200],
                        thickness: 2,
                      ),
                    ),
                    const Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("OR"),
                      ),
                    ),
                    Flexible(
                      child: Divider(
                        color: Colors.grey[200],
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        "assets/images/google_icon.png",
                        width: 42,
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        "assets/images/facebook_icon.png",
                        width: 38,
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        "assets/images/twitter_icon.png",
                        width: 38,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.signupScreen);
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: AppColor.appMainColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(String email, String password) async {
  const url = "http://192.168.0.110:3000/api/login";
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == "success") {
        userID = data['userId'] ?? "No User ID";
        debugPrint("userIDss : $userID");
        Navigator.of(context).pushNamed(AppRoutes.bottemNavigationBar);
      } else if (data['status'] == "error") {
        setState(() {
          message = data['message'] ?? "Invalid email or password.";
        });
        _formKey.currentState!.validate(); 
      }
    } else {
      setState(() {
        message = "Server error: ${response.statusCode}";
      });
      _formKey.currentState!.validate(); 
    }
  } catch (e) {
    setState(() {
      message = "An error occurred. Please try again.";
    });
    _formKey.currentState!.validate(); 
    debugPrint("Login Error: $e");
  }
}


}
