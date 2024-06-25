import 'package:flutter/material.dart';
import 'package:product_app/model/model.dart';

import 'size_slector.dart';

class SizeShowModelBottomSheet extends StatefulWidget {
  Product product;
  SizeShowModelBottomSheet({super.key, required this.product});

  @override
  State<SizeShowModelBottomSheet> createState() =>
      _SizeShowModelBottomSheetState();
}

class _SizeShowModelBottomSheetState extends State<SizeShowModelBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("⭐ ${widget.product.rating} (320 reviews)"),
        GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.blue, 
                        width: 2.0, 
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'This is the modal bottom sheet',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
              );
            },
            child: SizeSelector())
      ],
    );
  }
}
