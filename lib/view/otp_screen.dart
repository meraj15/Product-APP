import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_app/config/endpoint.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/view/change_password_screen.dart';
import 'package:provider/provider.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  final String fromScreen;

  const OTPScreen({super.key, required this.email, required this.fromScreen});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final _OTPformKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isOtpError = false;
  String _otpWrongMessage = '';

  @override
  void initState() {
    super.initState();
    _sendOtp();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
      _isOtpError = false;
      _otpWrongMessage = '';
    });
    try {
      final response = await http.post(
        Uri.parse(APIEndPoint.sendOtp),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email}),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP sent to ${widget.email}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send OTP. Try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Try again.')),
      );
      debugPrint("Send OTP error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyOtp() async {
    final providerRead = context.read<ProductData>();
    if (_OTPformKey.currentState!.validate()) {
      final enteredOtp = _otpControllers.map((c) => c.text).join();
      try {
        final response = await http.post(
          Uri.parse(APIEndPoint.verifyOtp),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': widget.email, 'otp': enteredOtp}),
        );
        if (response.statusCode == 200) {
          setState(() {
            _isOtpError = false;
            _otpWrongMessage = '';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP Verified!')),
          );

          if (widget.fromScreen == 'forgotPassword') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CreateNewPasswordScreen(email: widget.email),
              ),
            );
          } else if (widget.fromScreen == 'signUp') {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.bottemNavigationBar,
              (route) => false,
            );
            Map<String, dynamic> userInfo = {
              'name': providerRead.signUpUserName.text,
              'email': widget.email,
              'password': providerRead.userSignPassword.text,
              'mobile': providerRead.userSignMobile.text,
            };
            await providerRead.postSignUpData(userInfo);
            providerRead.signUpUserName.clear();
            providerRead.userSignPassword.clear();
            providerRead.userSignMobile.clear();
            providerRead.userSignConfirmPassword.clear();
          }
        } else {
          setState(() {
            _isOtpError = true;
            _otpWrongMessage = 'OTP is wrong';
          });
        }
      } catch (e) {
        setState(() {
          _isOtpError = true;
          _otpWrongMessage = 'An error occurred. Please try again.';
        });
        debugPrint("Verify OTP error: $e");
      }
    }
  }

  void _handleOtpInput(int index, String value) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _OTPformKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Enter OTP",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Please Enter The OTP Sent to ${widget.email}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: TextFormField(
                              onTapOutside: (e) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(1),
                              ],
                              onChanged: (value) => _handleOtpInput(index, value),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                errorBorder: _isOtpError
                                    ? OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                            color: AppColor.appMainColor),
                                      )
                                    : null,
                                focusedErrorBorder: _isOtpError
                                    ? OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                            color: AppColor.appMainColor),
                                      )
                                    : null,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter OTP';
                                }
                                return null;
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                    if (_isOtpError)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          _otpWrongMessage,
                          style: const TextStyle(
                            color: AppColor.appMainColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: _isLoading ? null : _sendOtp,
                      child: const Text("Resend OTP?"),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Verify",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}