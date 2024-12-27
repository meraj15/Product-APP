import 'package:flutter/material.dart';
import 'package:product_app/app.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLogged = false;
String userID="";
void main(List<String> args) async{
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences logged = await SharedPreferences.getInstance();
//  isLogged = logged.getBool("logged") ?? true;
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductData(),
      child: const MyApp(),
    ),
  );
}
