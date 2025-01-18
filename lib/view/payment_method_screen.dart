import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/widget/toast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedPaymentMethod = "Card";
  final Razorpay _razorpay = Razorpay();
  @override
  Widget build(BuildContext context) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    final providerRead = context.read<ProductData>();
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Payment Method',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(4.0),
              children: [
                paymentMethod("Card", "Credit/Debit Card or UPI"),
                paymentMethod("Cash", "Cash on Delivery")
              ],
            ),
          ),

          // Footer: Total Amount and Make Payment Button
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "\$${context.watch<ProductData>().totalAmount.toStringAsFixed(2)}",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedPaymentMethod == "Card") {
                      var options = {
                        'key': 'rzp_test_YghCO1so2pwPnx',
                        'amount': (providerRead.totalAmount * 100).toInt(),
                        'name': 'AM Coders.',
                        'currency': 'USD',
                        'description': 'Flutter Developer',
                        'prefill': {
                          'contact': '7208465366',
                          'email': 'am@gmail.com',
                        }
                      };
                      _razorpay.open(options);
                    } else {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.orderSuccessScreen);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    _selectedPaymentMethod == "Cash"
                        ? 'Place Order'
                        : 'Make Payment',
                    style: TextStyle(fontSize: 16, color: AppColor.whiteColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentMethod(String value, String title) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: ListTile(
        leading:
            Icon(Icons.money, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: Radio<String>(
          value: value,
          groupValue: _selectedPaymentMethod,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value!;
            });
          },
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Navigator.of(context).pushNamed(AppRoutes.orderSuccessScreen);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment Failed'),
        duration: Duration(microseconds: 500),
      ),
    );
    debugPrint('response : $response');
  }

  @override
  void dispose() {
    try {
      _razorpay.clear();
    } catch (e) {
      debugPrint('dispose() Catch Block : $e');
    }
    super.dispose();
  }
}
