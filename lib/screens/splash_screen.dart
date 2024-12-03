import 'dart:async'; // Importing the dart:async library for Timer functionality
import 'package:alzrelief/screens/intro_screen.dart'; // Importing the IntroPage screen
import 'package:flutter/material.dart'; // Importing the Flutter Material library for UI components

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    
    // Navigate to IntroPage after a 3-second delay
    Timer(Duration(seconds: 3), () { 
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroPage()),
      ); 
    });
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
