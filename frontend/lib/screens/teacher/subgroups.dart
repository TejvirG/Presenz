import 'package:flutter/material.dart';
import '../../widgets/gradient_appbar.dart';

class SubGroupsPage extends StatelessWidget {
  const SubGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = [
      {"name": "Group A", "attendance": 87},
      {"name": "Group B", "attendance": 93},
      {"name": "Group C", "attendance": 85},
    ];

    return Scaffold(
      appBar: const GradientAppBar(title: "Sub Groups"),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: groups.map((g) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(g["name"] as String),
              subtitle: Text("Attendance: ${g["attendance"] as int}%"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          );
        }).toList(),
      ),
    );
  }
}
