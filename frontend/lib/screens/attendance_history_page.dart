import 'package:flutter/material.dart';
import '../models/attendance_model.dart';
import '../services/attendance_service.dart';
import '../services/auth_service.dart';

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({super.key});

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  late Future<List<AttendanceModel>> _attendanceHistory;
  

  @override
  void initState() {
    super.initState();
    // Initialize async future for attendance history
    _attendanceHistory = AuthService()
        .getToken()
        .then((token) => AttendanceService(token: token).getAttendanceHistory());
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
      ),
      body: FutureBuilder<List<AttendanceModel>>(
        future: _attendanceHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No attendance records found.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final record = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ListTile(
                  title: Text(record.className),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${_formatDate(record.timestamp)}'),
                      Text('Time: ${_formatTime(record.timestamp)}'),
                      if (record.location != null) ...[
                        const SizedBox(height: 4),
                        Text('Location: ${record.location!.latitude.toStringAsFixed(6)}, ${record.location!.longitude.toStringAsFixed(6)}'),
                        Text('Accuracy: ${record.location!.accuracy.toStringAsFixed(1)} m'),
                      ],
                    ],
                  ),
                  trailing: Icon(
                    record.status == AttendanceStatus.present
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: record.status == AttendanceStatus.present
                        ? Colors.green
                        : Colors.red,
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