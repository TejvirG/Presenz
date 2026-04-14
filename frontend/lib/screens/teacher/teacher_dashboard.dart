import 'package:flutter/material.dart';
import '../../widgets/gradient_appbar.dart';
import '../../services/mock_data_service.dart';
import 'take_attendance_page.dart';

class _SelectClassDialog extends StatelessWidget {
  final List<Map<String, dynamic>> classes;

  const _SelectClassDialog({required this.classes});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Class'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final classData = classes[index];
            return ListTile(
              title: Text(classData['name']),
              subtitle: Text('${classData['courseCode']} - ${classData['section']}'),
              onTap: () => Navigator.pop(context, classData),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  late Future<List<Map<String, dynamic>>> _classes;
  late Future<List<Map<String, dynamic>>> _stats;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _classes = Future.delayed(
        const Duration(seconds: 1),
        () => MockDataService.getTeacherClasses(),
      );
      _stats = Future.delayed(
        const Duration(seconds: 1),
        () => MockDataService.getTeacherStats(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: "Teacher Dashboard"),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Today's Classes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _classes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No classes found');
                }

                return Column(
                  children: snapshot.data!.map((classData) => Card(
                    child: ListTile(
                      title: Text(classData['name']),
                      subtitle: Text(
                        '${classData['courseCode']} | ${classData['time']}\n'
                        'Present: ${classData['presentToday']}/${classData['totalStudents']}',
                      ),
                      trailing: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Text(
                          '${((classData['presentToday'] / classData['totalStudents']) * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      isThreeLine: true,
                    ),
                  )).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              "Attendance Statistics",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _stats,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No statistics available');
                }

                return Column(
                  children: snapshot.data!.map((stat) => Card(
                    child: ListTile(
                      title: Text(
                        '${stat['date'].day}/${stat['date'].month}/${stat['date'].year}',
                      ),
                      trailing: Text(
                        '${stat['attendance']}%',
                        style: TextStyle(
                          color: stat['attendance'] >= 90
                              ? Colors.green
                              : stat['attendance'] >= 80
                                  ? Colors.orange
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
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
      floatingActionButton: FutureBuilder<List<Map<String, dynamic>>>(
        future: _classes,
        builder: (context, snapshot) {
          return FloatingActionButton.extended(
            onPressed: snapshot.hasData ? () async {
              final selectedClass = await showDialog<Map<String, dynamic>>(
                context: context,
                builder: (context) => _SelectClassDialog(classes: snapshot.data ?? []),
              );

              if (selectedClass != null && mounted) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TakeAttendancePage(classData: selectedClass),
                  ),
                );

                if (result == true) {
                  _loadData(); // Refresh the dashboard
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Attendance marked successfully')),
                  );
                }
              }
            } : null,
            icon: const Icon(Icons.check_circle),
            label: const Text('Take Attendance'),
          );
        },
      ),
    );
  }
}
