import 'api_service.dart';
import 'secure_storage.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // ---------------- LOGIN ----------------
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _apiService.post("/api/users/login", {
      "username": username,
      "password": password,
    });

    // Save JWT token if backend returns it
    if (response.data != null && response.data.containsKey('token')) {
      await SecureStorage.write('jwt_token', response.data['token']);
    }

    // Return user data (username + role)
    return response.data;
  }

  // ---------------- SIGNUP (for clients) ----------------
  Future<Map<String, dynamic>> signup(String username, String email, String password) async {
    final response = await _apiService.post("/api/users/signup", {
      "username": username,
      "email": email,
      "password": password,
    });

    // Optionally, save token if backend returns it
    if (response.data != null && response.data.containsKey('token')) {
      await SecureStorage.write('jwt_token', response.data['token']);
    }

    // Return response (message + username + role)
    return response.data;
  }
}
