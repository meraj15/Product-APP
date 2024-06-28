import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/provider/provider.dart';
import 'package:provider/provider.dart';


class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
        final providerRead = context.read<ProductData>();
    return Scaffold(
      appBar: AppBar(
        title:const Text(
          "Favorites",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.imageBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ProductData>(
          builder: (context, provider, child) {
            if (provider.favorite.isEmpty) {
              return const Center(
                child: Text("No favorites yet"),
              );
            }

            return ListView.builder(
              itemCount: provider.favorite.length,
              itemBuilder: (context, index) {
                final product = provider.favorite[index];
                int rating = product.rating.ceil().toInt();
                if (rating > 5) {
                  rating = 5;
                }

                int filledStars = rating;
                int outlinedStars = 5 - filledStars;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    height: 116,
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow:const [
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
                        Container(
                          color: AppColor.imageBackgroundColor,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              product.thumbnail,
                              width: 120,
                              height: 116,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  product.brand,
                                  style:const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  product.title,
                                  style:const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                               const SizedBox(height: 4),
                                Text(
                                  "\$${product.price}",
                                  style:const TextStyle(
                                    color: AppColor.appMainColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Row(
                                    children: [
                                      ...List.generate(
                                        filledStars,
                                        (index) =>const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                                      ),
                                      // Outlined stars
                                      ...List.generate(
                                        outlinedStars,
                                        (index) =>const Icon(
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
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            providerRead
                                .deleteFavoriteCard(index);
                          },
                          icon:const Icon(
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
    );
  }


}



