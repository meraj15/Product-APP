import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:product_app/constant/contant.dart';

class CustomToast {
  static void showCustomToast(BuildContext context, String message) {
    showToastWidget(
      _buildToastWidget(message),
      context: context,
      isIgnoring: false,
      duration: const Duration(seconds: 2),
      position: StyledToastPosition.top,
      animDuration: const Duration(milliseconds: 400),
      animation: StyledToastAnimation.slideFromTopFade,
      reverseAnimation: StyledToastAnimation.slideToTopFade,
    );
  }

  static Widget _buildToastWidget(String message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 60),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: AppColor.appMainColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
