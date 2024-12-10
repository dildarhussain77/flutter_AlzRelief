import 'package:alzrelief/screens/Three%20Users%20Registration%20Forms/alzheimerRegistration.dart';
import 'package:alzrelief/screens/Three%20Users%20Registration%20Forms/family/familyRegistration.dart';
import 'package:alzrelief/screens/Three%20Users%20Registration%20Forms/psychologistRegistration.dart';
import 'package:alzrelief/util/homepagetile.dart';
import 'package:alzrelief/util/image_logo_helper.dart';
import 'package:alzrelief/util/tapnavigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSelectionPage extends StatelessWidget {
  const UserSelectionPage({super.key});



   // Function to save user role in Firestore
  Future<void> _saveUserRole(String role) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      // Save role in the user's Firestore document in the respective collection
      CollectionReference userCollection;
      switch (role) {
        case 'family':
          userCollection = FirebaseFirestore.instance.collection('family');
          break;
        case 'psychologist':
          userCollection = FirebaseFirestore.instance.collection('psychologist');
          break;
        case 'alzheimer':
          userCollection = FirebaseFirestore.instance.collection('alzheimer');
          break;
        default:
          return;
      }

      // Save user details in the respective collection
      await userCollection.doc(userId).set({
        'userId': userId,
        'role': role,
        'registrationComplete': false, // Set it to false initially
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(    
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        body: Column(
          children: [              
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [                
                LogoImage(
                  imagePath: 'assets/images/user.png',
                  borderColor: null,
                ),
              ],
            ),              
            const SizedBox(height: 15,),              
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),              
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                )
              ),
                child: Center(
                  child: Column(  
                    children: [              
                       Expanded(
                        child: ListView(
                          children: [                            
                            Text("Hi! Choose your category?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                            SizedBox(height: 8,),
                            Text("Select 'Psychologist' if you are a professional psychologist, 'Normal User' if you want to speak to a psychologist, or 'Family/Caregiver' if you are assisting someone in need of psychological support.",style: TextStyle(fontSize: 14)),
                            SizedBox(height: 25,),

                            TapNavigation(
                              destination: PsychologistRegistrationScreen(),
                              onBeforeNavigate: () => _saveUserRole('psychologist'),                                                          
                              child: HomePageTile(
                                height: 87,
                                width: 100,
                                icon: null,
                                iconColor: Colors.red,
                                iconAsset: 'assets/images/psychologist2.png',
                                homeTileName: "Psychologist",
                                homeTileDes: "Professional Psychologist",
                                color: Colors.pink[200],                                 
                              ),
                            ),

                            TapNavigation(
                              destination: AlzheimerRegistration(), 
                              onBeforeNavigate: () => _saveUserRole('alzheimer'),                            
                              child: HomePageTile(
                                height: 87,
                                width: 100,
                                icon: null,
                                iconColor: Colors.red,
                                iconAsset: 'assets/images/Alzheimer.png',
                                homeTileName: "Alzheimer",
                                homeTileDes: "Looking for Support",
                                color: Colors.lightGreen[200],                                                                
                              ),                              
                            ),

                            TapNavigation(
                              destination: FamilyRegistrationScreen(),
                              onBeforeNavigate: () => _saveUserRole('family'),                             
                              child: HomePageTile(
                                height: 87,
                                width: 100,
                                icon: null,
                                iconColor: Colors.red,
                                iconAsset: 'assets/images/family.png',
                                homeTileName: "Family/Caregiver",
                                homeTileDes: "Supporting a Loved One",
                                color: Colors.orange[200],                                 
                              ),
                            ),                                                      
                          ],
                        ),
                      ),                                            
                    ]
                  ),
                )
              ),
            )
          ],
        ),  
      ),
    );
  }
}