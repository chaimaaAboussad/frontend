import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/company.dart';
import '../models/company_profile.dart';

class CompanyProvider with ChangeNotifier {
  final String baseUrl = "http://10.0.2.2:8080/api"; // Emulator fix

  List<Company> _companies = [];
  bool _loadingCompanies = false;

  CompanyProfile? _selectedProfile;
  bool _loadingDetails = false;

  List<Company> get companies => _companies;
  bool get loadingCompanies => _loadingCompanies;

  CompanyProfile? get selectedProfile => _selectedProfile;
  bool get loadingDetails => _loadingDetails;

  // Fetch company list
  Future<void> fetchCompanies() async {
    _loadingCompanies = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("$baseUrl/companyProfiles/all"));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _companies = data.map((json) => Company.fromJson(json)).toList();
      } else {
        _companies = [];
      }
    } catch (e) {
      _companies = [];
    } finally {
      _loadingCompanies = false;
      notifyListeners();
    }
  }

  // Fetch company profile
  Future<void> fetchCompanyDetails(String symbol) async {
    _loadingDetails = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("$baseUrl/companyProfiles/$symbol?live=true"));
      if (response.statusCode == 200) {
        _selectedProfile = CompanyProfile.fromJson(json.decode(response.body));
      } else {
        _selectedProfile = null;
      }
    } catch (e) {
      _selectedProfile = null;
    } finally {
      _loadingDetails = false;
      notifyListeners();
    }
  }

  void clearSelectedCompany() {
    _selectedProfile = null;
    notifyListeners();
  }
}
