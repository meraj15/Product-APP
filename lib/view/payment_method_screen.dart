import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/routes/app_routes.dart';


class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Navigate back or close the screen
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
                // Credit/Debit Card Section
       Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: Card(
    color: Colors.white, // Matches the background to eliminate borders
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    elevation: 2, // Removes shadow
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent), // Removes ExpansionTile border
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16), // Adjust padding for alignment
        leading: Icon(Icons.credit_card, color: Theme.of(context).colorScheme.primary),
        title: Text(
          'Credit/Debit Card',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        children: [
          ListTile(
            leading: Icon(Icons.add_circle_outline, color: Theme.of(context).colorScheme.primary),
            title: Text(
              'Add New Card',
              style: TextStyle(fontSize: 16),
            ),
            trailing: Icon(Icons.arrow_forward, color: Colors.grey),
            onTap: () {
                 Navigator.of(context).pushNamed(AppRoutes.addCardpaymentscreen);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16.0),
            child: const Divider(color: Colors.grey),
          ), // Keeps divider
          ListTile(
            leading: Icon(Icons.credit_card, color: Theme.of(context).colorScheme.primary),
            title: Text(
              'Mastercard •••• 1234',
              style: TextStyle(fontSize: 16),
            ),
            trailing: Radio<String>(
              value: 'Card',
              groupValue: _selectedPaymentMethod,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
          ),
        ],
      ),
    ),
  ),
),

               

                // Cash on Delivery Section
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: Icon(Icons.money, color: Theme.of(context).colorScheme.primary),
                    title: Text(
                      'Cash on Delivery',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    trailing: Radio<String>(
                      value: 'Cash',
                      groupValue: _selectedPaymentMethod,
                      activeColor:  Theme.of(context).colorScheme.primary,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value;
                        });
                      },
                    ),
                  ),
                ),
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text("\$28.6", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  ],
                ),
                // SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.addressForm);
                  },
                  child: Text('Make Payment', style: TextStyle(fontSize: 16,color: AppColor.whiteColor)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
