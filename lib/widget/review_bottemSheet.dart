import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_app/constant/contant.dart';

class ReviewBottomSheet extends StatefulWidget {
  
  const ReviewBottomSheet({super.key});

  @override
  _ReviewBottomSheetState createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  int selectedStars = 0;
  final TextEditingController _reviewController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  void _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedImage = photo;
      });
    }
  }

  void _showReviewBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.scaffoldColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.76,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 100),
                    child: Container(
                      width: 70,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Color(0xff9b9b9b),
                      ),
                    ),
                  ),
                  const Text(
                    "What is you rate?",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff222222)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < selectedStars
                              ? Icons.star
                              : Icons.star_border_outlined,
                          color: index < selectedStars
                              ? Colors.yellow
                              : Colors.grey,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedStars = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Please share your opinion \nabout the product",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff222222)),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _reviewController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: AppColor.whiteColor,
                        hintText: "Your review",
                        hintStyle: TextStyle(
                          color: Color(0xff9b9b9b),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: _openCamera,
                        child: Container(
                          height: 122,
                          width: 133,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 1,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.camera_alt,
                                  color: Colors.red, size: 50),
                              const SizedBox(height: 8),
                              Text(
                                _selectedImage == null
                                    ? "Add your photos"
                                    : "Photo Added",
                                style: const TextStyle(),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final reviewText = _reviewController.text.trim();
                          if (reviewText.isEmpty || selectedStars == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Please provide a rating and a review."),
                              ),
                            );
                            return;
                          }
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Review submitted successfully!"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
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
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Demo"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showReviewBottomSheet(context),
          child: const Text("Write a Review"),
        ),
      ),
    );
  }
}
