import 'package:flutter/material.dart';

class SizeSelector extends StatelessWidget {
  const SizeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffdb3022),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Size",
            style: TextStyle(fontSize: 15),
          ),
          Icon(Icons.arrow_drop_down_outlined),
        ],
      ),
    );
  }
}
