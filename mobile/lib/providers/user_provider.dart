import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  bool loading = false;

  List<User> get users => _users;

  // 🔑 Get token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  // 🔥 Fetch all users (admin only)
  Future<void> fetchUsers() async {
    loading = true;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        print("⚠️ No token found, cannot fetch users");
        _users = [];
        loading = false;
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse("http://10.0.2.2:8080/api/users"), // your backend endpoint
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // 👈 Send token
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _users = data.map((json) => User.fromJson(json)).toList();
      } else {
        print("❌ Failed to fetch users: ${response.statusCode}");
        _users = [];
      }
    } catch (e) {
      print("🔥 Error fetching users: $e");
      _users = [];
    }

    loading = false;
    notifyListeners();
  }

  // Delete user
  Future<void> deleteUser(int id) async {
    final token = await _getToken();
    if (token == null) return;

    final response = await http.delete(
      Uri.parse("http://10.0.2.2:8080/api/users/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      _users.removeWhere((u) => u.id == id);
      notifyListeners();
    } else {
      print("❌ Failed to delete user: ${response.statusCode}");
    }
  }
  // inside UserProvider class

  Future<void> updateUser(User user) async {
    final token = await _getToken();
    if (token == null) return;

    final response = await http.put(
      Uri.parse("http://10.0.2.2:8080/api/users/${user.id}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "username": user.username,
        "role": user.role,
      }),
    );

    if (response.statusCode == 200) {
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = user;
        notifyListeners();
      }
    } else {
      print("❌ Failed to update user: ${response.statusCode}");
    }
  }

}
