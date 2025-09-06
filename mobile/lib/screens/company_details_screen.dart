import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/company_provider.dart';
import '../models/company_profile.dart';

class CompanyDetailsScreen extends StatelessWidget {
  final String symbol;
  final String userRole;
  final String name;
  final String standard;

  const CompanyDetailsScreen({
    super.key,
    required this.symbol,
    required this.userRole,
    required this.name,
    required this.standard,
  });

  String _fmtNum(num? v, {int frac = 2}) {
    if (v == null) return "-";
    return v.toStringAsFixed(frac);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompanyProvider>(context);
    final CompanyProfile? profile = provider.selectedProfile;

    return Scaffold(
      appBar: AppBar(
        title: Text("$name Profile"),
      ),
      body: provider.loadingDetails
          ? const Center(child: CircularProgressIndicator())
          : profile == null
          ? Center(
        child: Text(
          "No profile available for $symbol",
          style: const TextStyle(fontSize: 18),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              profile.companyName ?? symbol,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text("Price: ",
                    style: TextStyle(fontSize: 18)),
                Text("\$${_fmtNum(profile.price)}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("Market Cap: ",
                    style: TextStyle(fontSize: 18)),
                Text(
                  profile.mktCap != null
                      ? "\$${profile.mktCap}"
                      : "-",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("Sector: ",
                    style: TextStyle(fontSize: 18)),
                Text(profile.sector ?? "-",
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("Industry: ",
                    style: TextStyle(fontSize: 18)),
                Text(profile.industry ?? "-",
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                provider.clearSelectedCompany();
                Navigator.pop(context);
              },
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
