
import 'package:alzrelief/screens/user1%20alzheimer/Chat%20with%20appointed%20psychologists/appointed_psychologists.dart';
import 'package:alzrelief/screens/user1%20alzheimer/drawer/alz_drawer_list.dart';
import 'package:alzrelief/screens/user1%20alzheimer/home/emotion_handler.dart';
import 'package:alzrelief/screens/user1%20alzheimer/Activity_Manager/activities_screen.dart';
import 'package:alzrelief/screens/user1%20alzheimer/help_me/help_me_screen.dart';
import 'package:alzrelief/screens/user1%20alzheimer/alerts/notification_screen.dart';
import 'package:alzrelief/screens/user1%20alzheimer/drawer/alz_drawer_header_screen.dart';
import 'package:alzrelief/screens/user1%20alzheimer/appointments%20show/appointments_with_psy.dart';
import 'package:alzrelief/screens/user1%20alzheimer/Todo/screen.dart/to_do_screen.dart';
import 'package:alzrelief/screens/user1%20alzheimer/psychologists%20search/search_psychologist_screen.dart';
import 'package:alzrelief/util/uihelper.dart';
import 'package:alzrelief/screens/user1%20alzheimer/home/emotionfacepage.dart';
import 'package:alzrelief/util/homepagetile.dart';
import 'package:alzrelief/util/tapnavigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AlzheimerHomePage extends StatefulWidget {
  const AlzheimerHomePage({super.key});

  @override
  State<AlzheimerHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<AlzheimerHomePage> {

  // String psychologistId = '';
  // String psychologistName = '';

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
            .collection('alzheimer')
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


  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();  

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    // Handle navigation based on the selected index
    switch (currentIndex) {
      case 0:
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => AlzheimerHomePage()));
        break;
      case 1:
        final user = FirebaseAuth.instance.currentUser;
  
        if (user != null) {
            final String alzheimerUserId = user.uid; // Get logged-in user ID dynamically.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppointedPsychologistsPage(alzheimerUserId: alzheimerUserId),
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
          context, MaterialPageRoute(builder: (context) => PsychologistSearchScreen()));
        break;
      case 3:
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => AlzheimerNotificationScreen()));
        // _scaffoldKey.currentState?.openEndDrawer();
        break;
    }
  }


  // Function to fetch IDs and navigate
  Future<void> fetchIds(BuildContext context, String alzheimerUserId, String psychologistId) async {
  try {
    // Ensure the user is authenticated and get the updated ID token
    final user = FirebaseAuth.instance.currentUser;
    // Refresh token
    if (user != null) {
      final idToken = await user.getIdToken(true); // true forces token refresh
      print("Refreshed Token: $idToken");  // You can print the token for debugging purposes
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No logged-in user found!')),
      );
      return;
    }

    // Fetch the alzheimer document using the given alzheimerUserId
    DocumentSnapshot alzheimerDoc = await FirebaseFirestore.instance
        .collection('alzheimer')
        .doc(alzheimerUserId) // Pass the actual alzheimer user ID here
        .get();

    // Fetch the psychologist document using the given psychologistId
    DocumentSnapshot psychologistDoc = await FirebaseFirestore.instance
        .collection('psychologist')
        .doc(psychologistId) // Pass the actual psychologist user ID here
        .get();

    // Use the fetched IDs
    final String fetchedPsychologistId = psychologistDoc.id;
    final String fetchedAlzheimerId = alzheimerDoc.id;

    // Navigate to ViewAppointmentsScreen with these IDs
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentsWithPsychologistsScreen(
          alzheimerId: fetchedAlzheimerId,
          psychologistId: fetchedPsychologistId,
          
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
                    AlzheimerDrawerHeaderPage(),
                    AlzheimerMyDrawerList(),
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
                icon: Icon(Icons.home, color: Color.fromRGBO(95, 37, 133, 1.0),), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.message, color: Color.fromRGBO(95, 37, 133, 1.0),), label: "Chats"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_search, color: Color.fromRGBO(95, 37, 133, 1.0),),
                label: "Psychologists"),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_active, color: Color.fromRGBO(95, 37, 133, 1.0),), label: "Alerts"),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  //greeting row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Hi, ${_fullName ?? "not available"}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                ),
                                
                          ),
                          Text(
                            "be safe, be aware and memorize.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
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
                  SizedBox(
                    height: 25,
                  ),
                  //how are you feel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "How do you feel?",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //four different faces
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Happy
                      GestureDetector(
                        onTap: () => EmotionHandler.selectEmotion(context, Emotion.Happy),
                        child: Column(
                          children: [
                            // Display the happy face icon
                            EmotionFace(emotionFace: "😊"),
                            SizedBox(height: 8),
                            Text(
                              "Happy",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => EmotionHandler.selectEmotion(context, Emotion.Sad),
                        child: Column(
                          children: [
                            
                            EmotionFace(emotionFace: "😥"),
                            SizedBox(height: 8),
                            Text(
                              "Sad",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => EmotionHandler.selectEmotion(context, Emotion. Confused),
                        child: Column(
                          children: [
                            
                            EmotionFace(emotionFace: "😕"),
                            SizedBox(height: 8),
                            Text(
                              " Confused",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => EmotionHandler.selectEmotion(context, Emotion.Angry),
                        child: Column(
                          children: [
                            
                            EmotionFace(emotionFace: "😠"),
                            SizedBox(height: 8),
                            Text(
                              "Angry",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      
                      // ...
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "I'm Lost  ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      CustomButton(
                        voidCallBack: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HelpMePage()),
                          );
                        },
                        text: 'Help me',
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        height: 40,
                        width: 130,
                      )
                    ], //children
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    )),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      //listview
                      Expanded(
                        child: ListView(
                          children: [
                            TapNavigation(
                              destination: ActivitiesPage(),
                              child: HomePageTile(
                                height: 87,
                                width: 100,
                                iconAsset: 'assets/images/mindexercise.png',
                                icon: null,
                                iconColor: Colors.red,
                                homeTileName: "Activity Manager",
                                homeTileDes: "Think & Recall",
                                color: Colors.lightGreen[200],
                              ),
                              
                            ),
                            TapNavigation(
                              destination: ToDoPage(),
                              child: HomePageTile(
                                height: 87,
                                width: 100,
                                icon: null,
                                iconColor: Colors.lightBlue,
                                homeTileName: "To-Do List",
                                homeTileDes: "Organize your events",
                                color: Colors.lightBlue[200],
                                iconAsset: 'assets/images/todo.png',
                              ),
                            ),
                            

                            ElevatedButton(
                              onPressed: () async {
                                String? alzheimerUserId = FirebaseAuth.instance.currentUser?.uid; // Get current psychologist's ID
                            
                                if (alzheimerUserId != null) {
                                  try {
                                    // Query the first psychologist user (replace logic if needed)
                                    QuerySnapshot psychologistQuery = await FirebaseFirestore.instance
                                        .collection('psychologist')
                                        .limit(1) // Limit to fetch only one document
                                        .get();
                            
                                    if (psychologistQuery.docs.isNotEmpty) {
                                      String psychologistId = psychologistQuery.docs.first.id; // Fetch the ID of the first Alzheimer user
                                      
                                      // Call fetchIds with dynamically fetched IDs
                                      await fetchIds(context, alzheimerUserId, psychologistId);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('No Psychologist user found in the database.')),
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
                                backgroundColor: Colors.white, // Button background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15), // Rounded corners
                                ),
                                padding: EdgeInsets.all(15,),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10), // Padding inside the container
                                    decoration: BoxDecoration(
                                      color: Colors.orange[200], // Background color with opacity (dark background)
                                      borderRadius: BorderRadius.circular(15), // Rounded corners for the background
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange.withOpacity(0.0), // Shadow color
                                          blurRadius: 10, // Blur effect for shadow
                                          offset: Offset(0, 4), // Position of the shadow
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/images/appointment.png', // Your image file from assets
                                      height: 40, // Set the size of the image
                                      width: 40, // Set the width of the image
                                    ),
                                  ),
                                  SizedBox(width: 14),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'View Appointments',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'See your appointments',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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