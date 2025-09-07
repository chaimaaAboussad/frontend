import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/company.dart';

class CompanyProvider with ChangeNotifier {
  List<Company> _companies = [];
  bool loadingCompanies = false;

  List<Company> get companies => _companies;

  final String baseUrl = "http://10.0.2.2:8080/api";

  // Local list of company symbols to fetch
  final List<String> symbols = ["AAPL", "MSFT", "GOOGL"];

  /// Fetch data for all companies
  Future<void> fetchCompanies() async {
    loadingCompanies = true;
    notifyListeners();

    List<Company> results = [];

    try {
      for (String symbol in symbols) {
        final company = await fetchMarketData(symbol);
        if (company != null) {
          results.add(company);
          debugPrint("Added company: ${company.symbol}");
        } else {
          debugPrint("Company $symbol returned null");
        }
      }

      _companies = results;
    } catch (e) {
      debugPrint("Error fetching companies: $e");
      _companies = [];
    }

    loadingCompanies = false;
    notifyListeners();
  }

  /// Fetch a single company's market data
  Future<Company?> fetchMarketData(String symbol) async {
    try {
      final response =
      await http.get(Uri.parse("$baseUrl/market/combined?symbol=$symbol"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        debugPrint("Raw response for $symbol: $data");

        // Adjust parsing depending on whether profile is wrapped
        final profileData = data['profile'] ?? data;

        // Make sure all fields expected by your Company model are present
        final company = Company.fromJson(profileData);

        debugPrint("Parsed company: ${company.symbol}");
        return company;
      } else {
        debugPrint(
            "Failed to fetch $symbol: ${response.statusCode} ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      debugPrint("Exception fetching $symbol: $e");
      return null;
    }
  }
}
