import 'package:alzrelief/screens/user1%20alzheimer/psychologists%20search/psychologist_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'psychologist_detail_screen.dart'; // Import the new detail screen
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class PsychologistSearchScreen extends StatefulWidget {
  const PsychologistSearchScreen({super.key});

  @override
  _PsychologistSearchScreenState createState() =>
      _PsychologistSearchScreenState();
}

class _PsychologistSearchScreenState extends State<PsychologistSearchScreen> {
  late Future<List<Psychologist>> psychologists;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    psychologists = _fetchPsychologists(); // Fetch all psychologists initially
  }

  // Fetch psychologists from Firestore based on the search query
  Future<List<Psychologist>> _fetchPsychologists({String query = ''}) async {
    try {
      QuerySnapshot querySnapshot;
      if (query.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('psychologist')
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('psychologist')
            .where('fullName', isGreaterThanOrEqualTo: query)
            .where('fullName', isLessThanOrEqualTo: '$query\uf8ff') // Handle search in full name
            .get();
      }

      return querySnapshot.docs.map((doc) {
        return Psychologist.fromFirestore(doc); // This line uses the fromFirestore method
      }).toList();
    } catch (e) {
      print("Error fetching psychologists: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0), // Same background color as FamilyNotificationPage
        body: Column(
          children: [
            // Welcome row (back button and title)
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
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
                      padding: const EdgeInsets.all(7),
                      child: Text(
                        "Search Psychologists",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Psychologists',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.purple,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    psychologists = _fetchPsychologists(query: value);
                  });
                },
              ),
            ),

            // Display list of psychologists
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 5,
                  right: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: FutureBuilder<List<Psychologist>>(
                  future: psychologists,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No psychologists found'));
                    }

                    final psychologistList = snapshot.data!;

                    return ListView.builder(
                      itemCount: psychologistList.length,
                      itemBuilder: (context, index) {
                        final psychologist = psychologistList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30, // Adjust the size of the circular image
                              backgroundImage: psychologist.profileImageUrl != null
                                  ? NetworkImage(psychologist.profileImageUrl!) // Fetch from URL
                                  : AssetImage('assets/images/default_profile.jpg') as ImageProvider, // Default image
                            ),
                            title: Text(
                              psychologist.fullName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(psychologist.specialty),
                            onTap: () async {
                              // Get the current logged-in user's ID
                              final currentUser = FirebaseAuth.instance.currentUser;
                              if (currentUser == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("You must be logged in to view details.")),
                                );
                                return;
                              }
                              
                              // Pass both the current user's ID and the selected psychologist to the details screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PsychologistDetailsScreen(
                                    psychologist: psychologist,
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
