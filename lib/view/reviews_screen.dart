import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/model/product.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/widget/show_image_preview_dialog.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReviewScreen extends StatefulWidget {
  final Product product;
  const ReviewScreen({super.key, required this.product});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int selectedStar = 0; // 0 means "All" reviews

  @override
  void initState() {
    super.initState();
    context.read<ProductData>().getReviews(widget.product.id);
  }

  String formatDate(String dateString) {
    final DateFormat formatter = DateFormat('d MMM yyyy');
    final DateTime dateTime = DateTime.parse(dateString);
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final providerRead = context.watch<ProductData>();
    final reviews = selectedStar == 0
        ? providerRead.productReviews
        : providerRead.productReviews
            .where((review) => review['rating'] == selectedStar)
            .toList();

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Ratings & Reviews",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              _openFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: reviews.isEmpty
          ? const Center(
              child: Text("No reviews available."),
            )
          : ListView.separated(
              separatorBuilder: (context, index) =>const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  color: Color(0xff9b9b9b),
                ),
              ),
              itemCount: reviews.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                  decoration:const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Star Rating
                      RatingBarIndicator(
                        rating: (review['rating'] ?? 0).toDouble(),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20,
                      ),
                      const SizedBox(height: 8),

                      // Title
                      Text(
                        widget.product.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Comment
                      Text(
                        review['comment'] ??
                            "No comment available for this review.",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Images
                      if (review['product_images'] != null &&
                          (review['product_images'] as List).isNotEmpty)
                        Row(
                          children: List.generate(
                            (review['product_images'] as List).length,
                            (imgIndex) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  ShowImageDialog.showImageDialog(
                                    context,
                                    review['product_images'][imgIndex],
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    review['product_images'][imgIndex],
                                    width: 70,
                                    height: 70,
                                    errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, size: 20);
                              },
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),


                      // Reviewer Info and Date
                      Text(
                        "${review['reviewer_name']}, ${formatDate(review['date'] ?? '')}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  
  void _openFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Filter Reviews",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text("All"),
                onTap: () {
                  setState(() {
                    selectedStar = 0;
                  });
                  Navigator.pop(context);
                },
                trailing: selectedStar == 0
                    ? const Icon(Icons.check, color: AppColor.appMainColor)
                    : null,
              ),
              for (int i = 1; i <= 5; i++)
                ListTile(
                  title: Text("$i Star${i > 1 ? 's' : ''}"),
                  onTap: () {
                    setState(() {
                      selectedStar = i;
                    });
                    Navigator.pop(context);
                  },
                  trailing: selectedStar == i
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                ),
            ],
          ),
        );
      },
    );
  }
}
