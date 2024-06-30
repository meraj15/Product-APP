import 'package:flutter/material.dart';
import 'package:product_app/provider/provider.dart';
import 'package:product_app/widget/product_card.dart';
import 'package:provider/provider.dart';

import '../constant/contant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Screen"),
        ),
        body: SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              final product = context.watch<ProductData>().products[index];
              final providerWatch = context.watch<ProductData>();

              final providerRead = context.read<ProductData>();
              final isFavorite = providerWatch.favorite.contains(product);
              int rating = product.rating.ceil().toInt();
              if (rating > 5) {
                rating = 5;
              }
              int filledStars = rating;
              int outlinedStars = 5 - filledStars;
              return Container(
                margin: const EdgeInsets.all(7),
                width: 200,
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
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) {
                                //       return ProductDetail(product: product);
                                //     },
                                //   ),
                                // );
                              },
                              child: Container(
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColor.imageBackgroundColor,
                                ),
                                child: SizedBox(
                                  width: 200,
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
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
                                  // Outlined stars
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
                              color: AppColor.appMainColor,
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
                                  providerRead.favorites(product);
                                },
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
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
                    Text(
                      "\$${product.price}",
                      style: const TextStyle(
                        color: AppColor.appMainColor,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }
}
