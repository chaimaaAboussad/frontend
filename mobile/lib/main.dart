import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/company_provider.dart';
import 'screens/LoginScreen.dart';
import 'screens/home_screen.dart';
import 'screens/stocks_screen.dart';
import 'screens/etf_screen.dart';
import 'screens/watchlist_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CompanyProvider(),
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
        "/home": (context) => const HomeScreen(userRole: "client"), // default role
        "/stocks": (context) => const StocksScreen(),
        "/etf": (context) => const EtfScreen(),
        "/watchlist": (context) => const WatchlistScreen(),
      },
    );
  }
}
