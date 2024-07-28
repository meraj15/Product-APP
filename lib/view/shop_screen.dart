import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:product_app/constant/contant.dart';
import 'package:product_app/routes/app_routes.dart';

import 'package:product_app/model/model.dart';
import 'package:product_app/provider/provider.dart';
import 'package:product_app/widget/drawer.dart';
import 'package:product_app/widget/product_card.dart';
import 'package:provider/provider.dart';

import '../widget/circular_loader.dart';
import '../widget/filter_category_product.dart';
import '../widget/sort_product.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final userInput = TextEditingController();

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
        title: Text(
          "Big Sales",
          style: GoogleFonts.pacifico(),
        ),
        backgroundColor: AppColor.scaffoldColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.addCardScreen);
            },
            icon: Badge(
              label: ValueListenableBuilder(
                valueListenable: context.read<ProductData>().totalProductCards,
                builder: (context, value, child) => Text(
                  "$value",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
              ),
            ),
          )
        ],
      ),
      drawer: const DrawerWidget(),
      body: provider.isLoaded
          ? const CircularLoader()
          : provider.error.isNotEmpty
              ? getError(provider.error)
              : getBody(provider.products),
    );
  }

  Widget getError(String error) {
    return Center(
      child: Text(
        error,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget getBody(List<Product> products) {
    final providerRead = context.read<ProductData>();

    final searchInput = userInput.text.toLowerCase();

    final filteredProducts = providerRead.selectedFilter.isEmpty
        ? products
            .where(
                (product) => product.title.toLowerCase().contains(searchInput))
            .toList()
        : products
            .where(
              (product) =>
                  product.title.toLowerCase().contains(searchInput) &&
                  providerRead.selectedFilter == product.category,
            )
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
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "home-decoration",
                  title: "Decoration",
                  icon: Icons.home,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "kitchen-accessories",
                  title: "Kitchen",
                  icon: Icons.kitchen,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "laptops",
                  title: "Laptops",
                  icon: Icons.laptop,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "mens-shirts",
                  title: "Mens shirts",
                  icon: Icons.checkroom,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "mens-shoes",
                  title: "Mens Shoes",
                  icon: Icons.run_circle,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "mens-watches",
                  title: "Mens Watches",
                  icon: Icons.watch,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "mobile-accessories",
                  title: "Mobile Accessories",
                  icon: Icons.mobile_friendly,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "motorcycle",
                  title: "Motorcycle",
                  icon: Icons.motorcycle,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "skin-care",
                  title: "Skin Care",
                  icon: Icons.face,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "smartphones",
                  title: "Smartphones",
                  icon: Icons.smartphone,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "sports-accessories",
                  title: "Sports Accessories",
                  icon: Icons.sports,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "sunglasses",
                  title: "Sunglasses",
                  icon: Icons.wb_sunny,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "tablets",
                  title: "Tablets",
                  icon: Icons.tablet,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "tops",
                  title: "Tops",
                  icon: Icons.emoji_people,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "vehicle",
                  title: "Vehicle",
                  icon: Icons.directions_car,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "womens-bags",
                  title: "Womens Bags",
                  icon: Icons.shopping_bag,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "womens-dresses",
                  title: "Womens Dresses",
                  icon: Icons.collections_sharp,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "womens-jewellery",
                  title: "Womens Jewellery",
                  icon: Icons.local_florist,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "womens-shoes",
                  title: "Womens Shoes",
                  icon: Icons.run_circle,
                ),
                SizedBox(width: 8),
                FilterCategoryProduct(
                  selectedFilter: "womens-watches",
                  title: "Womens Watches",
                  icon: Icons.watch,
                ),
              ],
            ),
          ),
        ),
        SortProduct(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: userInput,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: userInput.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          userInput.clear();
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
            onChanged: (value) {
              // providerRead.filterProduct();
              setState(() {});
            },
          ),
        ),
        Expanded(
          child: filteredProducts.isEmpty
              ? const Center(
                  child: Text(
                    "Product not found!!!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(product: product);
                  },
                ),
        )
      ],
    );
  }
}
