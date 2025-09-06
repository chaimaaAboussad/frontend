class User {
  final int id;
  final String username;
  final String role; // "admin" or "client"

  User({
    required this.id,
    required this.username,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] ?? '',
      role: json['role'] ?? 'client',
    );
  }
}
