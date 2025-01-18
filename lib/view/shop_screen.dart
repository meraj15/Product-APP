import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:product_app/main.dart';
import 'package:provider/provider.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/model/product.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/widget/circular_loader.dart';
import 'package:product_app/widget/filter_category_product.dart';
import 'package:product_app/widget/product_card.dart';
import 'package:product_app/widget/sort_product.dart';
import 'package:product_app/widget/drawer.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final userInput = TextEditingController();

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
          // Badge(
          //   backgroundColor: AppColor.appMainColor,
          //   label: Text(
          //     '${context.watch<ProductData>().addCard.length}',
          //     style: TextStyle(
          //       color: Colors.red,
          //       fontWeight: FontWeight.w900,
          //     ),
          //   ),
          //   child: IconButton(
          //     onPressed: () {
          //       Navigator.of(context).pushNamed(AppRoutes.addCardScreen);
          //     },
          //     icon: const Icon(Icons.shopping_cart_outlined),
          //   ),
          // )
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.addCardScreen);
            },
            icon: Badge(
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: Text(
                '${context.watch<ProductData>().addCard.length}',
                style: TextStyle(
                  color: AppColor.whiteColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            
          ),
          
        ], 
      ),
      drawer: const DrawerWidget(),
      body: provider.isLoaded
          ? const CircularLoader()
          : provider.error.isNotEmpty
              ? getError()
              : getBody(provider.products),
    );
  }

  Widget getError() {
    return Center(
      child: Lottie.asset("assets/lottie_animation/api_call_error.json"),
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
            .where((product) =>
                product.title.toLowerCase().contains(searchInput) &&
                providerRead.selectedFilter == product.category)
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
                    icon: Icons.all_inclusive),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "beauty",
                    title: "Beauty",
                    icon: Icons.brush),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "fragrances",
                    title: "Fragrances",
                    icon: Icons.spa),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "furniture",
                    title: "Furniture",
                    icon: Icons.weekend),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "groceries",
                    title: "Groceries",
                    icon: Icons.local_grocery_store),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "home-decoration",
                    title: "Decoration",
                    icon: Icons.home),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "kitchen-accessories",
                    title: "Kitchen",
                    icon: Icons.kitchen),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "laptops",
                    title: "Laptops",
                    icon: Icons.laptop),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "mens-shirts",
                    title: "Mens shirts",
                    icon: Icons.checkroom),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "mens-shoes",
                    title: "Mens Shoes",
                    icon: Icons.run_circle),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "mens-watches",
                    title: "Mens Watches",
                    icon: Icons.watch),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "mobile-accessories",
                    title: "Mobile Accessories",
                    icon: Icons.mobile_friendly),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "motorcycle",
                    title: "Motorcycle",
                    icon: Icons.motorcycle),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "skin-care",
                    title: "Skin Care",
                    icon: Icons.face),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "smartphones",
                    title: "Smartphones",
                    icon: Icons.smartphone),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "sports-accessories",
                    title: "Sports Accessories",
                    icon: Icons.sports),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "sunglasses",
                    title: "Sunglasses",
                    icon: Icons.wb_sunny),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "tablets",
                    title: "Tablets",
                    icon: Icons.tablet),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "tops",
                    title: "Tops",
                    icon: Icons.emoji_people),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "vehicle",
                    title: "Vehicle",
                    icon: Icons.directions_car),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "womens-bags",
                    title: "Womens Bags",
                    icon: Icons.shopping_bag),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "womens-dresses",
                    title: "Womens Dresses",
                    icon: Icons.collections_sharp),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "womens-jewellery",
                    title: "Womens Jewellery",
                    icon: Icons.local_florist),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "womens-shoes",
                    title: "Womens Shoes",
                    icon: Icons.run_circle),
                SizedBox(width: 8),
                FilterCategoryProduct(
                    selectedFilter: "womens-watches",
                    title: "Womens Watches",
                    icon: Icons.watch),
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
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        Expanded(
          child: filteredProducts.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 90),
                  child: Lottie.asset(
                      "assets/lottie_animation/product_not_found.json"),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(
                      product: product,
                      pdata: {
                        'id': product.id,
                        'brand': product.brand,
                        'title': product.title,
                        'thumbnail': product.thumbnail,
                        'price': product.price,
                        'rating': product.rating,
                        'warrantyinformation': product.warrantyInformation,
                        'userid': userID,
                        'category': product.category,
                      },
                    );
                  },
                ),
        )
      ],
    );
  }
}
