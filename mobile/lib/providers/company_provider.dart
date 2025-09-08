import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/company.dart';

class CompanyProvider with ChangeNotifier {
  bool loadingCompanies = false;
  List<Company> companies = [];

  final String baseUrl = "http://10.0.2.2:8080/api/market/combined";
  // ⚠️ Replace localhost with your backend IP or domain if running on device

  // List of symbols to fetch
  final List<String> symbols = ["AAPL", "MSFT", "GOOGL"];

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
            final company = Company.fromJson(profile);      // create Company object
            print("Added company: ${company.companyName}"); // <- debug print here
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
