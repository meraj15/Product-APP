import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/provider/provider.dart';
import 'package:product_app/widget/filter_category_product.dart';
import 'package:provider/provider.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductData>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorites",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.imageBackgroundColor,
      ),
      //groceries
      body: Column(
        children: [
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                //   onTap: () {
                //     Provider.of<ProductData>(context, listen: false)
                //         .selectedFilter = "groceries";
                //     providerRead.notifyListeners();
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Container(
                //       height: 35,
                //       width: 120,
                //       decoration: BoxDecoration(
                //         color: Colors.black87,
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       child: Center(
                //         child: Text(
                //           "Groceries",
                //           style: TextStyle(
                //             color: AppColor.whiteColor,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Provider.of<ProductData>(context, listen: false)
                //         .selectedFilter = "furniture";
                //     providerRead.notifyListeners();
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Container(
                //       height: 35,
                //       width: 120,
                //       decoration: BoxDecoration(
                //         color: Colors.black87,
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       child: Center(
                //         child: Text(
                //           "Furniture",
                //           style: TextStyle(
                //             color: AppColor.whiteColor,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Provider.of<ProductData>(context, listen: false)
                //         .selectedFilter = "fragrances";
                //     providerRead.notifyListeners();
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Container(
                //       height: 35,
                //       width: 120,
                //       decoration: BoxDecoration(
                //         color: Colors.black87,
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       child: Center(
                //         child: Text(
                //           "Fragrances",
                //           style: TextStyle(
                //             color: AppColor.whiteColor,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Provider.of<ProductData>(context, listen: false)
                //         .selectedFilter = "Beauty";
                //     providerRead.notifyListeners();
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Container(
                //       height: 35,
                //       width: 120,
                //       decoration: BoxDecoration(
                //         color: Colors.black87,
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       child: Center(
                //         child: Text(
                //           "Beauty",
                //           style: TextStyle(
                //             color: AppColor.whiteColor,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                FilterCategoryProduct(selectedFilter: "", title: "All"),
                FilterCategoryProduct(
                    selectedFilter: "beauty", title: "Beauty"),
                FilterCategoryProduct(
                    selectedFilter: "fragrances", title: "Fragrances"),
                FilterCategoryProduct(
                    selectedFilter: "furniture", title: "Furniture"),
                FilterCategoryProduct(
                    selectedFilter: "groceries", title: "Groceries"),
              ],
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
                  final filterFavorites = provider.selectedFilter.isEmpty
                      ? favorites
                      : favorites
                          .where((element) =>
                              element.category.toLowerCase() ==
                              provider.selectedFilter.toLowerCase())
                          .toList();
                  return ListView.builder(
                    itemCount: filterFavorites.length,
                    itemBuilder: (context, index) {
                      final favoritesProduct = filterFavorites[index];
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
                                  favoritesProduct.thumbnail,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
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
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  providerRead.deleteFavoriteCard(index);
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
