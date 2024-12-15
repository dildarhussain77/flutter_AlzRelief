import 'package:alzrelief/screens/users%20chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointedAlzheimersPage extends StatelessWidget {
  final String psychologistId;

  const AppointedAlzheimersPage({super.key, required this.psychologistId});

  Future<List<Map<String, dynamic>>> _fetchAppointedAlzheimers() async {
    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance     
        .collection('psychologist')
        .doc(psychologistId)
        .collection('appointedAlzheimers')
        .get();
        
        List<Map<String, dynamic>> alzheimers = [];

        for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final alzheimerUserId = doc.id;

        // Fetch alzheimer details from the alzheimer collection
        final alzheimerDoc = await FirebaseFirestore.instance
            .collection('alzheimer')
            .doc(alzheimerUserId)
            .get();


            if (alzheimerDoc.exists) {
          final alzheimerData = alzheimerDoc.data() as Map<String, dynamic>;
          alzheimers.add({
            'alzheimerUserId': alzheimerUserId,
            'fullName': alzheimerData['fullName'], // Correct key for name
            'phoneNumber': alzheimerData['phoneNumber'],
            'profileImageUrl': alzheimerData['profileImageUrl'], // URL of the picture (adjusted key)
            ...data,
          });
        }
      }
           
      return alzheimers;
    }
    catch (e) {
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
                        "Chat with Alzheimers",
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
                padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[200], 
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchAppointedAlzheimers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text("No appointed Alzheimer users yet."),
                      );
                    }

                    final alzheimerUsers = snapshot.data!;
                    return ListView.builder(
                      itemCount: alzheimerUsers.length,
                      itemBuilder: (context, index) {
                        final alzheimer = alzheimerUsers[index];
                        final alzheimerUserId = alzheimer['alzheimerUserId'];
                        final alzheimerUserName = alzheimer['fullName'];
                        // final phoneNumber = alzheimer['phoneNumber'];
                        // final profilePictureUrl = alzheimer['profileImageUrl'];

                      
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            leading: alzheimer['profileImageUrl'] != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(alzheimer['profileImageUrl']),
                                    radius: 30,
                                  )
                                : CircleAvatar(
                                    radius: 30,
                                    child: Icon(Icons.person),
                                  ),
                            title: Text(
                              alzheimer['fullName'] ?? "Unknown",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "${alzheimer['phoneNumber'] ?? "Not available"}",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: Icon(Icons.chat, color: Colors.blue),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    userId: psychologistId,
                                    peerId: alzheimerUserId,
                                    peerName: alzheimerUserName,
                                    isPsychologist: true,
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
