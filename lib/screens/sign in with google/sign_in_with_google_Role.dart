import 'package:alzrelief/screens/alzheimer_user/home/alz_home_screen.dart';
import 'package:alzrelief/screens/family_user/Home/family_home.dart';
import 'package:alzrelief/screens/psychologist_user/Home/psy_home_screen.dart';
import 'package:alzrelief/screens/userselectionscreen.dart';
import 'package:alzrelief/util/image_logo_helper.dart';
import 'package:alzrelief/util/uihelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// // Define the FlutterLocalNotificationsPlugin instance at the top of your file
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
// Future<void> initNotification() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   final InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);

//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
// }

class SignInWithGoogleRolePage extends StatefulWidget {
  const SignInWithGoogleRolePage({super.key});

  @override
  State<SignInWithGoogleRolePage> createState() => _SignInWithGoogleRolePageState();
}

class _SignInWithGoogleRolePageState extends State<SignInWithGoogleRolePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      setState(() => _isLoading = true);

      // Sign-out to ensure account picker is shown
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final firestore = FirebaseFirestore.instance;
        final userId = user.uid;

        // Check Firestore collections
        final collections = {
          'family': FamilyHomePage(),
          'alzheimer': AlzheimerHomePage(),
          'psychologist': PsyHomePage(),
        };

        for (var entry in collections.entries) {
          final doc = await firestore.collection(entry.key).doc(userId).get();
          if (doc.exists) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => entry.value),
            );
            // await _checkNotificationsAndNavigate(
            // context,
            // userId,
            // entry.key,
            // entry.value,
          //);
            return;
          }
        }

        // Navigate to user selection if no collection matches
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserSelectionPage()),
        );
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Google Sign-In failed. Please try again.'),
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }
  // Future<void> _showNotification(String title, String body) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'your_channel_id', // Replace with your channel ID
  //     'notifications', // Replace with your channel name
  //     channelDescription: 'This channel is for app notifications',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     sound: RawResourceAndroidNotificationSound('alert_sound'), // Custom sound
  //   );

  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     title,
  //     body,
  //     platformChannelSpecifics,
  //   );
  // }


  // Future<void> _checkNotificationsAndNavigate(
  //   BuildContext context,
  //   String userId,
  //   String role,
  //   Widget homeScreen,
  // ) async {
  // try {
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection(role)
  //       .doc(userId)
  //       .collection('notifications') // Subcollection for notifications
  //       .orderBy('timestamp', descending: true)
  //       .get();

  //   for (var doc in snapshot.docs) {
  //     final notification = doc.data();
  //     final bool isNew = notification['isNew'] ?? true;

  //     if (isNew) {
  //       // Show notification
  //       _showNotification(
  //         notification['type'] ?? 'Notification',
  //         notification['message'] ?? 'No message available.',
  //       );

  //       // Mark notification as read
  //       await doc.reference.update({'isNew': false});
  //     }
  //   }

    // Navigate to the user's home screen
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => homeScreen),
//     );
//   } catch (e) {
//     print("Error checking notifications: $e");
//   }
// }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
                        child: LogoImage(
                          imagePath: 'assets/images/login.png',
                          borderColor: null,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 10,
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
                    child: Column(
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: emailController,
                          text: "Email",
                          iconData: Icons.mail,
                          toHide: false,
                        ),
                        CustomTextField(
                          controller: passwordController,
                          text: "Password",
                          iconData: Icons.password,
                          toHide: true,
                        ),
                        // TextButton(
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => ForgetPasswordPage()));
                        //   },
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 150),
                        //     child: const Text(
                        //       "Forgotten password?",
                        //       style: TextStyle(
                        //           fontSize: 16,
                        //           color: Color.fromRGBO(95, 37, 133, 1.0),
                        //           fontWeight: FontWeight.w700),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 210,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!_isLoading) {
                                signInWithGoogle(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(95, 37, 133, 1.0),
                              side: BorderSide(color: Colors.grey, width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    color: Colors.black,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/google.png',
                                        height: 20.0,
                                        width: 20.0,
                                      ),
                                      SizedBox(width: 10.0),
                                      Text(
                                        'Sign in with Google',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}