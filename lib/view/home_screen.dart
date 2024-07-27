import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_app/widget/built_category.dart';
import 'package:product_app/widget/circular_loader.dart';
import 'package:product_app/widget/promo_card.dart';
import 'package:provider/provider.dart';
import '../constant/contant.dart';
import '../provider/provider.dart';
import '../widget/drawer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController userInput = TextEditingController();

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
              backgroundImage: AssetImage("assets/profile.png"),
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
                 
                  const SizedBox(
                    height: 8.0,
                  ),
                  // const PromoCard(),
                  const SizedBox(height: 8.0),
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
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            "Category '${userInput.text}' not found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.appMainColor,
            ),
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
