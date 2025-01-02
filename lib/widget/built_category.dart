import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/main.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:provider/provider.dart';

import '../view/product_detail.dart';

class BuiltCategory extends StatelessWidget {
  final Color color;
  final String category;

  const BuiltCategory({
    super.key,
    required this.category,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductData>();
    final providerWatch = context.watch<ProductData>();
    final userInput = providerRead.userInput.text.toLowerCase();

    final filterProduct = userInput.isEmpty
        ? providerRead.products
            .where((element) => element.category.toLowerCase() == category)
            .toList()
        : providerRead.products
            .where((element) =>
                element.category.toLowerCase() == category &&
                element.title.toLowerCase().contains(userInput))
            .toList();

    return Scaffold(
      backgroundColor: color,
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filterProduct.length,
        itemBuilder: (context, index) {
          final product = filterProduct[index];
          final isFavorite = providerWatch.favorite.contains(product);
          int rating = product.rating.ceil();
          if (rating > 5) {
            rating = 5;
          }
          int filledStars = rating;
          int outlinedStars = 5 - filledStars;

          return Container(
            width: 200,
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
                              child: Center(
                                child: Image.network(
                                  product.category == "smartphones" || product.category == "vehicle"?
                                  product.images.first :
                                  product.thumbnail,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 8.0),
                      child: Container(
                        width: 40,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: Text(
                              "-${product.discountPercentage.toInt()}%",
                              style: const TextStyle(
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
                      left: 155,
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
                                'category':product.category,
                              };

                              providerRead.toggleFavorite(product, favoriteData);
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
                    color: Color.fromARGB(255, 28, 8, 8),
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
                      style:  TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
