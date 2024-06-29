import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/contant.dart';
import '../provider/provider.dart';

class FilterCategoryProduct extends StatelessWidget {
  final String title;
  final String selectedFilter;
  const FilterCategoryProduct({
    super.key,
    required this.selectedFilter,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductData>();

    return GestureDetector(
      onTap: () {
        Provider.of<ProductData>(context, listen: false).selectedFilter =
            selectedFilter;
        providerRead.notifyListeners();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 35,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style:const TextStyle(
                color: AppColor.whiteColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
