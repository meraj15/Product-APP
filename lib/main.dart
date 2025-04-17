import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:product_app/Auth/auth_service.dart';
import 'package:product_app/app.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String userID = "";

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://njzvyrsxbwxpcyclztzo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5qenZ5cnN4Ynd4cGN5Y2x6dHpvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzcyMjM3MjUsImV4cCI6MjA1Mjc5OTcyNX0.vGwsuM9G2YzWBpPN0V89gisK6IvXvZF2nldihkwrZmI',
  );
  final isLoggedIn = await AuthService.getLoginStatus();
  userID = await AuthService.getUserId();
  debugPrint("main  : $userID");
 await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductData(),
      child: MyApp(
        isLoggedIn: isLoggedIn,
      ),
    ),
  );
}
