import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/watchlist.dart';
import '../models/hive/watchlist_hive.dart';
import '../models/company.dart';
import '../models/hive/company_hive.dart';

class WatchlistApi {
  static const baseUrl = 'http://localhost:8080/api/watchlists';

  // Hive boxes
  static const String watchlistBoxName = 'watchlists';
  static const String companiesBoxName = 'watchlist_companies';

  /// Fetch all watchlists for the logged-in user
  static Future<List<Watchlist>> fetchMyWatchlists({String? userId}) async {
    final box = await Hive.openBox(watchlistBoxName);

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final watchlists = data.map((json) => Watchlist.fromJson(json)).toList();

        // Cache using Hive
        if (userId != null) {
          final hiveList = watchlists.map((w) => WatchlistHive.fromWatchlist(w)).toList();
          await box.put(userId, hiveList);
        }

        return watchlists;
      } else {
        throw Exception('Failed to load watchlists: ${response.statusCode}');
      }
    } catch (e) {
      // Return cached watchlists if available
      if (userId != null && box.containsKey(userId)) {
        final cachedList = box.get(userId) as List<WatchlistHive>;
        return cachedList.map((h) => h.toWatchlist()).toList();
      }
      rethrow;
    }
  }

  /// Fetch companies in a watchlist
  static Future<List<Company>> fetchWatchlistCompanies(int watchlistId, {String? userId}) async {
    final box = await Hive.openBox(companiesBoxName);
    final cacheKey = '${userId ?? 'guest'}_$watchlistId';

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$watchlistId/companies'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final companies = jsonList.map((json) => Company.fromJson(json)).toList();

        // Cache companies in Hive
        final hiveList = companies.map((c) => CompanyHive.fromCompany(c)).toList();
        await box.put(cacheKey, hiveList);

        return companies;
      } else {
        throw Exception('Failed to fetch companies: ${response.statusCode}');
      }
    } catch (e) {
      // Return cached companies if available
      if (box.containsKey(cacheKey)) {
        final cachedList = box.get(cacheKey) as List<CompanyHive>;
        return cachedList.map((ch) => ch.toCompany()).toList();
      }
      rethrow;
    }
  }

  /// Create a new watchlist
  static Future<void> createWatchlist(String name, {String? userId}) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create watchlist: ${response.statusCode} ${response.body}');
    }

    // If userId is provided, refresh the cached watchlists
    if (userId != null) {
      final box = await Hive.openBox(watchlistBoxName);
      // Re-fetch watchlists from server and update cache
      final List<Watchlist> freshWatchlists = await fetchMyWatchlists(userId: userId);
      final hiveList = freshWatchlists.map((w) => WatchlistHive.fromWatchlist(w)).toList();
      await box.put(userId, hiveList);
    }
  }


  /// Delete a watchlist
  static Future<void> deleteWatchlist(int id, {String? userId}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete watchlist: ${response.statusCode} ${response.body}');
    }

    // Remove cached watchlists and companies
    if (userId != null) {
      final watchlistBox = await Hive.openBox(watchlistBoxName);
      watchlistBox.delete(userId);

      final companiesBox = await Hive.openBox(companiesBoxName);
      companiesBox.keys
          .where((key) => key.toString().startsWith(userId))
          .forEach(companiesBox.delete);
    }
  }
}
