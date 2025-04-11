import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
import 'routes/app_routes.dart';

class MyApp extends StatelessWidget {
 final bool isLoggedIn;
 
  const MyApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        navigationBarTheme: NavigationBarThemeData(
            indicatorColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.2)),
        colorScheme:const ColorScheme.light(
          primary: AppColor.appMainColor,
        ),
        appBarTheme:const AppBarTheme(backgroundColor: AppColor.appMainColor),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute:isLoggedIn ? AppRoutes.bottemNavigationBar : AppRoutes.initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
//

 