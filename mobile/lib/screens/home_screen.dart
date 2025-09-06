import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/company_provider.dart';
import '../models/company.dart';
import 'company_details_screen.dart';
import 'AboutUsScreen.dart';
import 'LoginScreen.dart';

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

      // Optionally select the first company automatically
      if (provider.companies.isNotEmpty) {
        final firstCompany = provider.companies.first;
        await provider.fetchCompanyDetails(firstCompany.symbol);
      }
    });
  }

  String _fmtNum(num? v, {int frac = 2}) {
    if (v == null) return "-";
    return v.toStringAsFixed(frac);
  }

  String _fmtChange(num? v) {
    if (v == null) return "-";
    final sign = v >= 0 ? "+" : "";
    return "$sign${_fmtNum(v)}%";
  }

  Color _changeColor(num? v) {
    if (v == null) return Colors.grey;
    return v >= 0 ? Colors.green : Colors.red;
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            compliant == null ? Icons.help_outline : (compliant ? Icons.verified : Icons.block),
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
    final provider = Provider.of<CompanyProvider>(context);
    final isAdmin = widget.userRole.toLowerCase() == "admin";

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("ETF & Stock Screener (${widget.userRole.toUpperCase()})"),
        actions: [
          DropdownButton<String>(
            value: selectedStandard,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            underline: const SizedBox(),
            dropdownColor: Colors.blueGrey,
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
            ].map((e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e, style: TextStyle(color: Colors.white)),
            )).toList(),
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
          color: Colors.blue.shade50,
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  "Menu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.blue),
                title: const Text("About Us", style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.w500)),
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
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Center(child: Text("No companies found")),
          ],
        ),
      )
      import 'package:flutter/material.dart';
    import 'package:provider/provider.dart';
    import '../providers/company_provider.dart';
    import '../models/company.dart';
    import 'company_details_screen.dart';
    import 'AboutUsScreen.dart';
    import 'LoginScreen.dart';

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

    // Optionally select the first company automatically
    if (provider.companies.isNotEmpty) {
    final firstCompany = provider.companies.first;
    provider.fetchCompanyDetails(firstCompany.symbol);
    }
    });
    }

    String _fmtNum(num? v, {int frac = 2}) {
    if (v == null) return "-";
    return v.toStringAsFixed(frac);
    }

    String _fmtChange(num? v) {
    if (v == null) return "-";
    final sign = v >= 0 ? "+" : "";
    return "$sign${_fmtNum(v)}%";
    }

    Color _changeColor(num? v) {
    if (v == null) return Colors.grey;
    return v >= 0 ? Colors.green : Colors.red;
    }

    @override
    Widget build(BuildContext context) {
    final provider = Provider.of<CompanyProvider>(context);
    final isAdmin = widget.userRole.toLowerCase() == "admin";

    return Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
    title: Text("ETF & Stock Screener (${widget.userRole.toUpperCase()})"),
    actions: [
    DropdownButton<String>(
    value: selectedStandard,
    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
    underline: const SizedBox(),
    dropdownColor: Colors.blueGrey,
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
    ].map((e) => DropdownMenuItem<String>(
    value: e,
    child: Text(e, style: TextStyle(color: Colors.white)),
    )).toList(),
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
    color: Colors.blue.shade50,
    child: ListView(
    children: [
    const DrawerHeader(
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [Colors.blue, Colors.lightBlueAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    ),
    child: Text(
    "Menu",
    style: TextStyle(
    color: Colors.white,
    fontSize: 26,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ListTile(
    leading: const Icon(Icons.info, color: Colors.blue),
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
    child: ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    children: const [
    SizedBox(height: 120),
    Center(child: Text("No companies found")),
    ],
    ),
    )
        : RefreshIndicator(
    onRefresh: () => provider.fetchCompanies(),
    child: ListView.builder(
    itemCount: provider.companies.length,
    itemBuilder: (context, index) {
    final Company company = provider.companies[index];

    final price = company.price ?? company.currentPrice;
    final change = company.change ?? 0.0;
    final compliant = company.shariahCompliant;

    return Card(
    margin: const EdgeInsets.symmetric(
    horizontal: 16, vertical: 8),
    child: ListTile(
    onTap: () async {
    await provider.fetchCompanyDetails(company.symbol);
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (_) => CompanyDetailsScreen(
    symbol: company.symbol,
    userRole: widget.userRole,
    name: company.name ?? "Unknown",
    standard: selectedStandard,
    ),
    ),
    );
    },
    title: Text(company.name ?? company.symbol),
    subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text("Sector: ${company.sector ?? "-"}"),
    if (price != null)
    Row(
    children: [
    Text("Price: ${_fmtNum(price)}  "),
    Text(
    "Change: ${_fmtChange(change)}",
    style: TextStyle(
    color: _changeColor(change)),
    ),
    ],
    ),
    ],
    ),
    trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
    Icon(
    compliant == null
    ? Icons.help_outline
        : (compliant
    ? Icons.check_circle
        : Icons.cancel),
    color: compliant == null
    ? Colors.grey
        : (compliant ? Colors.green : Colors.red),
    ),
    const SizedBox(width: 6),
    Text(
    compliant == null
    ? "Unknown"
        : (compliant ? "Compliant" : "Not Compliant"),
    style: TextStyle(
    color: compliant == null
    ? Colors.grey
        : (compliant
    ? Colors.green
        : Colors.red),
    fontWeight: FontWeight.w600,
    ),
    ),
    ],
    ),
    ),
    );
    },
    ),
    ),
    bottomNavigationBar: BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Stocks"),
    BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: "ETF"),
    BottomNavigationBarItem(icon: Icon(Icons.star), label: "Watchlist"),
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

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Stocks"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: "ETF"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Watchlist"),
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
