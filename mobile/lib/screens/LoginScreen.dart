import 'package:flutter/material.dart';
import '../core/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController(); // for signup
  final AuthService _authService = AuthService();

  bool isSignUp = false; // toggle login/signup
  bool isLoading = false;
  bool _obscurePassword = true; // password visibility

  // ---------------- LOGIN ----------------
  Future<void> _login() async {
    setState(() => isLoading = true);
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showSnack("Please fill all fields");
      setState(() => isLoading = false);
      return;
    }

    try {
      final userData = await _authService.login(username, password);

      final userRole = (userData['role'] ?? 'client').toString().toLowerCase();
      // default to "client" if role not set

      _showSnack("Welcome $username!");

      // Navigate to HomeScreen and pass userRole
      Navigator.pushReplacementNamed(
        context,
        "/home",
        arguments: {"userRole": userRole},
      );

    } catch (e) {
      _showSnack("This account doesn’t exist.");

      // Switch to signup form after a delay
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => isSignUp = true);
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ---------------- SIGNUP ----------------
  Future<void> _signup() async {
    setState(() => isLoading = true);
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final email = _emailController.text.trim();

    if (username.isEmpty || password.isEmpty || email.isEmpty) {
      _showSnack("Please fill all fields");
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await _authService.signup(username, email, password);

      _showSnack(response['message'] ?? "Signup successful");

      setState(() {
        isSignUp = false;
        _passwordController.clear();
        _emailController.clear();
        _usernameController.text = username; // pre-fill for login
      });
    } catch (e) {
      _showSnack("Signup failed: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 6,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    isSignUp ? "Sign Up" : "Login",
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Username
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Email (only for signup)
                  if (isSignUp)
                    Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),

                  // Password
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Toggle login/signup
                  if (!isSignUp)
                    TextButton(
                      onPressed: () => setState(() => isSignUp = true),
                      child: const Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),

                  // Back to login button for signup
                  if (isSignUp)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isSignUp = false;
                          _passwordController.clear();
                          _emailController.clear();
                        });
                      },
                      child: const Text(
                        "Back to Login",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),

                  const SizedBox(height: 10),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: isLoading
                          ? null
                          : (isSignUp ? _signup : _login),
                      child: isLoading
                          ? const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2)
                          : Text(isSignUp ? "Sign Up" : "Login",
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
