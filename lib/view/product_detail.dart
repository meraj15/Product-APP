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
  late final CarouselController carouselController;
  void initstate() {
    carouselController = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite =
        context.watch<ProductData>().favorite.contains(widget.product);
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.bottemNavigationBar);
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
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
                    carouselController.animateTo(
                      index.toDouble(),
                      duration: Duration(seconds: 1),
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
                                  'userid': userID,
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
                            widget.product.availabilityStatus,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: widget.product.availabilityStatus ==
                                      "Low Stock"
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.green,
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
                  SizeShowModelBottomSheet(
                    product: widget.product,
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
                // context: context,
                color: AppColor.whiteColor,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
           
  DynamicReviewWidget(product: widget.product) 
 

          ],
        ),
      ),
    );
  }
}
