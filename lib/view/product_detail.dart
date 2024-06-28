import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

import 'package:flutter/material.dart';

import 'package:product_app/constant/contant.dart';
import 'package:product_app/model/model.dart';

import 'package:product_app/widget/product_detail_bottomsheet.dart';


import '../widget/size_show_model_sheet.dart';


class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int currentIndex = 0;
  final CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
        backgroundColor: AppColor.scaffoldColor,
        appBar: AppBar(
          backgroundColor: AppColor.appMainColor,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon:const Icon(
              Icons.arrow_back_ios,
              color: AppColor.whiteColor,
            ),
          ),
          title:const Text(
            "Detail Product",
            style: TextStyle(color: AppColor.whiteColor),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            CarouselSlider(
              items: widget.product.images.map((image) {
                return Image.network(
                  image,
                );
              }).toList(),
              options: CarouselOptions(
                height: 280,
                autoPlay: widget.product.images.length > 1 ? true : false,
                autoPlayAnimationDuration:const Duration(seconds: 1),
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
            if (widget.product.images.length > 1)
              DotsIndicator(
                dotsCount: widget.product.images.length,
                position: currentIndex,
                decorator:const DotsDecorator(
                  activeColor: AppColor.appMainColor,
                  color: Colors.grey,
                  size:  Size.square(7.0),
                  activeSize:  Size(12.0, 12.0),
                ),
                onTap: (index) {
                  carouselController.animateToPage(index.toInt());
                },
              ),
           const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                padding:const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius:
                       const BorderRadius.vertical(top: Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 1),
                      ),
                    ]),
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
                                style:const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                  fontSize: 20,
                                ),
                              ),
                             const SizedBox(height: 6),
                              Text(
                                "\$${widget.product.price.toString()}",
                                style:const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.appMainColor,
                                ),
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
                              child: const CircleAvatar(
                                backgroundColor: AppColor.whiteColor,
                                child: Icon(
                                  Icons.favorite_border,
                                  color: AppColor.appMainColor,
                                ),
                              ),
                            ),
                            Text(
                              widget.product.availabilityStatus,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: widget.product.availabilityStatus ==
                                        "Low Stock"
                                    ? AppColor.appMainColor
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
                      style:const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                   const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Brand: ${widget.product.brand}",
                          style:const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Discount: ${widget.product.discountPercentage}%",
                          style:const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColor.appMainColor,
                          ),
                        ),
                      ],
                    ),
                   const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       const Text(
                          "Choose amount:",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 105,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColor.imageBackgroundColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: AppColor.whiteColor,
                                child: IconButton(
                                    onPressed: () {
                                      widget.product.productQuantity--;
                                      setState(() {});
                                    },
                                    icon:const Icon(
                                      Icons.remove,
                                      color: Colors.black,
                                      size: 16,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  widget.product.productQuantity.toString(),
                                  style:const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.black,
                                child: IconButton(
                                    onPressed: () {
                                      widget.product.productQuantity++;
                                      setState(() {});
                                    },
                                    icon:const Icon(
                                      Icons.add,
                                      color: AppColor.whiteColor,
                                      size: 16,
                                    )),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  const  SizedBox(height: 12),
                    SizeShowModelBottomSheet(
                      product: widget.product,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomSheet: ProductDetailBottomSheet(
          product: widget.product,
        ));
  }
}
