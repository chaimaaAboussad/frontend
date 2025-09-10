import 'package:hive/hive.dart';
import '../watchlist.dart';

part 'watchlist_hive.g.dart';

@HiveType(typeId: 3) // Make sure this typeId is unique across your app
class WatchlistHive {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  WatchlistHive({
    required this.id,
    required this.name,
  });

  /// Convert from Watchlist model to WatchlistHive for caching
  factory WatchlistHive.fromWatchlist(Watchlist watchlist) {
    return WatchlistHive(
      id: watchlist.id,
      name: watchlist.name,
    );
  }

  /// Convert back from WatchlistHive to Watchlist model
  Watchlist toWatchlist() {
    return Watchlist(
      id: id,
      name: name,
    );
  }

  /// Optional: convert to JSON if needed
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  /// Optional: create from JSON if needed
  factory WatchlistHive.fromJson(Map<String, dynamic> json) {
    return WatchlistHive(
      id: json['id'],
      name: json['name'],
    );
  }
}
