import 'package:flutter/material.dart';
import '../../widgets/gradient_appbar.dart';
import '../../models/report_model.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  late Future<ReportModel> _report;

  Future<ReportModel> _fetch() async {
    final token = await AuthService().getToken();
    final api = ApiService(token: token);
    final data = await api.get("admin/reports");
    return ReportModel.fromJson(data);
  }

  @override
  void initState() {
    super.initState();
    _report = _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: "Reports"),
      body: FutureBuilder<ReportModel>(
        future: _report,
        builder: (context, s) {
          if (s.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) {
            return Center(child: Text("Error: ${s.error}"));
          }
          final r = s.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _stat("Total Users", r.totalUsers),
              _stat("Total Classes", r.totalClasses),
              _stat("Total Attendance Records", r.totalAttendance),
            ],
          );
        },
      ),
    );
  }

  Widget _stat(String label, int val) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(label),
        trailing: Text(val.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}
