import 'package:flutter/foundation.dart';
import '../core/api_service.dart'; // Your existing API service


class AuthProvider with ChangeNotifier {
  final ApiService api = ApiService();

  String? _role; // store logged-in role if needed

  String? get role => _role;

  // --- Login method ---
  Future<bool> login({
    required String username,
    required String password,
    required String role,
  }) async {
    try {
      final resp = await api.post(
        '/api/login',
        data: {
          'username': username,
          'password': password,
          'role': role,
        },
      );

      if (resp.statusCode == 200) {
        // Optionally save token, user info, role, etc.
        _role = role;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Login error: $e");
      }
      return false;
    }
  }

  // --- Logout method ---
  void logout() {
    _role = null;
    // optionally clear token
    notifyListeners();
  }
}
