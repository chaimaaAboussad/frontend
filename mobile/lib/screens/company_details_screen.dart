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
    return v.toStringAsFixed(frac);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(company.companyName ?? company.symbol)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (company.logoUrl != null)
              Center(
                child: Image.network(
                  company.logoUrl!,
                  height: 100,
                ),
              ),
            const SizedBox(height: 16),
            Text("Symbol: ${company.symbol}", style: const TextStyle(fontSize: 16)),
            Text("Industry: ${company.industry ?? "-"}", style: const TextStyle(fontSize: 16)),
            Text("Sector: ${company.sector ?? "-"}", style: const TextStyle(fontSize: 16)),
            Text("Website: ${company.website ?? "-"}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text("Market Data", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Text("Price: ${_fmtNum(company.price)}"),
            Text("Market Cap: ${_fmtNum(company.mktCap)}"),
            Text("Enterprise Value: ${_fmtNum(company.enterpriseValue)}"),
            Text("Shares Outstanding: ${_fmtNum(company.sharesOutstanding)}"),
            Text("Total Assets: ${_fmtNum(company.totalAssets)}"),
            const SizedBox(height: 16),
            Text("Financials", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Text("Total Revenue: ${_fmtNum(company.totalRevenue)}"),
            Text("Total Debt: ${_fmtNum(company.totalDebt)}"),
            Text("Cash: ${_fmtNum(company.cash)}"),
            Text("Short-Term Investments: ${_fmtNum(company.shortTermInvestments)}"),
            Text("Accounts Receivable: ${_fmtNum(company.accountsReceivable)}"),
            Text("Interest Income: ${_fmtNum(company.interestIncome)}"),
            const SizedBox(height: 16),
            Text("Shariah Compliance", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Text(
              "Compliant: ${company.shariahCompliant == null ? 'Unknown' : company.shariahCompliant! ? 'Yes' : 'No'}",
            ),
          ],
        ),
      ),
    );
  }
}
