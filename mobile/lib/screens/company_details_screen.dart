import 'package:flutter/material.dart';
import '../models/company.dart';

class CompanyDetailsScreen extends StatelessWidget {
  final Company company;
  final String userRole;
  final String standard;

  const CompanyDetailsScreen({
    super.key,
    required this.company,
    required this.userRole,
    required this.standard,
  });

  String _fmtNum(num? v, {int frac = 2}) {
    if (v == null) return "-";
    if (v >= 1e12) return "${(v / 1e12).toStringAsFixed(frac)}T";
    if (v >= 1e9) return "${(v / 1e9).toStringAsFixed(frac)}B";
    if (v >= 1e6) return "${(v / 1e6).toStringAsFixed(frac)}M";
    if (v >= 1e3) return "${(v / 1e3).toStringAsFixed(frac)}K";
    return v.toStringAsFixed(frac);
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade800,
        ),
      ),
    );
  }

  Widget _dataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shadowColor: Colors.green.shade200,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(company.companyName ?? company.symbol),
        backgroundColor: Colors.green.shade600,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            Center(
              child: company.logoUrl != null && company.logoUrl!.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  company.logoUrl!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, color: Colors.grey, size: 60),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.green,
                        ),
                      ),
                    );
                  },
                ),
              )
                  : const Icon(Icons.business, color: Colors.green, size: 60),
            ),
            const SizedBox(height: 16),

            // General Information
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("General Information"),
                  _dataRow("Symbol:", company.symbol),
                  _dataRow("Industry:", company.industry ?? "-"),
                  _dataRow("Sector:", company.sector ?? "-"),
                  _dataRow("Website:", company.website ?? "-"),
                ],
              ),
            ),

            // Market Data
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Market Data"),
                  _dataRow("Price:", _fmtNum(company.price)),
                  _dataRow("Market Cap:", _fmtNum(company.mktCap)),
                  _dataRow("Enterprise Value:", _fmtNum(company.enterpriseValue)),
                  _dataRow("Shares Outstanding:", _fmtNum(company.sharesOutstanding)),
                  _dataRow("Total Assets:", _fmtNum(company.totalAssets)),
                ],
              ),
            ),

            // Financials
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Financials"),
                  _dataRow("Total Revenue:", _fmtNum(company.totalRevenue)),
                  _dataRow("Total Debt:", _fmtNum(company.totalDebt)),
                  _dataRow("Cash:", _fmtNum(company.cash)),
                  _dataRow("Short-Term Investments:", _fmtNum(company.shortTermInvestments)),
                  _dataRow("Accounts Receivable:", _fmtNum(company.accountsReceivable)),
                  _dataRow("Interest Income:", _fmtNum(company.interestIncome)),
                ],
              ),
            ),

            // Shariah Compliance
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Shariah Compliance"),
                  _dataRow(
                    "Compliant:",
                    company.shariahCompliant == null
                        ? "Unknown"
                        : (company.shariahCompliant! ? "Yes" : "No"),
                  ),
                  _dataRow("User Role:", userRole),
                  _dataRow("Standard:", standard),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
