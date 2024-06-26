import 'package:flutter/material.dart';

import '../provider/provider.dart';

class SizeOption extends StatelessWidget {
  final BuildContext context;
  final ProductData provider;
  final String size;
  const SizeOption({
    super.key,
    required this.context,
    required this.provider,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        provider.setProductSize(size);
      },
      child: Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color:
                provider.productSize == size ? Color(0xffdb3022) : Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(size),
        ),
      ),
    );
  }
}
