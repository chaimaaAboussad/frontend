import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "This app helps you check Shariah compliance for companies "
              "and manage your watchlist.\n\n"
              "Developed by SAADtheMAN and chocho ;) 🚀",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
