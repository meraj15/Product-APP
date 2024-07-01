import 'package:flutter/material.dart';

import 'package:product_app/constant/contant.dart';
import 'package:product_app/view/add_cart.dart';

import 'package:product_app/model/model.dart';
import 'package:product_app/provider/provider.dart';
import 'package:product_app/widget/product_card.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductData>().getData();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductData>();
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sale"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const AddCard();
                  },
                ),
              );
            },
            icon: Badge(
              label: ValueListenableBuilder(
                valueListenable: context.read<ProductData>().totalProductCards,
                builder: (context, value, child) => Text("$value"),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
              ),
            ),
          )
        ],
      ),
      drawer: const Drawer(),
      body: provider.isLoaded
          ? getLoader()
          : provider.error.isNotEmpty
              ? getError(provider.error)
              : getBody(provider.products),
    );
  }

  Widget getLoader() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColor.appMainColor,
      ),
    );
  }

  Widget getError(String error) {
    return Center(
      child: Text(error),
    );
  }

  Widget getBody(List<Product> products) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return ProductCard(product: product);
      },
    );
  }
}
