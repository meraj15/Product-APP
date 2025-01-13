import 'package:flutter/material.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/widget/toast.dart';
import 'package:provider/provider.dart';

class CheckoutButton extends StatelessWidget {
  final List<Map<String, dynamic>> pdata;
  
  const CheckoutButton({super.key,required this.pdata,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: FilledButton(
        onPressed: () {
          context.read<ProductData>().updateCartQuantity(pdata);
          if(context.read<ProductData>().addCard.isNotEmpty){
          Navigator.of(context).pushNamed(AppRoutes.paymentmethodscreen);
          }else{
             CustomToast.showCustomToast(context, "Please select the cart");
          }
        },
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xffdb3022),
          minimumSize: Size(double.infinity, 50),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Center(
          child: Text(
            "CHECK OUT",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// void showCustomBottomSheet(BuildContext context, List<Map<String, dynamic>> pdata) {
  // showModalBottomSheet(
  //   context: context,
  //   builder: (context) {
  //     return Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: TextField(
  //             decoration: InputDecoration(
  //               hintText: 'Enter your promo code',
  //               suffixIcon: Icon(Icons.arrow_forward),
  //               border: OutlineInputBorder(),
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: 20),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //           child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       const Text(
  //                         'Total amount : ',
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.w500,
  //                           fontSize: 15,
  //                         ),
  //                       ),
  //                       Text(
  //                         "\$${totalAmount.toStringAsFixed(2)}",
  //                         style: const TextStyle(
  //                           fontWeight: FontWeight.w500,
  //                           fontSize: 17,
  //                         ),
  //                       ),
  //                     ],
  //                   );
  //         ),
  //         SizedBox(height: 30),
        
  //       ],
  //     );
  //   },
//   );
// }
