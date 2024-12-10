import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentsWithPsychologistsScreen extends StatefulWidget {
  final String psychologistId;
  final String alzheimerId;

  const AppointmentsWithPsychologistsScreen({
    Key? key,
    required this.psychologistId,
    required this.alzheimerId,
  }) : super(key: key);

  @override
  State<AppointmentsWithPsychologistsScreen> createState() => _AppointmentsWithPsychologistsScreenState();
}

class _AppointmentsWithPsychologistsScreenState extends State<AppointmentsWithPsychologistsScreen> {
  List<Map<String, dynamic>> schedules = [];

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  // Fetch schedules from Firebase
  Future<void> _fetchSchedules() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('psychologist')
          .doc(widget.psychologistId)
          .collection('appointedAlzheimers')
          .doc(widget.alzheimerId)
          .collection('schedules')
          .get();

      setState(() {
        schedules = snapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching schedules: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF5F2585),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: schedules.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(schedule["title"] ?? "No title"),
                    subtitle: Text(
                      "Date: ${schedule["date"]}\nTime: ${schedule["time"]}\nAlzheimer: ${schedule["alzheimerName"]}",
                       //"Date: ${schedule["date"]}\nTime: ${schedule["time"]}\nPsychologist: ${schedule["psychologistName"]}}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text(
                "No schedules available.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
    );
  }
}
