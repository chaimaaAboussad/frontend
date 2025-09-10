import 'package:flutter/material.dart';
import '../core/watchlist_api.dart';
import '../models/company.dart';
import 'package:hive/hive.dart';
import '../models/hive/company_hive.dart';

class WatchlistDetailScreen extends StatefulWidget {
  final int watchlistId;
  final String watchlistName;

  const WatchlistDetailScreen({
    super.key,
    required this.watchlistId,
    required this.watchlistName,
  });

  @override
  _WatchlistDetailScreenState createState() => _WatchlistDetailScreenState();
}

class _WatchlistDetailScreenState extends State<WatchlistDetailScreen> {
  List<Company>? _companies;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    // Load cached companies first
    final box = await Hive.openBox('watchlist_companies');
    final cacheKey = 'watchlist_${widget.watchlistId}';
    if (box.containsKey(cacheKey)) {
      final cachedList = box.get(cacheKey) as List<CompanyHive>;
      _companies = cachedList.map((ch) => ch.toCompany()).toList();
      setState(() {}); // show cached immediately
    }

    // Fetch fresh companies from API
    try {
      final freshCompanies =
      await WatchlistApi.fetchWatchlistCompanies(widget.watchlistId);
      setState(() {
        _companies = freshCompanies;
      });

      // Update cache
      final hiveList =
      freshCompanies.map((c) => CompanyHive.fromCompany(c)).toList();
      await box.put(cacheKey, hiveList);
    } catch (e) {
      if (_companies == null) {
        setState(() {
          _error = e.toString();
        });
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _refresh() async {
    await _loadCompanies();
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.watchlistName),
        backgroundColor: Colors.green.shade600,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _loading && _companies == null
            ? const Center(child: CircularProgressIndicator())
            : _error != null && (_companies == null || _companies!.isEmpty)
            ? Center(
          child: Text(
            'Error fetching companies:\n$_error',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        )
            : _companies == null || _companies!.isEmpty
            ? SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            child: const Center(
              child: Text(
                "No companies in this watchlist",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            ),
          ),
        )
            : ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _companies!.length,
          itemBuilder: (context, index) {
            final company = _companies![index];
            final price = company.price ?? 0.0;
            final marketCap = _formatMarketCap(company.mktCap);

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 16),
                leading: company.logoUrl != null &&
                    company.logoUrl!.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    company.logoUrl!,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                    const Icon(Icons.broken_image,
                        color: Colors.grey),
                    loadingBuilder:
                        (context, child, loadingProgress) {
                      if (loadingProgress == null)
                        return child;
                      return const SizedBox(
                        height: 40,
                        width: 40,
                        child: Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 2)),
                      );
                    },
                  ),
                )
                    : const Icon(Icons.star, color: Colors.green),
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
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      "Price: \$${price.toStringAsFixed(2)}  Mkt Cap: $marketCap",
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                onTap: () {
                  // Optional: Navigate to company details
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
