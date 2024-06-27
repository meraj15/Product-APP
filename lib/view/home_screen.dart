import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/view/add_cart.dart';
import 'package:product_app/view/product_detail.dart';
import 'package:product_app/widget/bottom_navigation.dart';
import 'package:product_app/model/model.dart';
import 'package:product_app/provider/provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        backgroundColor: AppColor.appMainColor,
        centerTitle: true,
        title: const Text(
          "Shopping App",
          style: TextStyle(color: AppColor.whiteColor),
        ),
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return AddCard();
                  },
                ),
              );
            },
            icon: Badge(
              label: ValueListenableBuilder(
                valueListenable: context.read<ProductData>().totalProductCards,
                builder: (context, value, child) => Text("$value"),
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: AppColor.whiteColor,
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
      bottomNavigationBar: BottemNavigation(),
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
        int rating = product.rating.ceil().toInt();
        if (rating > 5) {
          rating = 5;
        }
        final isFavorite =
            context.watch<ProductData>().favorite.contains(product);
        int filledStars = rating;
        int outlinedStars = 5 - filledStars;

        return Container(
          margin: const EdgeInsets.all(7),
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
                              builder: (context) {
                                return ProductDetail(product: product);
                              },
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
                            child: Hero(
                              tag: product.thumbnail,
                              child: Image.network(
                                product.thumbnail,
                                fit: BoxFit.cover,
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
                              (index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                            ),
                            // Outlined stars
                            ...List.generate(
                              outlinedStars,
                              (index) => Icon(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 8.0),
                    child: Container(
                      width: 40,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColor.appMainColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Center(
                          child: Text(
                            "-${product.discountPercentage.toInt()}%",
                            style: TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
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
                            setState(() {
                              if (isFavorite) {
                                context
                                    .read<ProductData>()
                                    .favorite
                                    .remove(product);
                              } else {
                                context
                                    .read<ProductData>()
                                    .favorite
                                    .add(product);
                              }
                            });
                          },
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: AppColor.appMainColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                product.brand,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                product.title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.black54,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "\$${product.price}",
                style: TextStyle(
                  color: AppColor.appMainColor,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
