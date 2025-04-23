import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:product_app/Auth/auth_service.dart';
import 'package:product_app/main.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/widget/built_category.dart';
import 'package:product_app/widget/circular_loader.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import '../constant/contant.dart';
import '../provider/product_provider.dart';
import '../widget/drawer.dart';
import '../view/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController userHomeSearchInput = TextEditingController();
  List<String> assets = [
    'assets/images/beauty.gif',
    'assets/images/product.gif',
    'assets/images/republic_sale.gif',
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ProductData>().getUserDetail(context);
    userHomeSearchInput.clear();
    loadData();
  }

  void loadData()async {
    userID =await AuthService.getUserId();
    context.read<ProductData>().getData();
  }

  @override
  void dispose() {
    userHomeSearchInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductData>();
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColor.whiteColor),
        title: Text(
          "E-Commerce App",
          style: GoogleFonts.pacifico(
            fontWeight: FontWeight.w200,
            color: AppColor.whiteColor,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.profileScreen);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    providerWatch.userDetails.isNotEmpty
                        ? providerWatch.getInitials(
                            providerWatch.userDetails[0]["name"] ?? "")
                        : "",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: providerWatch.isLoaded
          ? const CircularLoader()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onTapOutside: (e) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      controller: userHomeSearchInput,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12.0),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: userHomeSearchInput.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  userHomeSearchInput.clear();
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
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  userHomeSearchInput.text.isEmpty
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      height: 200.0,
                                      autoPlay: true,
                                      enlargeCenterPage: true,
                                      aspectRatio: 16 / 9,
                                      viewportFraction: 1.0,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _currentIndex = index;
                                        });
                                      },
                                    ),
                                    items: assets.map((asset) {
                                      return SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            asset,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 10),
                                  DotsIndicator(
                                    dotsCount: assets.length,
                                    position: _currentIndex,
                                    decorator: DotsDecorator(
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      color: Colors.grey,
                                      size: const Size.square(9.0),
                                      activeSize: const Size(18.0, 9.0),
                                      activeShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            buildAllCategories(context),
                          ],
                        )
                      : buildSearchResults(context, userHomeSearchInput.text),
                ],
              ),
            ),
    );
  }

  Widget buildSearchResults(BuildContext context, String searchText) {
    final providerRead = context.read<ProductData>();
    final providerWatch = context.watch<ProductData>();
    final filteredProducts = providerWatch.products
        .where((product) =>
            product.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    if (filteredProducts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 90),
        child: Center(
          child: SizedBox(
            height: 250,
            width: 400,
            child: Lottie.asset("assets/lottie_animation/product_not_found.json"),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Search Results",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xff2c2c2c),
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.55,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            final isFavorite = providerWatch.favorite.contains(product);
            final rating = product.rating.clamp(0, 5).ceil();
            final filledStars = rating;
            final outlinedStars = 5 - filledStars;

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.whiteColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetail(product: product),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor.imageBackgroundColor,
                              ),
                              child: SizedBox(
                                height: 200,
                                child: Center(
                                  child: Image.network(
                                    product.category == "smartphones" ||
                                            product.category == "vehicle"
                                        ? product.images.first
                                        : product.thumbnail,
                                        errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, size: 20);
                              },
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              children: [
                                ...List.generate(
                                  filledStars,
                                  (index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                ),
                                ...List.generate(
                                  outlinedStars,
                                  (index) => const Icon(
                                    Icons.star_outline,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 180,
                        left: 122,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: AppColor.whiteColor,
                            child: GestureDetector(
                              onTap: () {
                                Map<String, dynamic> favoriteData = {
                                  'id': product.id,
                                  'brand': product.brand,
                                  'title': product.title,
                                  'thumbnail': product.thumbnail,
                                  'price': product.price,
                                  'rating': product.rating,
                                  'warrantyinformation':
                                      product.warrantyInformation,
                                  'userid': userID,
                                  'category': product.category,
                                };
                                providerRead.toggleFavorite(
                                    product, favoriteData,context);
                              },
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    product.brand,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        "\$${(product.price * (1 + product.discountPercentage / 100)).toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "\$${product.price}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildAllCategories(BuildContext context) {
    const categories = [
      "beauty",
      "fragrances",
      "furniture",
      "groceries",
      "home-decoration",
      "kitchen-accessories",
      "laptops",
      "mens-shirts",
      "mens-shoes",
      "mens-watches",
      "mobile-accessories",
      "motorcycle",
      "skin-care",
      "smartphones",
      "sports-accessories",
      "sunglasses",
      "tablets",
      "tops",
      "vehicle",
      "womens-bags",
      "womens-dresses",
      "womens-jewellery",
      "womens-shoes",
      "womens-watches",
    ];

    return Column(
      children: categories
          .map((category) => buildCategorySection(context, category))
          .toList(),
    );
  }

  Widget buildCategorySection(BuildContext context, String category) {
    final providerWatch = context.watch<ProductData>();
    final filterProduct = providerWatch.products
        .where((element) => element.category.toLowerCase() == category)
        .toList();

    if (filterProduct.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category[0].toUpperCase() + category.substring(1),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xff2c2c2c),
            ),
          ),
        ),
        SizedBox(
          height: 320,
          child:
              BuiltCategory(category: category, color: AppColor.scaffoldColor),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}