import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddScheduleScreen extends StatefulWidget {
  final String psychologistId;
  final String alzheimerId;

  const AddScheduleScreen({
    super.key,
    required this.psychologistId,
    required this.alzheimerId,
  });

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  List<Map<String, dynamic>> schedules = []; // List to store schedules fetched from Firebase
  String psychologistName = '';
  String alzheimerName = '';

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchNames(); // Fetch names when the screen is initialized
  }

  // Fetch names for Alzheimer's and Psychologist
  Future<void> _fetchNames() async {
    try {
      // Fetch psychologist's name
      DocumentSnapshot psychologistDoc = await FirebaseFirestore.instance
          .collection('psychologist')
          .doc(widget.psychologistId)
          .get();
      setState(() {
        psychologistName = psychologistDoc['fullName'] ?? 'No name';
      });

      // Fetch Alzheimer's user's name
      DocumentSnapshot alzheimerDoc = await FirebaseFirestore.instance
          .collection('alzheimer')
          .doc(widget.alzheimerId)
          .get();
      setState(() {
        alzheimerName = alzheimerDoc['fullName'] ?? 'No name';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching names: $e')),
      );
    }
  }

  Future<void> _addSchedule() async {
    if (_titleController.text.trim().isEmpty ||
        _dateController.text.trim().isEmpty ||
        _timeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required!')),
      );
      return;
    }

    try {
      final scheduleData = {
        "title": _titleController.text.trim(),
        "date": _dateController.text.trim(),
        "time": _timeController.text.trim(),
        "createdAt": FieldValue.serverTimestamp(),
        "psychologistName": psychologistName,
        "alzheimerName": alzheimerName,
      };

      // Save schedule in psychologist's collection
      await FirebaseFirestore.instance
          .collection('psychologist')
          .doc(widget.psychologistId)
          .collection('appointedAlzheimers')
          .doc(widget.alzheimerId)
          .collection('schedules')
          .add(scheduleData);

      // Save schedule in Alzheimer's collection
      await FirebaseFirestore.instance
          .collection('alzheimer')
          .doc(widget.alzheimerId)
          .collection('appointedPsychologists')
          .doc(widget.psychologistId)
          .collection('schedules')
          .add(scheduleData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule added successfully!')),
      );

      Navigator.pop(context); // Close the screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding schedule: $e')),
      );
    }
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = '${pickedDate.toLocal()}'.split(' ')[0]; // Format as YYYY-MM-DD
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _timeController.text = pickedTime.format(context);
      });
    }
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
          return doc.data();
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
        title: const Text("Add Schedule", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF5F2585),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Title",
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5F2585)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: "Enter schedule title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Date (e.g., YYYY-MM-DD)",
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5F2585)),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      hintText: "Select date",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Time (e.g., HH:MM AM/PM)",
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5F2585)),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _selectTime,
                child: AbsorbPointer(
                  child: TextField(
                    controller: _timeController,
                    decoration: const InputDecoration(
                      hintText: "Select time",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _addSchedule,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 90),
                    backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
                  ),
                  child: const Text(
                    "Add Schedule",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Button to fetch and view the schedule
              // Center(
              //   child: ElevatedButton(
              //     onPressed: _fetchSchedules,
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Color(0xFF5F2585),
              //     ),
              //     child: const Text(
              //       "View Schedules",
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 32),
              // Display fetched schedules
              if (schedules.isNotEmpty) ...[
                const Text(
                  "Scheduled Appointments:",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5F2585)),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = schedules[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(schedule["title"] ?? "No title"),
                        subtitle: Text(
                          "Date: ${schedule["date"]}\nTime: ${schedule["time"]}\nPsychologist: ${schedule["psychologistName"]}\nAlzheimer: ${schedule["alzheimerName"]}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
