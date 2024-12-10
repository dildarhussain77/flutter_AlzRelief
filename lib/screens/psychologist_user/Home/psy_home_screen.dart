// ignore_for_file: prefer_const_constructors, sort_child_properties_last


import 'package:alzrelief/screens/psychologist_user/Appointments/appointments_with_alz.dart';
import 'package:alzrelief/screens/psychologist_user/appointed%20azheimers/appointed_alzheimers.dart';
import 'package:alzrelief/screens/psychologist_user/drawer/psy_drawer_header.dart';
import 'package:alzrelief/screens/psychologist_user/drawer/psy_drawer_list.dart';
import 'package:alzrelief/screens/psychologist_user/patient%20requests/patient_request.dart';
import 'package:alzrelief/util/homepagetile.dart';
import 'package:alzrelief/util/tapnavigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';


class PsyHomePage extends StatefulWidget {
  const PsyHomePage({super.key});

  @override
  State<PsyHomePage> createState() => _PsyHomePageState();
}

class _PsyHomePageState extends State<PsyHomePage> {

   int currentIndex = 0;
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    String? _fullName;
  //bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('psychologist')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          setState(() {
            _fullName = doc['fullName'];         
           // _isLoading = false;
          });
        }
      } catch (e) {
        print('Error fetching profile data: $e');

        // setState(() {
        //   //_isLoading = false;
        // });
      }
    }
  }

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    // Handle navigation based on the selected index
    switch (currentIndex) {
      case 0:
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => PsyHomePage()));
        break;
      case 1:
        // Navigate to the chats screen
        final user = FirebaseAuth.instance.currentUser;
  
        if (user != null) {
            final String psychologistId = user.uid; // Get logged-in user ID dynamically.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppointedAlzheimersPage(psychologistId: psychologistId),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("You must be logged in to view appointed psychologists.")),
            );
          }
        break;
      case 2:
        // Navigate to the consultants screen
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => AlzheimerRequestPage()));
        break;
      case 3:
        // final user = FirebaseAuth.instance.currentUser;
  
        // if (user != null) {
        //     final String psychologistId = user.uid; // Get logged-in user ID dynamically.
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => AppointmentsWithAlzheimerPage(psychologistId: psychologistId),
        //       ),
        //     );
        //   } else {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(content: Text("You must be logged in to view appointed psychologists.")),
        //     );
        //   }
       
        break;
        
    }
  }

  // Function to fetch IDs and navigate
  Future<void> fetchIds(BuildContext context, String psychologistId, String alzheimerUserId) async {
  try {
    // Fetch the psychologist document using the given psychologistId
    DocumentSnapshot psychologistDoc = await FirebaseFirestore.instance
        .collection('psychologist')
        .doc(psychologistId) // Pass the actual psychologist user ID here
        .get();

    // Fetch the Alzheimer document using the given alzheimerUserId
    DocumentSnapshot alzheimerDoc = await FirebaseFirestore.instance
        .collection('alzheimer')
        .doc(alzheimerUserId) // Pass the actual Alzheimer user ID here
        .get();

    // Use the fetched IDs
    final String fetchedPsychologistId = psychologistDoc.id;
    final String fetchedAlzheimerId = alzheimerDoc.id;

    // Navigate to ViewAppointmentsScreen with these IDs
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentsWithAlzheimersScreen(
          psychologistId: fetchedPsychologistId,
          alzheimerId: fetchedAlzheimerId,
        ),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching IDs: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    
    
    return SafeArea(
      child: Scaffold(
         key: _scaffoldKey,
          endDrawer: Drawer(
            backgroundColor: Colors.grey[200],
            child: SingleChildScrollView(
              child: Container(                
                child: Column(
                  children: [
                    PsychologistDrawerHeaderPage(),
                    PsychologistMyDrawerList(),
                    // Add other drawer items here
                  ],
                ),
              ),
            ),
          ),
      
        backgroundColor: Color.fromRGBO(95, 37, 133, 1.0),
      
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onItemTapped,
          selectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(fontSize: 12, color: Colors.black),
                        
          
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Color.fromRGBO(95, 37, 133, 1.0)), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.message, color: Color.fromRGBO(95, 37, 133, 1.0)), label: "Chats"),
            BottomNavigationBarItem(
                icon: Icon(Icons.medical_services, color: Color.fromRGBO(95, 37, 133, 1.0)),
                label: "Alzheimers"),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_active, color: Color.fromRGBO(95, 37, 133, 1.0)), label: "Alerts"),
          ],                 
        ),      
        body: Column(
          
          children: [
        
            Padding(
             padding: const EdgeInsets.symmetric(horizontal: 25.0),
             child: Column(
              
              children: [
                 //greeting row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,                  
                  children: [                    
                    Column(                      
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Text(
                          "Welcome,", 
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 24, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      
                        Text(
                            'Hi, ${_fullName ?? "not available"}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                ),
                                
                          ),
                      ],
                    ),
                
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState?.openEndDrawer();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purple[600],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                    ),           
                  ],      
                ),
                     
              SizedBox(height: 25,),                     
              ],
             ),
            ),
        
           Expanded(
             child: Container(
              padding: EdgeInsets.all(25),              
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                )
              ),
              
              
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 10,),
              
                    //listview 
                    Expanded(
                      child: ListView(
                        children: [
                         
                          Divider(
                            color: Colors.black,
                            thickness: 1,
                            height: 1,
                        
                          ),
                          SizedBox(height: 10,),

                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Upcoming Appointments", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              ),
                            ],
                          ), 


                          // Button to fetch and view the schedule
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            String? psychologistId = FirebaseAuth.instance.currentUser?.uid; // Get current psychologist's ID
                            
                            if (psychologistId != null) {
                              try {
                                // Query the first Alzheimer user (replace logic if needed)
                                QuerySnapshot alzheimerQuery = await FirebaseFirestore.instance
                                    .collection('alzheimer')
                                    .limit(1) // Limit to fetch only one document
                                    .get();

                                if (alzheimerQuery.docs.isNotEmpty) {
                                  String alzheimerUserId = alzheimerQuery.docs.first.id; // Fetch the ID of the first Alzheimer user
                                  
                                  // Call fetchIds with dynamically fetched IDs
                                  await fetchIds(context, psychologistId, alzheimerUserId);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('No Alzheimer user found in the database.')),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error fetching Alzheimer user: $e')),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No logged-in psychologist found.')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5F2585),
                          ),
                          child: const Text(
                            'View Appointments',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ),          




                        ],
                      ),
                    )
              
                  ],
                ),
              ),
             ),
           )
        
          ],
        ),
      ),
    );
  }
}
