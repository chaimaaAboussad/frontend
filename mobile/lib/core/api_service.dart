import 'package:dio/dio.dart';
import 'constants.dart';
import 'secure_storage.dart';

class ApiService {
  final Dio dio;

  ApiService()
      : dio = Dio(BaseOptions(
    baseUrl: BASE_URL,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {"Content-Type": "application/json"},
  )) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage.read('jwt_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioError e, handler) {
          print("API Error: ${e.response?.statusCode} - ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  // Generic HTTP methods
  Future<Response> get(String path, {Map<String, dynamic>? query}) async =>
      await dio.get(path, queryParameters: query);

  Future<Response> post(String path, dynamic data) async =>
      await dio.post(path, data: data);

  Future<Response> put(String endpoint, {Map<String, dynamic>? data}) async {
    return dio.put(endpoint, data: data);
  }

  Future<Response> delete(String path) async => await dio.delete(path);

  // ✅ Login method
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await post('/api/users/login', {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        // Backend returns { "username": "...", "role": "..." }
        return response.data as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        throw Exception('Invalid username or password');
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } on DioError catch (e) {
      // Handle 400/401 errors returned by backend
      final data = e.response?.data;
      if (data != null) {
        throw Exception(data.toString());
      } else {
        throw Exception('Login error: ${e.message}');
      }
    }
  }
}
