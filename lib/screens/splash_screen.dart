import 'dart:async'; // Importing the dart:async library for Timer functionality
import 'package:alzrelief/screens/two%20Users%20Registration%20Forms/alzheimerRegistration.dart';
import 'package:alzrelief/screens/user1%20alzheimer/home/alz_home_screen.dart';
import 'package:alzrelief/screens/user3%20family/Home/family_home.dart';
import 'package:alzrelief/screens/intro_screen.dart'; // Importing the IntroPage screen
import 'package:alzrelief/screens/user2%20psychologist/Home/psy_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // Importing the Flutter Material library for UI components

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool  _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Navigate to IntroPage after a 3-second delay
    Timer(Duration(seconds: 2), () { 
      _checkUserStatus();
    });
  }

  Future<void> _checkUserStatus() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final userId = AuthHelper.currentUserId; // Retrieve the current user ID

      if (userId != null) {
        // User is logged in, check their role in Firestore
        final firestore = FirebaseFirestore.instance;

        // Check in farmer collection
        final farmilyDoc =
            await firestore.collection('family').doc(userId).get();
        if (farmilyDoc.exists) {
          _navigateToDashboard(FamilyHomePage());
          return;
        }

        // Check in buyer collection
        final alzheimerDoc = await firestore.collection('alzheimer').doc(userId).get();
        if (alzheimerDoc.exists) {
          _navigateToDashboard(AlzheimerHomePage());
          return;
        }

        // Check in mechanic collection
        final psychologistDoc =
            await firestore.collection('psychologist').doc(userId).get();
        if (psychologistDoc.exists) {
          _navigateToDashboard(PsyHomePage());
          return;
        }
      }

      

      // If user is not logged in or registered, navigate to the login screen
      _navigateToLoginScreen();
    } catch (e) {
      print('Error checking user status: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToDashboard(Widget dashboard) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => dashboard,
      ),
    );
  }

  void _navigateToLoginScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => IntroPage(),
      ),
    );
  }


  




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(95, 37, 133, 1.0), // Setting the background color of the Scaffold
        body: Center(
          child: SizedBox(
            width: 180, // Width of the container
            height: 180, // Height of the container
            child: Image.asset(
              'assets/images/AlzReliefLogo.png', // Path to the logo image asset
              fit: BoxFit.contain, // Adjusting the fit of the image inside the container
            ),
          )
        ),
      ),
    );
  }
}
