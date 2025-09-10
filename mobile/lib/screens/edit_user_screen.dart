import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class EditUserScreen extends StatefulWidget {
  final User user; // Only editing existing users

  const EditUserScreen({super.key, required this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  String role = "client";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    role = widget.user.role;
  }

  Future<void> _updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final provider = Provider.of<UserProvider>(context, listen: false);
    try {
      final updatedUser = User(
        id: widget.user.id,
        username: _usernameController.text.trim(),
        role: role,
      );
      await provider.updateUser(updatedUser);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
                validator: (v) =>
                v == null || v.isEmpty ? "Username required" : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: role,
                items: const [
                  DropdownMenuItem(value: "admin", child: Text("Admin")),
                  DropdownMenuItem(value: "client", child: Text("Client")),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => role = val);
                },
                decoration: const InputDecoration(labelText: "Role"),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _updateUser,
                  child: isLoading
                      ? const CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2)
                      : const Text("Update"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
