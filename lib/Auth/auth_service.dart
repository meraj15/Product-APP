import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _userIdKey = "userId";
  static const String _isLoggedInKey = "isLoggedIn";

  // Save user ID
  static Future<void> saveUserId(String userId) async {
    debugPrint("userId auth: $userId");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  // Retrieve user ID
  static Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey) ?? "";
  }

  // Save login status
  static Future<void> setLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  // Retrieve login status
  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    return await getLoginStatus(); // Delegating to getLoginStatus
  }

  // Clear all user data (logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey); // Clear user ID
    await prefs.remove(_isLoggedInKey); // Clear login status
  }

  // Clear all preferences (optional utility)
  static Future<void> clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
