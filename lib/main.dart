import 'package:flutter/material.dart';
import 'package:product_app/app.dart';
import 'package:product_app/provider/provider.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductData(),
      child: MyApp(),
    ),
  );
}
