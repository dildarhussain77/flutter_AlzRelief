import 'package:alzrelief/screens/alzheimer_user/psychologists%20search/psychologist_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PsychologistDetailsScreen extends StatefulWidget {
  final Psychologist psychologist;

  PsychologistDetailsScreen({required this.psychologist});

  @override
  _PsychologistDetailsScreenState createState() =>
      _PsychologistDetailsScreenState();
}

class _PsychologistDetailsScreenState extends State<PsychologistDetailsScreen> {
  Future<List<Map<String, dynamic>>> _fetchBookedRequests(String userId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('alzheimer')
        .doc(userId)
        .collection('bookedRequests')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'requestId': doc.id,
        'psychologistName': data['fullName'], // Fetch psychologist name
        //'alzheimerUserName': data['alzheimerUserName'], // Fetch Alzheimer user name
        ...data,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final psychologist = widget.psychologist;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 10.0
                ),
                child: Stack(
                  children: [          
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),                                    
                  // Profile Image
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 65,
                          backgroundImage: psychologist.profileImageUrl != null
                              ? NetworkImage(psychologist.profileImageUrl!)
                              : AssetImage('assets/images/default_profile.jpg') as ImageProvider,
                        ),
                        SizedBox(height: 7.0),
                        Text(
                          psychologist.fullName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          psychologist.specialty,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,                    
                          ),
                        ),                        
                      ],
                    ),
                  ),                                  
                ],
              ),
            ),                    
            // Main Details Container
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [                      
                      // Section 2: Working Details
                      SectionTitle(title: "Working Details"),
                      DetailRow(
                        icon: Icons.access_time,
                        label: "Working Hours",
                        color: Colors.orangeAccent,
                        value:
                            "${psychologist.startTime?.format(context)} - ${psychologist.endTime?.format(context)}",
                      ),
                      DetailRow(
                        icon: Icons.description,
                        label: "Description",
                        value: psychologist.description,
                        color: Colors.lightGreen,
                      ),
                      SizedBox(height: 30),

                      // Book Appointment Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("You must be logged in to book an appointment.")),
    );
    return;
  }

  final alzheimerUserId = currentUser.uid;
  String alzheimerUserName = "Unknown User";

  try {
    print("Fetching Alzheimer's user name...");
    final userDoc = await FirebaseFirestore.instance
        .collection('alzheimer')
        .doc(alzheimerUserId)
        .get();
    if (userDoc.exists) {
      alzheimerUserName = userDoc.data()?['fullName'] ?? alzheimerUserName;
    }

    print("Checking for existing requests...");
    final existingRequest = await FirebaseFirestore.instance
        .collection('psychologist')
        .doc(psychologist.id)
        .collection('requests')
        .where('alzheimerUserId', isEqualTo: alzheimerUserId)
        .get();

    // Check if any request exists with a status other than 'denied'
    bool canSendRequest = true;
    for (var doc in existingRequest.docs) {
      final status = doc.data()['status'];
      if (status != 'denied') {
        canSendRequest = false;
        break;
      }
    }

    if (!canSendRequest) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You have already sent a request please check Chats.")),
      );
      return;
    }

    print("Creating new request...");
    final requestId = FirebaseFirestore.instance.collection('requests').doc().id;
    final appointmentDate = Timestamp.now();
    final description = "Alzheimer User requests an appointment.";

    await FirebaseFirestore.instance
        .collection('psychologist')
        .doc(psychologist.id)
        .collection('requests')
        .doc(requestId)
        .set({
      'alzheimerUserId': alzheimerUserId,
      'alzheimerUserName': alzheimerUserName,
      'status': 'pending',
      'appointmentDate': appointmentDate,
      'description': description,
    });

    await FirebaseFirestore.instance
        .collection('alzheimer')
        .doc(alzheimerUserId)
        .collection('bookedRequests')
        .doc(requestId)
        .set({
      'psychologistId': psychologist.id,
      'psychologistName': psychologist.fullName,
      'status': 'pending',
      'appointmentDate': appointmentDate,
      'description': description,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Appointment request sent successfully! wait for alert")),
    );
  } catch (e, stacktrace) {
    print("Error creating appointment request: $e");
    print("Stacktrace: $stacktrace");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to send request. Try again!")),
    );
  }
},



                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5F2585),
                            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "Appointment Request",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Section Title Widget
class SectionTitle extends StatelessWidget {
  final String title;
  

  SectionTitle({required this.title, });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}


// Detail Row Widget
class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  DetailRow({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
