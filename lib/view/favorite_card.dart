import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/provider/provider.dart';
import 'package:provider/provider.dart';

import '../widget/filter_category_product.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key? key});

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductData>();
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
      appBar: AppBar(
        title: const Text(
          "Favorites",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            // Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
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
                  FilterCategoryProduct(
                    selectedFilter: "beauty",
                    title: "Beauty",
                    icon: Icons.brush,
                  ),
                  FilterCategoryProduct(
                    selectedFilter: "fragrances",
                    title: "Fragrances",
                    icon: Icons.spa,
                  ),
                  FilterCategoryProduct(
                    selectedFilter: "furniture",
                    title: "Furniture",
                    icon: Icons.weekend,
                  ),
                  FilterCategoryProduct(
                    selectedFilter: "groceries",
                    title: "Groceries",
                    icon: Icons.local_grocery_store,
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
                  if (provider.favorite.isEmpty) {
                    return const Center(
                      child: Text("No favorites yet"),
                    );
                  }
                  final favorites = provider.favorite;
                  provider.filterFavorites = provider.selectedFilter.isEmpty
                      ? favorites
                      : favorites
                          .where((element) =>
                              element.category.toLowerCase() ==
                              provider.selectedFilter.toLowerCase())
                          .toList();
                  if (provider.filterFavorites.isEmpty) {
                    return const Center(
                      child: Text("No Selected yet"),
                    );
                  }
                  return ListView.builder(
                    itemCount: provider.filterFavorites.length,
                    itemBuilder: (context, index) {
                      final favoritesProduct = provider.filterFavorites[index];
                      int rating = favoritesProduct.rating.ceil().toInt();
                      if (rating > 5) {
                        rating = 5;
                      }

                      int filledStars = rating;
                      int outlinedStars = 5 - filledStars;
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
                                  favoritesProduct.images.first,
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
                                  providerRead.deleteFavoriteCard(index);
                                  providerRead.deleteFilteredCard(index);
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
