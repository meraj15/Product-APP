import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/contant.dart';
import '../model/product.dart';
import '../provider/product_provider.dart';
import '../view/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Map<String, dynamic> pdata;

  const ProductCard({
    super.key,
    required this.product,
    required this.pdata,
  });

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductData>();
    final providerRead = context.read<ProductData>();

    // Check if the product is marked as favorite
    final isFavorite = providerWatch.favorite.contains(product);

    int rating = product.rating.ceil().toInt();
    if (rating > 5) {
      rating = 5;
    }
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
                      onTap: () async {
                        providerRead.toggleFavorite(product, pdata);
                      },
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
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
              color: Colors.black54,
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
  }
}
