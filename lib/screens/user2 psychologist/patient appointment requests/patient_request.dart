import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AlzheimerRequestPage extends StatefulWidget {
  const AlzheimerRequestPage({super.key});

  @override
  State<AlzheimerRequestPage> createState() => _AlzheimerRequestPageState();
}

class _AlzheimerRequestPageState extends State<AlzheimerRequestPage> {
  Future<void> _addNotification(String userId, String psychologistName, String message) async {
    try {
      final notificationId = FirebaseFirestore.instance
          .collection('alzheimer')
          .doc(userId)
          .collection('notifications')
          .doc()
          .id;

      await FirebaseFirestore.instance
          .collection('alzheimer')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .set({
        'type': 'Appointment Status Update',
        'psychologistName': psychologistName,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Notification added successfully");
    } catch (e) {
      print("Error adding notification: $e");
    }
  }

  Future<List<Map<String, dynamic>>> _fetchRequests(String psychologistId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('psychologist')
          .doc(psychologistId)
          .collection('requests')
          .where('status', isEqualTo: 'pending')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'requestId': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      print("Error fetching requests: $e");
      return [];
    }
  }

  Future<void> _updateRequestStatus(
    String psychologistId,
    String psychologistName,
    String requestId,
    String status,
    String alzheimerUserId,
    String alzheimerUserName,
    List<Map<String, dynamic>> requests,
    int index,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('psychologist')
          .doc(psychologistId)
          .collection('requests')
          .doc(requestId)
          .update({'status': status});

      await FirebaseFirestore.instance
          .collection('alzheimer')
          .doc(alzheimerUserId)
          .collection('bookedRequests')
          .doc(requestId)
          .update({'status': status});
      
      if (status == "accepted") {
        // Add psychologist details to the appointedPsychologists subcollection
        await FirebaseFirestore.instance
            .collection('alzheimer')
            .doc(alzheimerUserId)
            .collection('appointedPsychologists')
            .doc(psychologistId)
            .set({
          'psychologistId': psychologistId,
          'psychologistName': psychologistName,                
          'appointmentDate': FieldValue.serverTimestamp(),
        });


      // Add Alzheimer user details to the appointedAlzheimers subcollection
      await FirebaseFirestore.instance
          .collection('psychologist')
          .doc(psychologistId)
          .collection('appointedAlzheimers')
          .doc(alzheimerUserId)
          .set({
        'alzheimerUserId': alzheimerUserId,
        'alzheimerUserName': alzheimerUserName,
        'appointmentDate': FieldValue.serverTimestamp(),
      });
      }



      String message = "Appointment request has been $status by $psychologistName";
      await _addNotification(alzheimerUserId, psychologistName, message);

      setState(() {
        requests.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request $status successfully!")),
      );
    } catch (e) {
      print("Error updating request status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update request. Try again!")),
      );
    }
  }

  Future<String> _getPsychologistName(String psychologistId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('psychologist')
          .doc(psychologistId)
          .get();

      if (doc.exists) {
        return doc['fullName'] ?? 'Unknown';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      print("Error fetching psychologist name: $e");
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Appointment Requests")),
        body: Center(child: Text("Please log in to see requests.")),
      );
    }

    final String psychologistId = user.uid;

    return SafeArea(
      child: Scaffold(        
        backgroundColor: const Color(0xFF5F2585),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7.0),
                      child: Text(
                        "Alzheimers Requests",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 5,
                  right: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Light background for notifications
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),

                child: FutureBuilder<String>(
                  future: _getPsychologistName(psychologistId),
                  builder: (context, nameSnapshot) {
                    if (nameSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
              
                    if (nameSnapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red, size: 50),
                            SizedBox(height: 10),
                            Text('Error fetching name: ${nameSnapshot.error}'),
                          ],
                        ),
                      );
                    }
              
                    final psychologistName = nameSnapshot.data ?? 'Unknown';                                     
              
                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchRequests(psychologistId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, color: Colors.red, size: 50),
                                SizedBox(height: 10),
                                Text("Error: ${snapshot.error}"),
                              ],
                            ),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info, color: Colors.blue, size: 50),
                                SizedBox(height: 10),
                                Text("No requests yet."),
                              ],
                            ),
                          );
                        }
              
                        final requests = snapshot.data!;
                        return ListView.builder(
                          itemCount: requests.length,
                          itemBuilder: (context, index) {
                            final request = requests[index];
                            bool isAcceptedOrDenied = request['status'] != 'pending';
                              
                            return Card(
                              elevation: 3,
                              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Alzheimer User: ${request['alzheimerUserName']}",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 8),
                                    Text("Status: ${request['status']}",
                                        style: TextStyle(
                                            color: request['status'] == 'pending'
                                                ? Colors.orange
                                                : request['status'] == 'accepted'
                                                    ? Colors.green
                                                    : Colors.red)),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        OutlinedButton.icon(
                                          icon: Icon(Icons.check, color: Colors.green),
                                          label: Text("Accept"),
                                          onPressed: isAcceptedOrDenied
                                              ? null
                                              : () => _updateRequestStatus(
                                                    psychologistId,
                                                    psychologistName,                                                                                                 
                                                    request['requestId'],
                                                    "accepted",
                                                    request['alzheimerUserId'],
                                                    request['alzheimerUserName'],
                                                    requests,
                                                    index,
                                                  ),
                                        ),
                                        SizedBox(width: 8),
                                        OutlinedButton.icon(
                                          icon: Icon(Icons.close, color: Colors.red),
                                          label: Text("Deny"),
                                          onPressed: isAcceptedOrDenied
                                              ? null
                                              : () => _updateRequestStatus(
                                                    psychologistId,
                                                    psychologistName,                                                    
                                                    request['requestId'],
                                                    "denied",
                                                    request['alzheimerUserId'],
                                                    request['alzheimerUserName'],
                                                    requests,
                                                    index,
                                                  ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}
