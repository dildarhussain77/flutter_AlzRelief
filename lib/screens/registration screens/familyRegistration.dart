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
  // final double latitude;
  // final double longitude;
  // final String specialty;
  // final TimeOfDay? startTime;
  // final TimeOfDay? endTime;
  final String? profileImageUrl;

  Family({
    required this.fullName,
    required this.phoneNumber,
    // required this.latitude,
    // required this.longitude,
    // required this.specialty,
    // this.startTime,
    // this.endTime,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      // 'latitude': latitude,
      // 'longitude': longitude,
      // 'specialty': specialty,
      // 'startTime': startTime != null
      //     ? '${startTime!.hour}:${startTime!.minute.toString().padLeft(2, '0')}'
      //     : null,
      // 'endTime': endTime != null
      //     ? '${endTime!.hour}:${endTime!.minute.toString().padLeft(2, '0')}'
      //     : null,
      'profileImageUrl': profileImageUrl,
    };
  }
}

class FamilyRegistrationScreen extends StatefulWidget {
  @override
  _FamilyRegistrationScreenState createState() =>
      _FamilyRegistrationScreenState();
}

class _FamilyRegistrationScreenState
    extends State<FamilyRegistrationScreen> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();
  //TextEditingController _locationController = TextEditingController();
  //final LocationService _locationService = LocationService();

  // double? _latitude;
  // double? _longitude;
  // String _selectedSpecialty = 'Clinical Psychologist';
  // TimeOfDay? _startTime;
  // TimeOfDay? _endTime;
  String? _profileImagePath;

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchLocation();
  // }

  // Future<void> _fetchLocation() async {
  //   final location = await _locationService.getLocation();
  //   if (location != null &&
  //       location.latitude != null &&
  //       location.longitude != null) {
  //     final locationName = await _locationService.getLocationName(
  //         location.latitude!, location.longitude!);
  //     setState(() {
  //       _latitude = location.latitude!;
  //       _longitude = location.longitude!;
  //       _locationController.text =
  //           locationName.isNotEmpty ? locationName : 'Enter your location';
  //     });
  //   }
  // }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _profileImagePath = pickedImage.path;
      });
    }
  }

  Future<String?> _uploadImageToStorage(String imagePath) async {
    try {
      final file = File(imagePath);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('family_profiles/${DateTime.now().millisecondsSinceEpoch}');
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
      final userId = AuthHelper.currentUserId; // Get user ID using AuthHelper
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('family')
            .doc(userId) // Use UID as the document ID
            .set(family.toMap());
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
    // if (_latitude == null || _longitude == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text('Failed to get location. Please try again.'),
    //   ));
    //   return;
    // }

    String? profileImageUrl;
    if (_profileImagePath != null) {
      profileImageUrl = await _uploadImageToStorage(_profileImagePath!);
    }

    Family family = Family(
      fullName: _firstNameController.text.trim(),
      phoneNumber: _phoneNoController.text.trim(),
      // latitude: _latitude!,
      // longitude: _longitude!,
      // specialty: _selectedSpecialty,
      // startTime: _startTime,
      // endTime: _endTime,
      profileImageUrl: profileImageUrl,
    );

    await _saveFamilyToFirestore(family);

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
        backgroundColor: Color.fromARGB(255, 93, 250, 103),
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
            // TextFormField(
            //   controller: _locationController,
            //   readOnly: true,
            //   decoration: InputDecoration(
            //     labelText: 'Location',
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            // ),
            SizedBox(height: 10.0),
            // DropdownButtonFormField<String>(
            //   value: _selectedSpecialty,
            //   onChanged: (value) {
            //     setState(() {
            //       _selectedSpecialty = value.toString();
            //     });
            //   },
            //   decoration: InputDecoration(labelText: 'Select Specialty'),
            //   items: <String>[
            //     'Clinical Psychologist',
            //     'Counseling Psychologist',
            //     'Educational Psychologist',
            //     'Forensic Psychologist',
            //     'Health Psychologist',
            //     'Neuropsychologist',
            //     'Child Psychologist',
            //     'Industrial-Organizational Psychologist',
            //     'Sports Psychologist',
            //     'Rehabilitation Psychologist',

            //   ].map<DropdownMenuItem<String>>((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            // ),
            SizedBox(height: 20.0),
            // ListTile(
            //   title: Text(
            //       'Start Time: ${_startTime != null ? _startTime!.format(context) : 'Not Set'}'),
            //   trailing: Icon(Icons.access_time),
            //   onTap: () async {
            //     final TimeOfDay? picked = await showTimePicker(
            //       context: context,
            //       initialTime: _startTime ?? TimeOfDay.now(),
            //     );
            //     if (picked != null) {
            //       setState(() {
            //         _startTime = picked;
            //       });
            //     }
            //   },
            // ),
            SizedBox(height: 10.0),
            // ListTile(
            //   title: Text(
            //       'End Time: ${_endTime != null ? _endTime!.format(context) : 'Not Set'}'),
            //   trailing: Icon(Icons.access_time),
            //   onTap: () async {
            //     final TimeOfDay? picked = await showTimePicker(
            //       context: context,
            //       initialTime: _endTime ?? TimeOfDay.now(),
            //     );
            //     if (picked != null) {
            //       setState(() {
            //         _endTime = picked;
            //       });
            //     }
            //   },
            // ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _registerFamily,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                backgroundColor: Color.fromARGB(255, 91, 199, 255),
              ),
              child: Text(
                'Register Family',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}