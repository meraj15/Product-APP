import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/contant.dart';
import '../provider/product_provider.dart';

class FilterCategoryProduct extends StatelessWidget {
  final String title;
  final String selectedFilter;
  final IconData icon;

  const FilterCategoryProduct({
    super.key,
    required this.selectedFilter,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected =
        context.watch<ProductData>().selectedFilter == selectedFilter;

    final screenWidth = MediaQuery.of(context).size.width;

    final fontSize = screenWidth * 0.04;

    return GestureDetector(
      onTap: () {
        context.read<ProductData>().updateFilter(selectedFilter);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
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
