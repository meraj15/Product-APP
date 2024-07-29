import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:product_app/widget/built_category.dart';
import 'package:product_app/widget/circular_loader.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import '../constant/contant.dart';
import '../provider/provider.dart';
import '../widget/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController userInput = TextEditingController();
  List<String> assets = [
    'assets/images/beauty.png',
    'assets/images/furniture.png',
    'assets/images/offer.png',
  ];

  int _currentIndex = 0; // Track the current index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
      appBar: AppBar(
        title: Text(
          "Flutter Market",
          style: GoogleFonts.pacifico(
            fontWeight: FontWeight.w200,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile.png"),
              radius: 26,
            ),
          )
        ],
      ),
      drawer: const DrawerWidget(),
      body: context.watch<ProductData>().isLoaded
          ? const CircularLoader()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: userInput,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12.0),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: userInput.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    userInput.clear();
                                  });
                                },
                                icon:
                                    const Icon(Icons.close, color: Colors.grey),
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
                              const BorderSide(color: AppColor.appMainColor),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onSubmitted: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  if (userInput.text.isEmpty)
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
                              return Builder(
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child:
                                        Image.asset(asset, fit: BoxFit.cover),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                          DotsIndicator(
                            dotsCount: assets.length,
                            position: _currentIndex,
                            decorator: DotsDecorator(
                              activeColor: AppColor.appMainColor,
                              color: Colors.grey, // Inactive color
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
                  if (userInput.text.isNotEmpty)
                    buildCategorySection(context, userInput.text.toLowerCase())
                  else
                    buildAllCategories(context),
                ],
              ),
            ),
    );
  }

  Widget buildAllCategories(BuildContext context) {
    return Column(
      children: [
        buildCategorySection(context, "beauty"),
        buildCategorySection(context, "fragrances"),
        buildCategorySection(context, "furniture"),
        buildCategorySection(context, "groceries"),
        buildCategorySection(context, "home-decoration"),
        buildCategorySection(context, "kitchen-accessories"),
        buildCategorySection(context, "laptops"),
        buildCategorySection(context, "mens-shirts"),
        buildCategorySection(context, "mens-shoes"),
        buildCategorySection(context, "mens-watches"),
        buildCategorySection(context, "mobile-accessories"),
        buildCategorySection(context, "motorcycle"),
        buildCategorySection(context, "skin-care"),
        buildCategorySection(context, "smartphones"),
        buildCategorySection(context, "sports-accessories"),
        buildCategorySection(context, "sunglasses"),
        buildCategorySection(context, "tablets"),
        buildCategorySection(context, "tops"),
        buildCategorySection(context, "vehicle"),
        buildCategorySection(context, "womens-bags"),
        buildCategorySection(context, "womens-dresses"),
        buildCategorySection(context, "womens-jewellery"),
        buildCategorySection(context, "womens-shoes"),
        buildCategorySection(context, "womens-watches"),
      ],
    );
  }

  Widget buildCategorySection(BuildContext context, String category) {
    final providerWatch = context.watch<ProductData>();
    final filterProduct = providerWatch.products
        .where((element) => element.category.toLowerCase() == category)
        .toList();

    final isCategoryFound = filterProduct.isNotEmpty;

    if (userInput.text.isNotEmpty && !isCategoryFound) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 90),
        child: Center(
          child: SizedBox(
            height: 250,
            width: 400,
            child:
                Lottie.asset("assets/lottie_animation/product_not_found.json"),
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
          child: BuiltCategory(
            category: category,
            color: AppColor.scaffoldColor,
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
