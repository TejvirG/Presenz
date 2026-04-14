import 'package:flutter/material.dart';
import '../../widgets/gradient_appbar.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      {"label": "Average Attendance", "value": "88%"},
      {"label": "Top Performing Group", "value": "Group B"},
      {"label": "Lowest Attendance Subject", "value": "ML - 75%"}
    ];
    return Scaffold(
      appBar: const GradientAppBar(title: "Analytics Overview"),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: data.length,
        itemBuilder: (context, i) => Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(data[i]["label"] as String),
            trailing: Text(data[i]["value"] as String,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
