import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import 'edit_user_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.users.isEmpty
          ? const Center(child: Text("No users found"))
          : ListView.builder(
        itemCount: provider.users.length,
        itemBuilder: (context, index) {
          final User user = provider.users[index];
          return ListTile(
            title: Text(user.username),
            subtitle: Text(user.role), // non-null now
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditUserScreen(user: user),
                      ),
                    );
                    await provider.fetchUsers();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Confirm Delete"),
                        content: Text("Are you sure you want to delete ${user.username}?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await provider.deleteUser(user.id);
                      await provider.fetchUsers();
                    }
                  },
                ),
              ],
            ),
          );
        },
      )
    );
  }
}
