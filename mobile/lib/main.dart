import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'providers/company_provider.dart';
import 'providers/user_provider.dart';
import 'screens/LoginScreen.dart';
import 'screens/home_screen.dart';
import 'screens/stocks_screen.dart';
import 'screens/etf_screen.dart';
import 'screens/watchlist_screen.dart';
import 'package:mobile/screens/admin_dashboard.dart';
import 'models/hive/company_hive.dart'; // import your Hive adapter

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register the Hive adapter
  Hive.registerAdapter(CompanyHiveAdapter());

  // Open the box for watchlist
  await Hive.openBox<CompanyHive>('watchlistBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()), // <-- Add this
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Islamic Financial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginScreen(),
      routes: {
        "/home": (context) => const HomeScreen(userRole: "client"),
        "/stocks": (context) => const StocksScreen(),
        "/etf": (context) => const EtfScreen(),
        "/watchlist": (context) => const WatchlistScreen(),
        "/admin": (context) => AdminDashboard(),

      },
    );
  }
}
