import 'package:alzrelief/screens/users%20chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointedPsychologistsPage extends StatefulWidget {
  final String alzheimerUserId;

  const AppointedPsychologistsPage({super.key, required this.alzheimerUserId});

  @override
  State<AppointedPsychologistsPage> createState() => _AppointedPsychologistsPageState();
}

class _AppointedPsychologistsPageState extends State<AppointedPsychologistsPage> {
  Future<List<Map<String, dynamic>>> _fetchAppointedPsychologists() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('alzheimer')
          .doc(widget.alzheimerUserId)
          .collection('appointedPsychologists')
          .get();

      List<Map<String, dynamic>> psychologists = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final psychologistId = doc.id;

        // Fetch psychologist details from the psychologist collection
        final psychologistDoc = await FirebaseFirestore.instance
            .collection('psychologist')
            .doc(psychologistId)
            .get();

        if (psychologistDoc.exists) {
          final psychologistData = psychologistDoc.data() as Map<String, dynamic>;
          psychologists.add({
            'psychologistId': psychologistId,
            'fullName': psychologistData['fullName'], // Correct key for name
            'specialty': psychologistData['specialty'],
            'profileImageUrl': psychologistData['profileImageUrl'], // URL of the picture (adjusted key)
            ...data,
          });
        }
      }

      return psychologists;
    } catch (e) {
      print("Error fetching appointed psychologists: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        "Chat with Psychologists",
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
                child: FutureBuilder<List<Map<String, dynamic>>>( 
                  future: _fetchAppointedPsychologists(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text("No appointed psychologists yet."),
                      );
                    }

                    final psychologists = snapshot.data!;
                    return ListView.builder(
                      itemCount: psychologists.length,
                      itemBuilder: (context, index) {
                        final psychologist = psychologists[index];

                        final psychologistId = psychologist['psychologistId'];
                        final psychologistName = psychologist['fullName'];

                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            leading: psychologist['profileImageUrl'] != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(psychologist['profileImageUrl']),
                                    radius: 30,
                                  )
                                : CircleAvatar(
                                    radius: 30,
                                    child: Icon(Icons.person),
                                  ),
                            title: Text(
                              psychologist['fullName'] ?? "Unknown",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "${psychologist['specialty'] ?? "Not available"}",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: Icon(Icons.chat, color: Colors.blue),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    userId: widget.alzheimerUserId, // Current Alzheimer's user ID
                                    peerId: psychologistId, // Selected Psychologist's ID
                                    peerName: psychologistName, // Selected Psychologist's Name
                                    isPsychologist: false, // Alzheimer's user is the current user
                                  ),
                                ),
                              );
                            },
                          ),
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








