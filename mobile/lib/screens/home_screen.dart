import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/company_provider.dart';
import '../models/company.dart';
import 'company_details_screen.dart';
import 'AboutUsScreen.dart';
import 'LoginScreen.dart';
import 'package:mobile/screens/admin_dashboard.dart';


class HomeScreen extends StatefulWidget {
  final String userRole;

  const HomeScreen({super.key, required this.userRole});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedStandard = "AAOIFI";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<CompanyProvider>(context, listen: false);
      await provider.fetchCompanies();
    });
  }

  String _fmtNum(num? v, {int frac = 2}) {
    if (v == null) return "-";
    return v.toStringAsFixed(frac);
  }

  Widget _compliancePill(bool? compliant) {
    String label;
    Color bg;
    Color fg;

    if (compliant == null) {
      label = "Unknown";
      bg = Colors.grey.shade200;
      fg = Colors.grey.shade800;
    } else if (compliant) {
      label = "Compliant";
      bg = Colors.green.shade50;
      fg = Colors.green.shade700;
    } else {
      label = "Not Compliant";
      bg = Colors.red.shade50;
      fg = Colors.red.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: fg.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            compliant == null
                ? Icons.help_outline
                : (compliant ? Icons.verified : Icons.block),
            size: 16,
            color: fg,
          ),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ---------------- Admin role check ----------------
    if (widget.userRole.toLowerCase() == "admin") {
      return AdminDashboard();
      // show admin dashboard only
    }

    // ---------------- Normal user UI ----------------
    final provider = Provider.of<CompanyProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.green.shade600,
        title: Text(
          "Market (${widget.userRole.toUpperCase()})",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        actions: [
          DropdownButton<String>(
            value: selectedStandard,
            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            underline: const SizedBox(),
            dropdownColor: Colors.green.shade700,
            onChanged: (val) {
              if (val != null) setState(() => selectedStandard = val);
            },
            items: const [
              "AAOIFI",
              "S&P",
              "DJIMI",
              "Al Rajhi",
              "KLSE/Bursa Malaysia",
              "FTSE",
              "MSCI",
              "STOXX"
            ]
                .map((e) => DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ))
                .toList(),
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            tooltip: "Menu",
          ),
        ],
      ),
      endDrawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Container(
          color: Colors.green.shade50,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade700, Colors.greenAccent.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Text(
                  "Menu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.green),
                title: const Text("About Us",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AboutUsScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout",
                    style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
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
                "Not found",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
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

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              shadowColor: Colors.black.withOpacity(0.1),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CompanyDetailsScreen(
                        company: company,
                        userRole: widget.userRole,
                        standard: selectedStandard,
                      ),
                    ),
                  );
                },
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
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: CircularProgressIndicator(
                              strokeWidth: 2),
                        ),
                      );
                    },
                  ),
                )
                    : const Icon(Icons.business, color: Colors.green),
                title: Text(company.companyName ?? company.symbol,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sector: ${company.sector ?? "-"}",
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 13)),
                    if (company.price != null)
                      Text("Price: ${_fmtNum(company.price)}",
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 13)),
                  ],
                ),
                trailing: _compliancePill(company.shariahCompliant),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: widget.userRole.toLowerCase() == "admin"
          ? null
          : BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.green.shade50,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey.shade700,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), label: "Stocks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance), label: "ETF"),
          BottomNavigationBarItem(
              icon: Icon(Icons.star), label: "Watchlist"),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, "/stocks");
              break;
            case 2:
              Navigator.pushNamed(context, "/etf");
              break;
            case 3:
              Navigator.pushNamed(context, "/watchlist");
              break;
          }
        },
      ),
    );
  }
}
