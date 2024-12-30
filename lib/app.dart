import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
import 'routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
navigationBarTheme: NavigationBarThemeData(indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
          colorScheme: ColorScheme.light(primary: AppColor.appMainColor, ),
          appBarTheme: AppBarTheme(backgroundColor: AppColor.appMainColor)),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
//

 