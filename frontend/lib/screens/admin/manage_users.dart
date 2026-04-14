import 'package:flutter/material.dart';
import '../../widgets/gradient_appbar.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      {"name": "Alex Johnson", "role": "Teacher"},
      {"name": "Priya Patel", "role": "Student"},
      {"name": "Karan Singh", "role": "Student"}
    ];

    return Scaffold(
      appBar: const GradientAppBar(title: "Manage Users"),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: users.map((u) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text((u["name"] as String)[0], style: const TextStyle(color: Colors.white)),
              ),
              title: Text(u["name"] as String),
              subtitle: Text(u["role"] as String),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {},
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
