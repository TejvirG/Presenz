import 'package:flutter/material.dart';
import '../models/attendance_model.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceModel record;

  const AttendanceCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          record.status == "Present"
              ? Icons.check_circle
              : record.status == "Absent"
                  ? Icons.cancel
                  : Icons.access_time,
          color: record.status == "Present"
              ? Colors.green
              : record.status == "Absent"
                  ? Colors.red
                  : Colors.orangeAccent,
        ),
        title: Text(record.className),
        subtitle: Text(record.timestamp.toLocal().toString().split(".")[0]),
        trailing: Text(
          record.status,
          style: TextStyle(
              color: record.status == "Present"
                  ? Colors.green
                  : record.status == "Absent"
                      ? Colors.red
                      : Colors.orangeAccent),
        ),
      ),
    );
  }
}
