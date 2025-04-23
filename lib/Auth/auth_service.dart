import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _userIdKey = "userId";
  static const String _isLoggedInKey = "isLoggedIn";
  static const String _jwtTokenKey = "jwt_token";

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
    return await getLoginStatus();
  }

  // Save JWT token
  static Future<void> saveToken(String token) async {
    debugPrint("Saving token: $token");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_jwtTokenKey, token);
  }

  // Retrieve JWT token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_jwtTokenKey);
    debugPrint("Retrieved token: $token");
    return token;
  }

  // Clear all user data (logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey); // Clear user ID
    await prefs.remove(_isLoggedInKey); // Clear login status
    await prefs.remove(_jwtTokenKey); // Clear JWT token
    debugPrint("User logged out, all auth data cleared");
  }

  // Clear all preferences (optional utility)
  static Future<void> clearAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    debugPrint("All preferences cleared");
  }
}