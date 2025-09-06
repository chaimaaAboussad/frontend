import 'package:flutter/material.dart';
import '../screens/company_details_screen.dart';
import 'package:provider/provider.dart';
import '../providers/company_provider.dart';

class ClientDashboard extends StatelessWidget {
  const ClientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompanyProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Client Dashboard")),
      body: ListView.builder(
        itemCount: provider.companies.length,
        itemBuilder: (context, index) {
          final company = provider.companies[index];
          return ListTile(
            title: Text(company.name),
            subtitle: Text(company.ticker),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CompanyDetailsScreen(
                    companyId: company.id,
                    name: company.name,
                    userRole: "client",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
