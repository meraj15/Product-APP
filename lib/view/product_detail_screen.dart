import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/main.dart';
import 'package:product_app/model/product.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/widget/built_category.dart';
import 'package:product_app/widget/first_review_product.dart';
import 'package:product_app/widget/product_detail_bottomsheet.dart';
import 'package:provider/provider.dart';
import '../widget/size_show_model_sheet.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int currentIndex = 0;
  late final CarouselSliderController carouselController; // Fixed type

  @override
  void initState() {
    super.initState();
    carouselController = CarouselSliderController(); // Initialize correctly
  }

  String getStockStatus(dynamic stock) {
    int stockValue = 0;
    if (stock is int) {
      stockValue = stock;
    } else if (stock is String) {
      stockValue = int.tryParse(stock) ?? 0;
    } else if (stock == null) {
      stockValue = 0;
    }
    if (stockValue == 0) return "Out of Stock";
    if (stockValue <= 10) return "Low Stock";
    return "In Stock";
  }

  Color getStockColor(dynamic stock) {
    int stockValue = 0;
    if (stock is int) {
      stockValue = stock;
    } else if (stock is String) {
      stockValue = int.tryParse(stock) ?? 0;
    } else if (stock == null) {
      stockValue = 0;
    }
    if (stockValue == 0) return Colors.grey;
    if (stockValue <= 10) return Colors.red;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductData>();
    final isFavorite = providerWatch.favorite.contains(widget.product);

    // Debug print to check stock value
    print('Stock: ${widget.product.stock}, Type: ${widget.product.stock.runtimeType}');

    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(); // Return to previous screen
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColor.whiteColor,
          ),
        ),
        title: Text(
          "Detail Product",
          style: GoogleFonts.pacifico(color: AppColor.whiteColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CarouselSlider(
              carouselController: carouselController, // Fixed controller
              items: widget.product.images.map((image) {
                return Image.network(
                  image,
                  fit: BoxFit.cover,
                );
              }).toList(),
              options: CarouselOptions(
                height: 300,
                autoPlay: widget.product.images.length > 1,
                autoPlayAnimationDuration: const Duration(seconds: 1),
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
            if (widget.product.images.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: DotsIndicator(
                  dotsCount: widget.product.images.length,
                  position: currentIndex,
                  decorator: DotsDecorator(
                    activeColor: Theme.of(context).colorScheme.primary,
                    color: Colors.grey,
                    size: const Size.square(7.0),
                    activeSize: const Size(12.0, 12.0),
                  ),
                  onTap: (index) {
                    carouselController.animateToPage(
                      index,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeIn,
                    );
                  },
                ),
              ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                fontSize: 22,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "\$${(widget.product.price * (1 + widget.product.discountPercentage / 100)).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "\$${widget.product.price.toString()}",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Map<String, dynamic> favoriteData = {
                                  'id': widget.product.id,
                                  'brand': widget.product.brand,
                                  'title': widget.product.title,
                                  'thumbnail': widget.product.thumbnail,
                                  'price': widget.product.price,
                                  'rating': widget.product.rating,
                                  'warrantyinformation':
                                      widget.product.warrantyInformation,
                                  'userid': userID, // Global userID from main.dart
                                };

                                context.read<ProductData>().toggleFavorite(
                                    widget.product, favoriteData);
                              },
                              child: CircleAvatar(
                                backgroundColor: AppColor.whiteColor,
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            getStockStatus(widget.product.stock),
                            style: TextStyle(
                              color: getStockColor(widget.product.stock),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.product.description,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Brand: ${widget.product.brand}",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Discount: ${widget.product.discountPercentage}%",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "⭐ ${providerWatch.averageRating.toStringAsFixed(1)} (${providerWatch.productReviews.length} reviews)"),
                      if (widget.product.category == "mens-shirts" ||
                          widget.product.category == "tops" ||
                          widget.product.category == "womens-dresses")
                        SizeShowModelBottomSheet(
                          product: widget.product,
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ProductDetailBottomSheet(
                      product: widget.product,
                      bgColor: AppColor.whiteColor,
                      pdata: {
                        'id': widget.product.id,
                        'title': widget.product.title,
                        'thumbnail': widget.product.thumbnail,
                        'brand': widget.product.brand,
                        'price': widget.product.price,
                        'userid': userID,
                        'quantity': 1,
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Related Products",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 320,
              child: BuiltCategory(
                category: widget.product.category,
                color: AppColor.whiteColor,
                product: widget.product,
              ),
            ),
            const SizedBox(height: 8.0),
            DynamicReviewWidget(product: widget.product),
          ],
        ),
      ),
    );
  }
}