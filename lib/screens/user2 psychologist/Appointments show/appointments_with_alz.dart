import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentsWithAlzheimersScreen extends StatefulWidget {
  final String psychologistId;
  final String alzheimerId;

  const AppointmentsWithAlzheimersScreen({
    super.key,
    required this.psychologistId,
    required this.alzheimerId,
  });

  @override
  State<AppointmentsWithAlzheimersScreen> createState() => _AppointmentsWithAlzheimersScreenState();
}

class _AppointmentsWithAlzheimersScreenState extends State<AppointmentsWithAlzheimersScreen> {
  List<Map<String, dynamic>> schedules = [];

  @override
  void initState() {
    super.initState();
    _fetchSchedules();
  }

  // Fetch schedules from Firebase
  // Future<void> _fetchSchedules() async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection('psychologist')
  //         .doc(widget.psychologistId)
  //         .collection('appointedAlzheimers')
  //         .doc(widget.alzheimerId)
  //         .collection('schedules')
  //         .get();

  //     setState(() {
  //       schedules = snapshot.docs.map((doc) {
  //         final data = doc.data() as Map<String, dynamic>;
  //         data['id'] = doc.id; // Add document ID for updates
  //         return data;
  //       }).toList();
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error fetching schedules: $e')),
  //     );
  //   }
  // }


Future<void> _fetchSchedules() async {
  try {
    // Fetch all documents in the appointedAlzheimers subcollection
    final appointedAlzheimersSnapshot = await FirebaseFirestore.instance
        .collection('psychologist')
        .doc(widget.psychologistId)
        .collection('appointedAlzheimers')
        .get();

    List<Map<String, dynamic>> fetchedSchedules = [];

    for (var alzheimerDoc in appointedAlzheimersSnapshot.docs) {
      // Fetch schedules subcollection for each appointed Alzheimer user
      final schedulesSnapshot = await FirebaseFirestore.instance
          .collection('psychologist')
          .doc(widget.psychologistId)
          .collection('appointedAlzheimers')
          .doc(alzheimerDoc.id)
          .collection('schedules')
          .get();

      for (var scheduleDoc in schedulesSnapshot.docs) {
        final scheduleData = scheduleDoc.data();
        scheduleData['id'] = scheduleDoc.id; // Add document ID
        scheduleData['alzheimerName'] = alzheimerDoc['alzheimerUserName']; // Add Alzheimer's user name
        fetchedSchedules.add(scheduleData);
      }
    }

    setState(() {
      schedules = fetchedSchedules;
    });

    if (schedules.isEmpty) {
      print("No schedules found!");
    } else {
      print("Schedules fetched successfully!");
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching schedules: $e')),
    );
  }
}

 //Fetch schedules from Firebase   commenting on 12/12
//  Future<void> _fetchSchedules() async {
//   try {  
//   QuerySnapshot snapshot = await FirebaseFirestore.instance
//     .collection('psychologist')
//     .doc(widget.psychologistId) // Ensure dynamic ID here
//     .collection('appointedAlzheimers')
//     .doc(widget.alzheimerId)  // Ensure dynamic ID here
//     .collection('schedules')
//     .get();

//   if (snapshot.docs.isEmpty) {
//     print("No documents found in schedules collection!");
//   } else {
//     for (var doc in snapshot.docs) {
//       schedules = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//       print("Document ID: ${doc.id}, Data: ${doc.data()}");
//       setState(() {});
//     }
//   }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching schedules: $e')),
//       );
//     }
//   }

// void fetchSchedules() async {
//   QuerySnapshot snapshot = await FirebaseFirestore.instance
//       .collection('psychologist')
//       .doc(psychologistId)
//       .collection('appointedAlzheimers')
//       .doc(alzheimerUserId)
//       .collection('schedules')
//       .get();
//   if (snapshot.docs.isNotEmpty) {
//     schedules = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//     setState(() {}); // Rebuild the widget with the updated data
//   }
// }


  // Update appointment completion status in Firebase
  Future<void> _updateAppointmentStatus(String scheduleId, bool isCompleted) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('psychologist')
          .doc(widget.psychologistId)
          .collection('appointedAlzheimers')
          .doc(widget.alzheimerId)
          .collection('schedules')
          .doc(scheduleId);

      await docRef.update({'isCompleted': isCompleted});

      // Refresh the UI
      setState(() {
        schedules.firstWhere((schedule) => schedule['id'] == scheduleId)['isCompleted'] = isCompleted;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment status updated.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Center(
                    child: Text(
                      "Appointments", style: TextStyle(
                        color: Colors.white, fontSize: 24, 
                        fontWeight: FontWeight.bold),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Center(
                      child: Image.asset(
                        'assets/images/appointment.png',
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ),                 
                ],
              ),
            ),

            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 5, right: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),                  
                  
                child: schedules.isNotEmpty
                ? ListView.builder(                  
                    padding: const EdgeInsets.all(16.0),
                    itemCount: schedules.length,
                    itemBuilder: (context, index) {
                      final schedule = schedules[index];
                      final isCompleted = schedule['isCompleted'] ?? false;                      
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),                        
                        child: ListTile(                          
                          leading: CircleAvatar(
                            backgroundColor: isCompleted ? Colors.green : Colors.grey,
                            child: Icon(
                              isCompleted ? Icons.check : Icons.access_time,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            schedule["title"] ?? "No title",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isCompleted ? Colors.green : Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            "Date: ${schedule["date"]}\nTime: ${schedule["time"]}\nWith: ${schedule["alzheimerName"]}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isCompleted ? Icons.undo : Icons.check_circle,
                              color: isCompleted ? Colors.red : Colors.green,
                            ),
                            onPressed: () {
                              _updateAppointmentStatus(schedule['id'], !isCompleted);
                            },
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
              ),
            ),
          ],
        )                
      ),
    );
  }
}
