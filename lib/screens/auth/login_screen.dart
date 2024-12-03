// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// // import 'package:alzrelief/screens/home_screen.dart';
// // import 'package:alzrelief/screens/signup_screen.dart';
// // import 'package:alzrelief/util/uihelper.dart';
// import 'package:alzrelief/screens/auth/forgotpassword_screen.dart';
// import 'package:alzrelief/screens/alzheimer_user/home/alz_home_screen.dart';
// import 'package:alzrelief/screens/family_user/Home/family_home.dart';
// import 'package:alzrelief/screens/psychologist_user/Home/psy_home_screen.dart';
// import 'package:alzrelief/screens/userselectionscreen.dart';
// import 'package:alzrelief/util/image_logo_helper.dart';
// import 'package:alzrelief/util/uihelper.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {

//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isLoading = false;


//   Future<void> signInWithGoogle(BuildContext context) async {
//     try {
//       setState(() {
//         _isLoading = true;
//       });

//       // Sign-out to show account picker
//       await _googleSignIn.signOut();

//       // User picks an account
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final userCredential = await _auth.signInWithCredential(credential);
//       final user = userCredential.user;

//       if (user != null) {
//         // Check all collections for the user
//         bool isRegistered = false;

//         // Firestore instance
//         final firestore = FirebaseFirestore.instance;

//         // Check in family collection
//         final familyDoc =
//             await firestore.collection('family').doc(user.uid).get();
//         if (familyDoc.exists) {
//           isRegistered = true;
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => FamilyHomePage()),
//           );
//           return;
//         }

//         // Check in alzheimer collection
//         final alzheimerDoc =
//             await firestore.collection('alzheimer').doc(user.uid).get();
//         if (alzheimerDoc.exists) {
//           isRegistered = true;
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => HomePage()),
//           );
//           return;
//         }

//         // Check in psychologist collection
//         final psychologistDoc =
//             await firestore.collection('psychologist').doc(user.uid).get();
//         if (psychologistDoc.exists) {
//           isRegistered = true;
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => PsyHomePage()),
//           );
//           return;
//         }

//         // If user is not found in any collection
//         if (!isRegistered) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => UserSelectionPage()),
//           );
//         }
//       }
//     } catch (e) {
//       print("Google Sign-In error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Google Sign-In failed. Please try again.'),
//       ));
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(      
//         backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
//         resizeToAvoidBottomInset: false,

//         body: SingleChildScrollView(
//           child: SizedBox(
//             height: MediaQuery.of(context).size.height,
//             child: Column(
//               //crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [    
                        
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
//                   child: Stack(                 
//                     children: [
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: IconButton(
//                             icon: Icon(Icons.arrow_back, color: Colors.white),
//                             onPressed: (){
//                               Navigator.pop(context);
//                             },
//                           ),
//                       ),
                                    
//                       Center(
//                         child: LogoImage(
//                           imagePath: 'assets/images/login.png',
//                           borderColor: null,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),                                                           
            
//                 Expanded(
//                   child: Container(                  
//                     padding: const EdgeInsets.only(
//                       top: 10,
//                       left: 5,
//                       right: 5,
//                     ),              
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(30.0),
//                         topRight: Radius.circular(30.0),
//                       )
//                     ),                                    
//                     child: Column(  
//                       children: [
//                         const Text("Login",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
//                         const SizedBox(height: 10,),
                            
//                         CustomTextField(controller: emailController, text: "Email", iconData: Icons.mail, toHide: false,),
//                         CustomTextField(controller: passwordController, text: "Password", iconData: Icons.password, toHide: true,),
                                        
//                         TextButton(onPressed: () { 
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordPage()));            
//                         }, 
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                               left: 150,
//                             ),
//                             child: Row(
//                               children: [
                                
//                                 const Text(
//                                   "Forgotten password?",  
//                                   style: TextStyle(
//                                     fontSize: 16, 
//                                     color: Color.fromRGBO(95, 37, 133, 1.0), 
//                                     fontWeight: FontWeight.w700),),
//                               ],
//                             ),
//                           ),
//                         ),                  
//                         const SizedBox(height: 15,),

                       
//                         Container(
//                           width: 210, // Same width as the first container
//                           child: ElevatedButton(
//                             onPressed: () {
//                               if (!_isLoading) {
//                                 signInWithGoogle(
//                                     context); // Reusing the onPressed logic
//                               }
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0), // Background color for the second container
//                               side: BorderSide(
//                                 color: Colors.grey,
//                                 width: 1, // Adding a border
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(20.0), // Rounded edges
//                               ),
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 10.0,
//                                 vertical: 10.0, // Padding adjustment
//                               ),
//                             ),
//                             child: 
//                             _isLoading
//                                 ? CircularProgressIndicator(
//                                     color: Colors
//                                         .black, // Black spinner color for visibility
//                                   )
//                                 : 
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.asset(
//                                   'assets/images/google.png', // Add Google logo to assets
//                                   height: 20.0,
//                                   width: 20.0, // Logo dimensions
//                                 ),
//                                 SizedBox(
//                                     width: 10.0), // Space between logo and text
//                                 Text(
//                                   'Sign in with Google',
//                                   style: TextStyle(
//                                     fontSize: 16.0, // Text size
//                                     color: Colors.white, // Black text color for the second design
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),                                       
//                         const SizedBox(height: 10),                  
//                         // Row(     
//                         //   mainAxisAlignment: MainAxisAlignment.center,
//                         //   children: [
//                         //     const Text("Create new account?", style: TextStyle(fontSize: 16, color: Colors.black),),
//                         //     TextButton(onPressed: () { 
//                         //       Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));            
//                         //     }, 
//                         //     child: const Text("Sign up", style: TextStyle(fontSize: 19, color: Color.fromRGBO(95, 37, 133, 1.0), fontWeight: FontWeight.w700),),
//                         //     ),
//                         //   ],                   
//                         // ),
//                       ]
//                     )
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:alzrelief/screens/alzheimer_user/home/alz_home_screen.dart';
import 'package:alzrelief/screens/auth/forgotpassword_screen.dart';
import 'package:alzrelief/screens/family_user/Home/family_home.dart';
import 'package:alzrelief/screens/psychologist_user/Home/psy_home_screen.dart';
import 'package:alzrelief/screens/userselectionscreen.dart';
import 'package:alzrelief/util/image_logo_helper.dart';
import 'package:alzrelief/util/uihelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgetPasswordPage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 150),
                            child: const Text(
                              "Forgotten password?",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(95, 37, 133, 1.0),
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
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