import 'package:flutter/material.dart';
import 'package:product_app/view/home_screen.dart';

import 'view/favorite_card.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
//

 