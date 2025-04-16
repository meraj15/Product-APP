import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/view/forgot_password_screen.dart';
import 'package:product_app/view/sign_up_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userEmail = TextEditingController();
  final userPassword = TextEditingController();
  GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductData>();
    final providerWatch = context.watch<ProductData>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKeyLogin,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
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
                    onTapOutside: (e) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: userEmail,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      errorText: providerWatch.emailErrorMsg.isNotEmpty
                          ? providerWatch.emailErrorMsg
                          : null,
                      hintText: "Email",
                      labelText: "Email",
                      errorStyle: const TextStyle(fontSize: 12, height: 0.8),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    onChanged: (value) {
                      if (providerRead.emailErrorMsg.isNotEmpty) {
                        providerRead.emailErrorMsg = "";
                        providerRead.notifyListeners();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onTapOutside: (e) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: userPassword,
                    obscureText: providerRead.isPasswordObscured,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      suffixIcon: IconButton(
                        onPressed: () {
                          providerRead.togglePasswordVisibility();
                          providerRead.notifyListeners();
                        },
                        icon: Icon(
                          providerRead.isPasswordObscured
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColor.appMainColor),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColor.appMainColor),
                      ),
                      errorText: providerWatch.passwordErrorMsg.isNotEmpty
                          ? providerWatch.passwordErrorMsg
                          : null,
                      hintText: "Enter your password",
                      labelText: "Password",
                      errorStyle: const TextStyle(fontSize: 12, height: 0.8),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (providerRead.passwordErrorMsg.isNotEmpty) {
                        providerRead.passwordErrorMsg = "";
                        providerRead.notifyListeners();
                      }
                    },
                  ),
                   const SizedBox(height: 10),
                  Text(providerRead.passwordErrorMsg),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            activeColor: Theme.of(context).colorScheme.primary,
                            value: providerRead.isCheckBox,
                            onChanged: (value) {
                              setState(() {
                                providerRead.isCheckBox = value;
                              });
                            },
                          ),
                          const Text("Remember me"),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          providerRead.emailErrorMsg = "";
                          providerRead.passwordErrorMsg = "";
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen(
                                email: userEmail,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: providerRead.isLoginLoading
                        ? null
                        : () async {
                            if (formKeyLogin.currentState!.validate()) {
                              setState(() {
                                providerRead.isLoginLoading = true;
                              });
                              try {
                                await providerRead.userLogin(
                                    userEmail.text, userPassword.text, context);
                              } catch (e) {
                                providerRead.emailErrorMsg =
                                    "An unexpected error occurred.";
                                providerRead.notifyListeners();
                                debugPrint("LoginScreen error: $e");
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    providerRead.isLoginLoading = false;
                                  });
                                }
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: providerRead.isLoginLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
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
                          providerRead.emailErrorMsg = "";
                          providerRead.passwordErrorMsg = "";
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(email: userEmail),
                            ),
                          );
                          debugPrint("From login to sign-up");
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    userEmail.dispose();
    userPassword.dispose();
    super.dispose();
  }
}