import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/main.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ReviewBottomSheet extends StatefulWidget {
  final int productId;
  final String productTitle;
  final String productThumbnail;

  const ReviewBottomSheet({
    super.key,
    required this.productId,
    required this.productTitle,
    required this.productThumbnail,
  });

  @override
  _ReviewBottomSheetState createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  int selectedStars = 0;
  final TextEditingController _reviewController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFiles = []; // List to store multiple images

  Future<void> _openCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFiles.add(pickedFile);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 130.0),
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xff9b9b9b),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          width: 90,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              widget.productThumbnail,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  widget.productTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: List.generate(5, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedStars = index + 1;
                                        });
                                      },
                                      child: Icon(
                                        index < selectedStars
                                            ? Icons.star
                                            : Icons.star_border_outlined,
                                        color: index < selectedStars
                                            ? Colors.amber
                                            : Colors.grey,
                                        size: 30,
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(1, 1.5),
                ),
              ],
            ),
            child: TextField(
              controller: _reviewController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
                hintText: "Your review",
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Add your photos",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
        SizedBox(
  height: 100,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: _imageFiles.length + 1, // +1 for the camera icon
    itemBuilder: (context, index) {
      if (index == 0) {
        // Always show the camera icon as the first item
        return GestureDetector(
          onTap: _openCamera,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 30,
            ),
          ),
        );
      } else {
        // Show selected images starting from index 1
        final imageIndex = index - 1;
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(_imageFiles[imageIndex].path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removeImage(imageIndex),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        );
      }
    },
  ),
),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final reviewText = _reviewController.text.trim();
                  if (reviewText.isEmpty || selectedStars == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please provide a rating and a review."),
                      ),
                    );
                    return;
                  }

                  final reviewData = {
                    "rating": selectedStars,
                    "comment": reviewText,
                    "userid":userID,
                  };

                  context
                      .read<ProductData>()
                      .postReviews(context, reviewData, widget.productId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  "SEND REVIEW",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
