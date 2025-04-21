import 'package:flutter/material.dart';
import 'package:product_app/model/product.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:provider/provider.dart';

import 'toast.dart';

class ProductDetailBottomSheet extends StatefulWidget {
  final Product product;
  final Color bgColor;
  final Map<String, dynamic> pdata;

  const ProductDetailBottomSheet({
    super.key,
    required this.product,
    required this.bgColor,
    required this.pdata,
  });

  @override
  State<ProductDetailBottomSheet> createState() =>
      _ProductDetailBottomSheetState();
}

class _ProductDetailBottomSheetState extends State<ProductDetailBottomSheet> {
  bool isAddingToCart = false; // Track loading state

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductData>();
    final isThereInCart =
        context.watch<ProductData>().addCard.contains(widget.product);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      height: 70,
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: isAddingToCart
                ? null // Disable button during loading
                : () async {
                    if (isThereInCart) {
                      Navigator.of(context).pushNamed(AppRoutes.addCardScreen);
                    } else {
                      bool requiresSize =
                          widget.product.category == "mens-shirts" ||
                              widget.product.category == "tops" ||
                              widget.product.category == "womens-dresses";

                      if (widget.product.stock <= 0) {
                        CustomToast.showCustomToast(
                            context, "Product out of stock");
                      } else if (requiresSize && providerRead.productSize.isEmpty) {
                        CustomToast.showCustomToast(
                            context, "Please select the size");
                      } else {
                        setState(() {
                          isAddingToCart = true; // Start loading
                        });
                        try {
                           providerRead.postcartsData(widget.pdata);
                          providerRead.addCard.add(widget.product);
                          providerRead.productSize = "";
                          providerRead.addCardLength = providerRead.addCard.length;
                          CustomToast.showCustomToast(
                              context, "Added Successfully");
                        } catch (e) {
                          CustomToast.showCustomToast(
                              context, "Failed to add to cart");
                          debugPrint("Error adding to cart: $e");
                        } finally {
                          if (mounted) {
                            setState(() {
                              isAddingToCart = false; // Stop loading
                            });
                          }
                        }
                      }
                    }
                  },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: isAddingToCart
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        isThereInCart ? 'Go to Bag' : 'Add to Bag',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}