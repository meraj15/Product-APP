import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_app/widget/built_category.dart';
import '../constant/contant.dart';
import '../widget/drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
      appBar: AppBar(
        title: Text("Flutter Market",
            style: GoogleFonts.pacifico(
              color: AppColor.whiteColor,
              fontWeight: FontWeight.w200,
            )),
        centerTitle: true,
        backgroundColor: AppColor.appMainColor,
        iconTheme: const IconThemeData(color: AppColor.whiteColor),
      ),
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
        ),
      ),
    );
  }

  Widget buildCategorySection(BuildContext context, String category) {
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
                color: Color(0xff2c2c2c)),
          ),
        ),
        SizedBox(
          height: 320,
          child: BuiltCategory(
            category: category,
            context: context,
            color: AppColor.scaffoldColor,
          ),
        ),
      ],
    );
  }
}
