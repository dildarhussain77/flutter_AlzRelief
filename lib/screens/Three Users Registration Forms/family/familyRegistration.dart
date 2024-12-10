import 'dart:io';
import 'package:alzrelief/screens/family_user/Home/family_home.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthHelper {
  static String? get currentUserId {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid; // Returns null if the user is not logged in
  }
}

class Family {
  final String fullName;
  final String phoneNumber;
  final String relationWithAlzheimer;
  final String? profileImageUrl;

  Family({
    required this.fullName,
    required this.phoneNumber,
    required this.relationWithAlzheimer,  
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'relationWithAlzheimer': relationWithAlzheimer,     
      'profileImageUrl': profileImageUrl != null && profileImageUrl!.isNotEmpty 
          ? profileImageUrl 
          : null, // Store null if no image URL
    };
  }
}

class FamilyRegistrationScreen extends StatefulWidget {
  const FamilyRegistrationScreen({super.key});

  @override
  _FamilyRegistrationScreenState createState() =>
      _FamilyRegistrationScreenState();
}

class _FamilyRegistrationScreenState
    extends State<FamilyRegistrationScreen> {

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _relationWithAlzheimerController = TextEditingController();
  final TextEditingController _profileImageUrlController = TextEditingController();

  final ImagePicker picker = ImagePicker();  // ImagePicker instance

  String? _profileImagePath;
  bool _isLoading = false;

  Future<void> _getImageFromGallery() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _profileImagePath = pickedImage.path;
        _profileImageUrlController.text = _profileImagePath ?? '';  // Update the text controller
      });
    }
  }

  Future<String?> _uploadImageToStorage(String imagePath) async {
    try {
      final file = File(imagePath);
      final userId = AuthHelper.currentUserId;
      
      if (userId == null) {
        print('User not logged in');
        return null;
      }

      // Create a more specific path for the image
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('family_profiles/$userId/${DateTime.now().millisecondsSinceEpoch}');
      
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _saveFamilyToFirestore(Family family) async {
  try {
    final userId = AuthHelper.currentUserId;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('family')
          .doc(userId)
          .set({
        ...family.toMap(), // Spread the existing family map
        'registrationComplete': true, // Add this field
        'role': 'family', // Add role field if needed
        'userId': userId, // Ensure user ID is stored
      }, SetOptions(merge: true));
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Family registered successfully!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User not logged in. Please log in to continue.'),
      ));
    }
  } catch (e) {
    print('Error saving family: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Failed to register family. Please try again.'),
    ));
  }
}


  Future<void> _registerFamily() async {
  // Validate input fields
  if (_firstNameController.text.trim().isEmpty ||
      _phoneNoController.text.trim().isEmpty ||
      _relationWithAlzheimerController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Please fill in all fields'),
    ));
    return;
  }

  setState(() {
    _isLoading = true;
  });

  String? profileImageUrl;
  if (_profileImagePath != null) {
    profileImageUrl = await _uploadImageToStorage(_profileImagePath!);
  }

  Family family = Family(
    fullName: _firstNameController.text.trim(),
    phoneNumber: _phoneNoController.text.trim(),
    relationWithAlzheimer: _relationWithAlzheimerController.text.trim(),  
    profileImageUrl: profileImageUrl,
  );

  // Modify the Firestore save method to include additional fields
  await _saveFamilyToFirestore(family);

  setState(() {
    _isLoading = false;
  });

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => FamilyHomePage(),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Registration'),
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: _getImageFromGallery,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: _profileImagePath == null
                        ? Icon(
                            Icons.person,
                            size: 100.0,
                            color: Colors.white,
                          )
                        : ClipOval(
                            child: Image.file(
                              File(_profileImagePath!),
                              width: 150.0,
                              height: 150.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                    size: 50.0,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]+')),
                LengthLimitingTextInputFormatter(30),
              ],
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _phoneNoController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                LengthLimitingTextInputFormatter(11),
              ],
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _relationWithAlzheimerController,
              decoration: InputDecoration(labelText: 'Relation with Alzheimer'),
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]+')),
                LengthLimitingTextInputFormatter(30),
              ],
            ),                                            
                  
            SizedBox(height: 20.0),
            _isLoading 
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _registerFamily,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
                  ),
                  child: Text(
                    'Register Family',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
