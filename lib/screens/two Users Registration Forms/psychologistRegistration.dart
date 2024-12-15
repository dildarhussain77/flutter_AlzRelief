import 'dart:io';

import 'package:alzrelief/screens/psychologist_user/Home/psy_home_screen.dart';
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

class Psychologist {
  final String fullName;
  final String phoneNumber;
  final String specialty;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String? profileImageUrl;
  final String description;  // New description field

  Psychologist({
    required this.fullName,
    required this.phoneNumber,
    required this.specialty,
    this.startTime,
    this.endTime,
    this.profileImageUrl,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,

      'specialty': specialty,
      'startTime': startTime != null
          ? '${startTime!.hour}:${startTime!.minute.toString().padLeft(2, '0')}'
          : null,
      'endTime': endTime != null
          ? '${endTime!.hour}:${endTime!.minute.toString().padLeft(2, '0')}'
          : null,
      'profileImageUrl': profileImageUrl,
      'description': description,  // Add description to the map
    };
  }
}

class PsychologistRegistrationScreen extends StatefulWidget {
  const PsychologistRegistrationScreen({super.key});

  @override
  _PsychologistRegistrationScreenState createState() =>
      _PsychologistRegistrationScreenState();
}

class _PsychologistRegistrationScreenState
    extends State<PsychologistRegistrationScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();


  String _selectedSpecialty = 'Clinical Psychologist';
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _profileImagePath;


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
          .child('psychologist_profiles/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _savePsychologistToFirestore(Psychologist psychologist) async {
    try {
      final userId = AuthHelper.currentUserId; // Get user ID using AuthHelper
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('psychologist')
            .doc(userId) // Use UID as the document ID
            .set(psychologist.toMap());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Psychologist registered successfully!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User not logged in. Please log in to continue.'),
        ));
      }
    } catch (e) {
      print('Error saving psychologist: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to register psychologist. Please try again.'),
      ));
    }
  }

  Future<void> _registerPsychologist() async {   

    String? profileImageUrl;
    if (_profileImagePath != null) {
      profileImageUrl = await _uploadImageToStorage(_profileImagePath!);
    }

    Psychologist psychologist = Psychologist(
      fullName: _firstNameController.text.trim(),
      phoneNumber: _phoneNoController.text.trim(),
      description: _descriptionController.text.trim(),  // Pass description to the Psychologist object
  
      specialty: _selectedSpecialty,
      startTime: _startTime,
      endTime: _endTime,
      profileImageUrl: profileImageUrl,
    );

    await _savePsychologistToFirestore(psychologist);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PsyHomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Psychologist Registration', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 5.0),
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
            SizedBox(height: 10.0),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]+')),
                LengthLimitingTextInputFormatter(30),
              ],
            ),
            SizedBox(height: 5.0),
            TextField(
              controller: _phoneNoController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                LengthLimitingTextInputFormatter(11),
              ],
            ),            
            SizedBox(height: 5.0),
            DropdownButtonFormField<String>(
              value: _selectedSpecialty,
              onChanged: (value) {
                setState(() {
                  _selectedSpecialty = value.toString();
                });
              },
              decoration: InputDecoration(labelText: 'Select Specialty'),
              items: <String>[
                'Clinical Psychologist',
                'Counseling Psychologist',
                'Educational Psychologist',
                'Forensic Psychologist',
                'Health Psychologist',
                'Neuropsychologist',
                'Child Psychologist',
                'Industrial-Organizational Psychologist',
                'Sports Psychologist',
                'Rehabilitation Psychologist',

              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 5.0),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Home Address',
              ),
              keyboardType: TextInputType.text,
              maxLines: 3,
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
            ),
            
            ListTile(
              title: Text(
                  'Start Time: ${_startTime != null ? _startTime!.format(context) : 'Not Set'}'),
              trailing: Icon(Icons.access_time),
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _startTime ?? TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    _startTime = picked;
                  });
                }
              },
            ),            
            ListTile(
              title: Text(
                  'End Time: ${_endTime != null ? _endTime!.format(context) : 'Not Set'}'),
              trailing: Icon(Icons.access_time),
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _endTime ?? TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    _endTime = picked;
                  });
                }
              },
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _registerPsychologist,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
              ),
              child: Text(
                'Register Psychologist',
                style: TextStyle(fontSize: 18.0,color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}