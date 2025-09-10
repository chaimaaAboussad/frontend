import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/company.dart';
import 'package:hive/hive.dart';
import '../models/hive/company_hive.dart';



class CompanyProvider with ChangeNotifier {
  bool loadingCompanies = false;
  List<Company> companies = [];



  final Box<CompanyHive> _watchlistBox = Hive.box<CompanyHive>('watchlistBox');


  // Convert Hive objects to Company for watchlist
  List<Company> get watchlist =>
      _watchlistBox.values.map((hive) => hive.toCompany()).toList();

  // Add a company to watchlist
  void addToWatchlist(Company company) {
    if (!_watchlistBox.values.any((hive) => hive.symbol == company.symbol)) {
      _watchlistBox.add(CompanyHive.fromCompany(company));
      notifyListeners();
    }
  }

  // Check if a company is in watchlist
  bool isInWatchlist(Company company) {
    return _watchlistBox.values.any((hive) => hive.symbol == company.symbol);
  }
  // Remove a company from watchlist
  void removeFromWatchlist(Company company) {
    final keyToRemove = _watchlistBox.keys.firstWhere(
          (key) => _watchlistBox.get(key)?.symbol == company.symbol,
      orElse: () => null,
    );
    if (keyToRemove != null) {
      _watchlistBox.delete(keyToRemove);
      notifyListeners();
    }
  }


  final String baseUrl = "http://10.0.2.2:8080/api/market/combined";

  // ⚠️ Replace localhost with your backend IP or domain if running on device

  // List of symbols to fetch
  final List<String> symbols = [
    "AAPL", // Apple
    "MSFT", // Microsoft
    "GOOGL", // Alphabet
    "AMZN", // Amazon
    "TSLA", // Tesla
    "META", // Meta
    "NVDA", // Nvidia
    "NFLX", // Netflix
    "INTC", // Intel
    "IBM", // IBM
    "ORCL", // Oracle
    "SAP", // SAP
    "SONY", // Sony
    "BABA", // Alibaba
    "T", // AT&T
    "V", // Visa
    "MA" // Mastercard
  ];


  Future<void> fetchCompanies() async {
    loadingCompanies = true;
    notifyListeners();

    List<Company> fetched = [];

    try {
      for (String symbol in symbols) {
        final response = await http.get(Uri.parse("$baseUrl?symbol=$symbol"));
        print("Fetching symbol: $symbol");
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);

          // ✅ Extract the "profile" object
          final profile = jsonData["profile"];
          print("Profile for $symbol: $profile");
          if (profile != null) {
            final company = Company.fromJson(profile); // create Company object
            print(
                "Added company: ${company.companyName}"); // <- debug print here
            fetched.add(company);
          }
        } else {
          debugPrint("Failed to fetch $symbol: ${response.statusCode}");
        }
      }

      companies = fetched;
    } catch (e) {
      debugPrint("Error fetching companies: $e");
    } finally {
      loadingCompanies = false;
      notifyListeners();
    }
  }

}