import 'package:flutter/material.dart';
import 'package:product_app/Auth/auth_service.dart';
import 'package:product_app/app.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:provider/provider.dart';

String userID="";
 
void main(List<String> args) async{
WidgetsFlutterBinding.ensureInitialized();
  final isLoggedIn = await AuthService.getLoginStatus();
   userID = await AuthService.getUserId();
  debugPrint("main  : $userID");
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductData(),
      child:  MyApp(isLoggedIn: isLoggedIn,),
    ),
  );
}
