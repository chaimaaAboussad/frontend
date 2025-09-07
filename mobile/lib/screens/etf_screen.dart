import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/company_provider.dart';
import '../models/company.dart';

class EtfScreen extends StatelessWidget {
  const EtfScreen({super.key});

  Color _changeColor(num? v) {
    if (v == null) return Colors.grey;
    return v >= 0 ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompanyProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("ETF")),
      body: provider.loadingCompanies
          ? const Center(child: CircularProgressIndicator())
          : provider.companies.isEmpty
          ? RefreshIndicator(
        onRefresh: () => provider.fetchCompanies(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Center(child: Text("No ETFs found")),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: () => provider.fetchCompanies(),
        child: ListView.builder(
          itemCount: provider.companies.length,
          itemBuilder: (context, index) {
            final Company company = provider.companies[index];
            final price = company.price;
            final change = 0.0;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(company.companyName ?? company.symbol),
                subtitle: Row(
                  children: [
                    Text("Price: ${price?.toStringAsFixed(2) ?? '-'}  "),
                    Text(
                      "Change: ${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%",
                      style: TextStyle(color: _changeColor(change)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
