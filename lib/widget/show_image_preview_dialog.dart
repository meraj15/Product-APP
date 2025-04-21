import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';

class ShowImageDialog{
    static void showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              // Full-Screen Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, size: 20);
                              },
                  width: MediaQuery.of(context).size.width * 0.9,
                  // height: MediaQuery.of(context).size.height * 0.7,
                ),
              ),
              // Close Button
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColor.whiteColor,
                      size: 24,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}