import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/gps_service.dart';
import '../../widgets/gradient_button.dart';

class SetClassLocationPage extends StatefulWidget {
  const SetClassLocationPage({super.key});

  @override
  State<SetClassLocationPage> createState() => _SetClassLocationPageState();
}

class _SetClassLocationPageState extends State<SetClassLocationPage> {
  final _subjectController = TextEditingController();
  bool _isSaving = false;

  Future<void> _saveLocation() async {
    setState(() => _isSaving = true);

    try {
      final pos = await GpsService().getCurrentLocation();
      if (pos == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not get location")));
        setState(() => _isSaving = false);
        return;
      }

      final success = await ApiService().setClassLocation(
          _subjectController.text.trim(), pos.latitude, pos.longitude);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(success
              ? "Class location saved!"
              : "Failed to save location")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Class Location")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                  labelText: "Subject", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            GradientButton(
              text: _isSaving ? "Saving..." : "Set Location",
              onPressed: _isSaving ? null : () => _saveLocation(),
            ),
          ],
        ),
      ),
    );
  }
}