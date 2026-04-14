import 'package:flutter/material.dart';
import '../../widgets/gradient_appbar.dart';
import '../teacher/reports.dart';
import 'analytics.dart';
import 'manage_users.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {"title": "Reports", "page": const ReportsPage()},
      {"title": "Analytics", "page": const AnalyticsPage()},
      {"title": "Manage Users", "page": const ManageUsersPage()},
    ];

    return Scaffold(
      appBar: const GradientAppBar(title: "Admin Dashboard"),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final item = items[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => item["page"] as Widget),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF00BFA5)]),
                borderRadius: BorderRadius.circular(16),
              ),
        child: Center(
          child: Text(item["title"] as String,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold))),
            ),
          );
        },
      ),
    );
  }
}
