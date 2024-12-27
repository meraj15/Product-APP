import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/main.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/widget/drawer.dart';
import 'package:provider/provider.dart';
import '../widget/filter_category_product.dart';
import 'package:badges/badges.dart' as badges;

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
    context.read<ProductData>().getFavouriteData(userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
      drawer: const DrawerWidget(),
      appBar: AppBar(
  title: Text(
    "Favorites",
    style: GoogleFonts.pacifico(
      fontWeight: FontWeight.w500,
    ),
  ),
  actions: [
    Consumer<ProductData>(
      builder: (context, provider, child) {
        final cartCount = provider.addCard.length; 
        return badges.Badge(
  badgeContent: Text(
    cartCount.toString(),
    style: const TextStyle(
      color: Colors.yellow,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
  ),
  badgeStyle: badges.BadgeStyle(
    badgeColor: AppColor.appMainColor,
    padding: const EdgeInsets.all(6),
  ),
  position: badges.BadgePosition.topEnd(top: 4, end: 4),
  showBadge: cartCount > 0, // This will ensure the badge only shows when the count is > 0
  child: IconButton(
    onPressed: () {
      Navigator.of(context).pushNamed(AppRoutes.addCardScreen);
    },
    icon: const Icon(Icons.shopping_cart_outlined),
  ),
);
      },
    ),
  ],
  centerTitle: true,
  backgroundColor: AppColor.scaffoldColor,
),
      body: Column(
        children: [
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<ProductData>(
                builder: (context, provider, child) {
                  final favorites = provider.favorite;
                  final filterFavorites = provider.selectedFilter.isEmpty
                      ? favorites
                      : favorites
                          .where((element) =>
                              element.category.toLowerCase() ==
                              provider.selectedFilter.toLowerCase())
                          .toList();
                  if (filterFavorites.isEmpty) {
                    return Center(
                      child: Lottie.asset(
                          "assets/lottie_animation/product_not_selected.json"),
                    );
                  }
                  return ListView.builder(
                    itemCount: filterFavorites.length,
                    itemBuilder: (context, index) {
                      final favoritesProduct = filterFavorites[index];
                      int rating = favoritesProduct.rating.ceil().toInt();
                      rating = rating > 5 ? 5 : rating;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5.0,
                                spreadRadius: 2.0,
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  // favoritesProduct.images.first,
                                  favoritesProduct.thumbnail,
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        favoritesProduct.brand,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54,
                                          fontSize: 13,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        favoritesProduct.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "\$${favoritesProduct.price}",
                                        style: const TextStyle(
                                          color: AppColor.appMainColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          ...List.generate(
                                            rating,
                                            (index) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 18,
                                            ),
                                          ),
                                          ...List.generate(
                                            5 - rating,
                                            (index) => const Icon(
                                              Icons.star_outline,
                                              color: Colors.amber,
                                              size: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        favoritesProduct.warrantyInformation,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  provider.deleteFavouriteData(index);
                                  // context.read<ProductData>().saveData();
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: AppColor.appMainColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
