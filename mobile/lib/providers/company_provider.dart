import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/company.dart';

class CompanyProvider with ChangeNotifier {
  List<Company> _companies = [];
  bool loadingCompanies = false;

  List<Company> get companies => _companies;

  final String baseUrl = "http://10.0.2.2:8080/api";

  // Local list of company symbols to fetch data for
  final List<String> symbols = ["AAPL", "MSFT", "GOOGL"];

  /// Fetch data for all companies from local symbols list
  Future<void> fetchCompanies() async {
    loadingCompanies = true;
    notifyListeners();

    try {
      List<Company> results = [];

      // Fetch combined data for each symbol in parallel
      await Future.wait(symbols.map((symbol) async {
        final company = await fetchMarketData(symbol);
        if (company != null) {
          results.add(company);
        }
      }));

      _companies = results;
    } catch (e) {
      debugPrint("Error fetching companies: $e");
      _companies = [];
    }

    loadingCompanies = false;
    notifyListeners();
  }

  /// Fetch market data for a single company symbol from /market/combined endpoint
  Future<Company?> fetchMarketData(String symbol) async {
    try {
      final response =
      await http.get(Uri.parse("$baseUrl/market/combined?symbol=$symbol"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Parse JSON into your Company model; update this to match your JSON structure
        return Company.fromJson(data['profile'] ?? data); // adjust if profile is wrapped
      } else {
        debugPrint(
            "Failed to fetch market data for $symbol: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching market data for $symbol: $e");
      return null;
    }
  }
}
