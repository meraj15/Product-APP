import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/provider/provider.dart';
import 'package:provider/provider.dart';

class Textfiled extends StatefulWidget {
  const Textfiled({super.key});

  @override
  State<Textfiled> createState() => _TextfiledState();
}

class _TextfiledState extends State<Textfiled> {
  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductData>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: providerRead.userInput,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          suffixIcon: providerRead.userInput.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      providerRead.userInput.clear();
                    });
                  },
                  icon: const Icon(Icons.close, color: Colors.grey),
                )
              : null,
          fillColor: AppColor.whiteColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          labelText: "Search product",
          hintText: "Enter product name...",
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColor.appMainColor),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onSubmitted: (value) {
          setState(() {});
        },
      ),
    );
  }
}
