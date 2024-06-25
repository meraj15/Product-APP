import 'package:flutter/material.dart';
import 'package:product_app/provider/provider.dart';
import 'package:provider/provider.dart';

class AddCard extends StatelessWidget {
  const AddCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Bag"),
      ),
      body: ListView.builder(
        itemCount: context.watch<ProductData>().addCard.length,
        itemBuilder: (context, index) {
          final product = context.read<ProductData>();
          return Card(
            child: ListTile(
              title: Text(product.addCard[index].title),
            ),
          );
        },
      ),
    );
  }
}
