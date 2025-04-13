import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/view/otp_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController email;
  const ForgotPasswordScreen({super.key,required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Removes shadow for a cleaner look
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
           const Text(
              "Forgot Password",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          const  SizedBox(height: 20),

            // Description
            Text(
              "Enter your email id for verification process,\nWe will send 4 digit code to your email",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5, // Line spacing
              ),
            ),
           const SizedBox(height: 40),

            // Email Input Field
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                prefixIcon:const Icon(Icons.email_outlined, color: Colors.grey),
                labelText: "Email Id",
                labelStyle:const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          const  SizedBox(height: 40),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                //  Navigator.of(context).pushNamed(AppRoutes.createnewpasswordscreen);
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OTPScreen(email: email.text,fromScreen: "forgotPassword",)));

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.appMainColor, 
                  padding:const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:const Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}