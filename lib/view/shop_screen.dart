import 'package:flutter/material.dart';

import 'package:product_app/constant/contant.dart';
import 'package:product_app/view/add_cart.dart';

import 'package:product_app/model/model.dart';
import 'package:product_app/provider/provider.dart';
import 'package:product_app/view/home_screen.dart';
import 'package:product_app/widget/product_card.dart';
import 'package:provider/provider.dart';

import '../widget/filter_category_product.dart';
import '../widget/sort_product.dart';

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
        title: const Text(
          "Big Sales",
          style: TextStyle(
            // fontSize: 24,
            fontWeight: FontWeight.w500,
            // color: Colors.white,
          ),
        ),
        backgroundColor: AppColor.scaffoldColor,
        leading: IconButton(
          onPressed: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return const HomeScreen();
            //     },
            //   ),
            // );
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            // color: Colors.white,
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
                builder: (context, value, child) => Text(
                  "$value",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                // color: Colors.white,
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
      child: Text(
        error,
        style: TextStyle(
          fontSize: 18,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget getBody(List<Product> products) {
    final filterCategory = context.watch<ProductData>().selectedFilter.isEmpty
        ? products
        : products
            .where((product) =>
                product.category == context.watch<ProductData>().selectedFilter)
            .toList();
    return Column(
      children: [
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Row(
              children: [
                FilterCategoryProduct(
                  selectedFilter: "",
                  title: "All",
                  icon: Icons.all_inclusive,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "beauty",
                  title: "Beauty",
                  icon: Icons.brush,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "fragrances",
                  title: "Fragrances",
                  icon: Icons.spa,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "furniture",
                  title: "Furniture",
                  icon: Icons.weekend,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "groceries",
                  title: "Groceries",
                  icon: Icons.local_grocery_store,
                ),
              ],
            ),
          ),
        ),
        SortProduct(),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
            ),
            itemCount: filterCategory.length,
            itemBuilder: (context, index) {
              final product = filterCategory[index];

              return ProductCard(product: product);
            },
          ),
        )
      ],
    );
  }
}
