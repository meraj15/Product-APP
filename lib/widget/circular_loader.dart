import 'package:flutter/material.dart';


class CircularLoader extends StatelessWidget {
  const CircularLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}