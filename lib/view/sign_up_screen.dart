import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/view/otp_screen.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
    final TextEditingController email;
  const SignUpScreen({super.key,required this.email});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductData>();
    final providerWatch = context.watch<ProductData>();

    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColor.scaffoldColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: providerRead.formKeySignUp,
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Complete your details to register and start exploring.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              _buildTextField(
                controller: providerRead.signUpUserName,
                labelText: "Name",
                icon: Icons.person,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: widget.email,
                labelText: "Email",
                icon: Icons.email,
                errorText: providerWatch.signScreenErrorMsg.isNotEmpty
                    ? providerWatch.signScreenErrorMsg
                    : null,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                onChanged: (value) {
                  if (providerRead.signScreenErrorMsg.isNotEmpty) {
                    providerRead.signScreenErrorMsg = "";
                    providerRead.notifyListeners();
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Enter a valid email address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: providerRead.userSignMobile,
                labelText: "Mobile",
                icon: Icons.phone,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Mobile number is required";
                  } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return "Enter a valid 10-digit mobile number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: providerRead.userSignPassword,
                labelText: "Password",
                icon: Icons.lock,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  } else if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: providerRead.userSignConfirmPassword,
                labelText: "Confirm Password",
                icon: Icons.lock_outline,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password";
                  } else if (value != providerRead.userSignPassword.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              Center(
                child: ElevatedButton(
                  onPressed: providerRead.isSignLoading
                      ? null
                      : () async {
                          if (providerRead.formKeySignUp.currentState!.validate()) {
                            try {
                              setState(() {
                                providerRead.isSignLoading = true;
                              });
                              // Map<String, dynamic> userInfo = {
                              //   'name': providerRead.signUpUserName.text,
                              //   'email': providerRead.userSignEmail.text,
                              //   'password': providerRead.userSignPassword.text,
                              //   'mobile': providerRead.userSignMobile.text,
                              // };

                              // bool success = await providerRead.postSignUpData(userInfo);

                              // if (success) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => OTPScreen(
                                      email: widget.email.text,
                                      fromScreen: "signUp",
                                    ),
                                  ),
                                );
                                // Optionally clear fields (uncomment if needed)
                                // providerRead.signUpUserName.clear();
                                // providerRead.userSignEmail.clear();
                                // providerRead.userSignPassword.clear();
                                // providerRead.userSignMobile.clear();
                                // providerRead.userSignConfirmPassword.clear();
                              // }
                            } catch (e) {
                              providerRead.signScreenErrorMsg =
                                  "An error occurred. Please try again.";
                              providerRead.notifyListeners();
                              debugPrint("Error: $e");
                            } finally {
                              if (mounted) {
                                setState(() {
                                  providerRead.isSignLoading = false;
                                });
                              }
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: providerRead.isSignLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColor.whiteColor,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    int? maxLength,
    bool obscureText = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? errorText,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      onTapOutside: (e) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      onChanged: onChanged,
      decoration: InputDecoration(
        counterText: "",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        prefixIcon: Icon(icon, color: Colors.grey),
        labelText: labelText,
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
        errorText: errorText,
        errorStyle: const TextStyle(fontSize: 12, height: 0.8),
      ),
      validator: validator,
    );
  }
}