import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';

// ignore: must_be_immutable
class SortProduct extends StatelessWidget {
  Product? product;
  SortProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xfff3f3f3),
                border: Border.all(
                  width: 1.0,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      height: 5,
                      width: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xff9B9B9B),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Sort by",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Consumer<ProductData>(
                      builder: (context, watchProvider, child) {
                        return ListView(
                          children: [
                            ListTile(
                              leading:const Icon(Icons.price_change,
                                  color: AppColor.appMainColor),
                              title: const Text('Price: High to Low'),
                              onTap: () {
                                context
                                    .read<ProductData>()
                                    .setSort("High to Low");

                                context
                                    .read<ProductData>()
                                    .productPriceHightoLow();
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading:const Icon(Icons.price_change,
                                  color: AppColor.appMainColor),
                              title: const Text('Price: Low to High'),
                              onTap: () {
                                context
                                    .read<ProductData>()
                                    .setSort("Low to High");
                                context
                                    .read<ProductData>()
                                    .productPriceLowtoHigh();

                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading:const Icon(Icons.star, color: Colors.amber),
                              title: const Text('Rating: Best Rating'),
                              onTap: () {
                                context
                                    .read<ProductData>()
                                    .setSort("Best Rating");
                                context
                                    .read<ProductData>()
                                    .productRatingHightoLow();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           const Row(
              children: [
                Icon(Icons.filter_list, color: Colors.black),
                 SizedBox(width: 8),
                 Text(
                  "Filters",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              children: [
              const  Icon(Icons.swap_vert, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  context.read<ProductData>().selectedSortFilter,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
           const Icon(Icons.view_list, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
