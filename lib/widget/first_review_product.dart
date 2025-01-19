import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:product_app/model/product.dart';
import 'package:product_app/view/reviews_screen.dart';
import 'package:product_app/widget/show_image_preview_dialog.dart';
import 'package:provider/provider.dart';
import 'package:product_app/provider/product_provider.dart';

class DynamicReviewWidget extends StatefulWidget {
  final Product product;
  const DynamicReviewWidget({super.key, required this.product});

  @override
  State<DynamicReviewWidget> createState() => _DynamicReviewWidgetState();
}

class _DynamicReviewWidgetState extends State<DynamicReviewWidget> {
  @override
  void initState() {
    super.initState();
    context.read<ProductData>().getReviews(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.read<ProductData>();
    final latestReview = productProvider.productReviews.isNotEmpty
        ? productProvider.productReviews.last
        : null;
    if (productProvider.productReviews.isNotEmpty) {
      double sum = 0.0;
      for (var review in productProvider.productReviews) {
        sum += review['rating'];
      }
      productProvider.averageRating =
          sum / productProvider.productReviews.length;
    }

    String formatDate(String dateString) {
      final DateFormat formatter = DateFormat('d MMM yyyy');
      final DateTime dateTime = DateTime.parse(dateString);
      return formatter.format(dateTime);
    }

    if (productProvider.productReviews.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ratings & Reviews",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const Divider(color: Color(0xff9b9b9b)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${productProvider.averageRating.toStringAsFixed(1)}/",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 13.0),
                        child: const Text(
                          "5",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  RatingBarIndicator(
                    rating: productProvider.averageRating,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Overall Rating",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${productProvider.productReviews.length} Ratings",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Divider(color: Color(0xff9b9b9b)),
          const SizedBox(height: 4),

          // Latest Review Content
          Text(
            latestReview != null
                ? latestReview['comment']
                : "No reviews yet. Be the first to review!",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          if (latestReview != null && latestReview['product_images'] != null)
            Row(
              children: List.generate(
                (latestReview['product_images'] as List).length,
                (imgIndex) => GestureDetector(
                  onTap: () {
                    ShowImageDialog.showImageDialog(
                      context,
                      latestReview['product_images'][imgIndex],
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        latestReview['product_images'][imgIndex],
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 10),

          Text(
            latestReview != null
                ? "${latestReview['reviewer_name']}, ${formatDate(latestReview['date'])}"
                : "",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 10),
          const Divider(color: Color(0xff9b9b9b)),

          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ReviewScreen(
                    product: widget.product,
                  ),
                ),
              );
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "View All ${productProvider.productReviews.length} Reviews",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
