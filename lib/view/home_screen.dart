import 'package:flutter/material.dart';
import 'package:product_app/widget/built_category.dart';
import '../constant/contant.dart';
import '../widget/drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shopping App",
          style: TextStyle(
            color: AppColor.whiteColor,
          ),
        ),
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
