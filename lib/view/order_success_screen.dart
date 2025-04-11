
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:product_app/provider/product_provider.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';

class OrdersSuccessScreen extends StatefulWidget {
  const OrdersSuccessScreen({super.key});

  @override
  State<OrdersSuccessScreen> createState() => _OrdersSuccessScreenState();
}

class _OrdersSuccessScreenState extends State<OrdersSuccessScreen> {
  bool _isDataPosted = false; // Flag to ensure postData runs only once

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataPosted) {
      _isDataPosted = true;
    context.read<ProductData>().postOrder(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Centered content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset("assets/images/bags.svg"),
                  const SizedBox(height: 20),
                  const Text(
                    "Success!",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff000000),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text("Your order will be delivered soon."),
                  const Text("Thank you for choosing our app!"),
                ],
              ),
            ),
            // Button at the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.bottemNavigationBar);
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Text(
                      "CONTINUE SHOPPING",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
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
