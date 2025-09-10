class Watchlist {
  final int id;
  final String name;

  Watchlist({required this.id, required this.name});

  factory Watchlist.fromJson(Map<String, dynamic> json) {
    return Watchlist(
      id: json['id'],
      name: json['name'],
    );
  }
}
