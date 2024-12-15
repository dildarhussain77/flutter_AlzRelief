// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfileImageService {
//   static Future<String?> uploadProfileImage(File imageFile) async {
//     try {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId == null) return null;

//       // Create a unique path for the image
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('family_profiles/$userId/profile_image.jpg');

//       // Upload the image
//       await storageRef.putFile(imageFile);

//       // Get the download URL
//       final downloadURL = await storageRef.getDownloadURL();
      
//       // Update Firestore with the image URL
//       await FirebaseFirestore.instance
//           .collection('family')
//           .doc(userId)
//           .update({
//         'profileImageUrl': downloadURL,
//         'hasProfileImage': true
//       });

//       return downloadURL;
//     } catch (e) {
//       print('Error uploading profile image: $e');
//       return null;
//     }
//   }

//   static Future<String?> getProfileImageUrl() async {
//     try {
//       final userId = FirebaseAuth.instance.currentUser?.uid;
//       if (userId == null) return null;

//       // Fetch the document
//       final docSnapshot = await FirebaseFirestore.instance
//           .collection('family')
//           .doc(userId)
//           .get();

//       // Return the profile image URL
//       return docSnapshot.data()?['profileImageUrl'];
//     } catch (e) {
//       print('Error fetching profile image: $e');
//       return null;
//     }
//   }

//   static Widget buildProfileImage({
//     double width = 150, 
//     double height = 150, 
//     BoxFit fit = BoxFit.cover
//   }) {
//     return FutureBuilder<String?>(
//       future: getProfileImageUrl(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(
//               color: Theme.of(context).primaryColor,
//             )
//           );
//         }

//         if (snapshot.hasData && snapshot.data != null) {
//           return Image.network(
//             snapshot.data!,
//             width: width,
//             height: height,
//             fit: fit,
//             errorBuilder: (context, error, stackTrace) {
//               return _defaultProfileIcon(width, height);
//             },
//           );
//         }

//         return _defaultProfileIcon(width, height);
//       },
//     );
//   }

//   static Widget _defaultProfileIcon(double width, double height) {
//     return Container(
//       width: width,
//       height: height,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.grey[300],
//       ),
//       child: Icon(
//         Icons.person,
//         size: width * 0.6,
//         color: Colors.white,
//       ),
//     );
//   }
// }