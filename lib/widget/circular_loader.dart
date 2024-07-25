import 'package:flutter/material.dart';

import '../constant/contant.dart';

class CircularLoader extends StatelessWidget {
  const CircularLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColor.appMainColor,
      ),
    );
  }
}