import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/main.dart';
import 'package:product_app/model/product.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AllMyReviews extends StatefulWidget {
  const AllMyReviews({super.key});

  @override
  State<AllMyReviews> createState() => _AllMyReviewsState();
}

class _AllMyReviewsState extends State<AllMyReviews> {
  int selectedStar = 0; // 0 means "All" reviews

  @override
  void initState() {
    super.initState();
    context.read<ProductData>().fetchMyAllReviews(userID);
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
        ? providerRead.userAllReviews
        : providerRead.userAllReviews
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
          "My ALL Ratings & Reviews",
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
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  decoration: BoxDecoration(
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
                        "review['title']",
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
                      if (review['images'] != null &&
                          (review['images'] as List).isNotEmpty)
                        Row(
                          children: List.generate(
                            (review['images'] as List).length,
                            (imgIndex) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  review['images'][imgIndex],
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
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
                    ? const Icon(Icons.check, color: Colors.blue)
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
