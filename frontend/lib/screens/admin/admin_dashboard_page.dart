import 'package:flutter/material.dart';
import '../../widgets/gradient_appbar.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late Future<List<Map<String, dynamic>>> _departmentStats;
  late Future<List<Map<String, dynamic>>> _recentActivity;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _departmentStats = Future.delayed(
        const Duration(seconds: 1),
        () => [
          {
            'name': 'Computer Science & Engineering',
            'totalStudents': 240,
            'totalTeachers': 18,
            'avgAttendance': 92,
            'branches': ['CSE', 'AI/ML', 'Cybersecurity'],
          },
          {
            'name': 'Electronics & Communication',
            'totalStudents': 180,
            'totalTeachers': 15,
            'avgAttendance': 88,
            'branches': ['ECE', 'IoT', 'VLSI'],
          },
          {
            'name': 'Information Technology',
            'totalStudents': 120,
            'totalTeachers': 12,
            'avgAttendance': 90,
            'branches': ['IT', 'Data Science'],
          },
          {
            'name': 'Mechanical Engineering',
            'totalStudents': 160,
            'totalTeachers': 14,
            'avgAttendance': 85,
            'branches': ['Mechanical', 'Robotics'],
          },
        ],
      );

      _recentActivity = Future.delayed(
        const Duration(seconds: 1),
        () => [
          {
            'type': 'New Registration',
            'description': 'New batch of 60 students registered in CSE (2025-29)',
            'time': DateTime.now().subtract(const Duration(minutes: 30)),
            'severity': 'info',
          },
          {
            'type': 'Attendance Alert',
            'description': 'Low attendance in CS201: Data Structures (Section CSE-A)',
            'time': DateTime.now().subtract(const Duration(hours: 2)),
            'severity': 'warning',
          },
          {
            'type': 'Infrastructure',
            'description': 'New biometric devices installed in Block C',
            'time': DateTime.now().subtract(const Duration(hours: 3)),
            'severity': 'info',
          },
          {
            'type': 'System Update',
            'description': 'Face recognition system updated to v2.1',
            'time': DateTime.now().subtract(const Duration(hours: 4)),
            'severity': 'info',
          },
          {
            'type': 'Holiday Notice',
            'description': 'College closed on 14th Nov for Diwali celebration',
            'time': DateTime.now().subtract(const Duration(hours: 5)),
            'severity': 'info',
          },
        ],
      );
    });
  }

  String _getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: "Admin Dashboard"),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Department Overview",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _departmentStats,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No data available');
                }

                return Column(
                  children: snapshot.data!.map((dept) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dept['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _StatBox(
                                label: 'Students',
                                value: dept['totalStudents'].toString(),
                                icon: Icons.people,
                              ),
                              _StatBox(
                                label: 'Teachers',
                                value: dept['totalTeachers'].toString(),
                                icon: Icons.school,
                              ),
                              _StatBox(
                                label: 'Attendance',
                                value: '${dept['avgAttendance']}%',
                                icon: Icons.checklist,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              "Recent Activity",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _recentActivity,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No recent activity');
                }

                return Column(
                  children: snapshot.data!.map((activity) => Card(
                    child: ListTile(
                      leading: Icon(
                        activity['type'] == 'New Registration'
                            ? Icons.person_add
                            : activity['type'] == 'Attendance Alert'
                                ? Icons.warning
                                : Icons.system_update,
                        color: activity['type'] == 'Attendance Alert'
                            ? Colors.orange
                            : null,
                      ),
                      title: Text(activity['type']),
                      subtitle: Text(activity['description']),
                      trailing: Text(
                        _getTimeAgo(activity['time']),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}