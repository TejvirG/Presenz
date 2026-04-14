import 'package:flutter/material.dart';
import '../widgets/gradient_appbar.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<Map<String, dynamic>>> _notes;

  Future<List<Map<String, dynamic>>> _fetch() async {
    final token = await AuthService().getToken();
    final api = ApiService(token: token);
    final res = await api.get("notifications");
    return (res as List).cast<Map<String, dynamic>>();
  }

  @override
  void initState() {
    super.initState();
    _notes = _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: "Notifications"),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notes,
        builder: (context, s) {
          if (s.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) return Center(child: Text("Error: ${s.error}"));
          final data = s.data!;
          if (data.isEmpty) return const Center(child: Text("No notifications"));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, i) => Card(
              child: ListTile(
                title: Text(data[i]["message"]),
                subtitle: Text(
                  data[i]["createdAt"] ?? "",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
