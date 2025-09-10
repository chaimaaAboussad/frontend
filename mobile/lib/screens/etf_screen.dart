import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/company_provider.dart';
import '../models/company.dart';

class EtfScreen extends StatelessWidget {
  const EtfScreen({super.key});

  String _formatMarketCap(double? cap) {
    if (cap == null) return '-';
    if (cap >= 1e12) return "${(cap / 1e12).toStringAsFixed(2)}T";
    if (cap >= 1e9) return "${(cap / 1e9).toStringAsFixed(2)}B";
    if (cap >= 1e6) return "${(cap / 1e6).toStringAsFixed(2)}M";
    if (cap >= 1e3) return "${(cap / 1e3).toStringAsFixed(2)}K";
    return cap.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompanyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("ETF"),
        backgroundColor: Colors.green.shade600,
      ),
      body: provider.loadingCompanies
          ? const Center(child: CircularProgressIndicator())
          : provider.companies.isEmpty
          ? RefreshIndicator(
        onRefresh: () => provider.fetchCompanies(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            child: const Center(
              child: Text(
                "No ETFs found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      )
          : RefreshIndicator(
        onRefresh: () => provider.fetchCompanies(),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: provider.companies.length,
          itemBuilder: (context, index) {
            final Company company = provider.companies[index];
            final price = company.price ?? 0.0;
            final marketCap = _formatMarketCap(company.mktCap);

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shadowColor: Colors.black.withOpacity(0.1),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                onTap: () {
                  // Navigate to company details if needed
                },
                leading: company.logoUrl != null && company.logoUrl!.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    company.logoUrl!,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, color: Colors.grey),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        height: 40,
                        width: 40,
                        child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    },
                  ),
                )
                    : const Icon(Icons.pie_chart, color: Colors.green),
                title: Text(
                  company.companyName ?? company.symbol,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (company.sector != null)
                      Text(
                        company.sector!,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      "Price: \$${price.toStringAsFixed(2)}  Mkt Cap: $marketCap",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    provider.isInWatchlist(company)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: provider.isInWatchlist(company) ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    if (provider.isInWatchlist(company)) {
                      provider.removeFromWatchlist(company);
                    } else {
                      provider.addToWatchlist(company);
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
