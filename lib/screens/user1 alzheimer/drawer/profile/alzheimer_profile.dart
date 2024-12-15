import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';  // Import image_picker package

class AlzheimerProfilePage extends StatefulWidget {
  const AlzheimerProfilePage({super.key});

  @override
  State<AlzheimerProfilePage> createState() => _AlzheimerProfilePageState();
}

class _AlzheimerProfilePageState extends State<AlzheimerProfilePage> {
  String? _fullName;
  String? _phoneNumber;
  String? _familyPhoneNumber;
  String? _addressHome;
  String? _profileImageUrl;
  bool _isLoading = true;

  // Controllers to manage the text inputs
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _familyPhoneNumberController = TextEditingController();
  final TextEditingController _addressHomeController = TextEditingController();
  final TextEditingController _profileImageUrlController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  double _latitude = 0.0;
  double _longitude = 0.0;

  final ImagePicker _picker = ImagePicker();  // ImagePicker instance

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
          _phoneNumber = doc['phoneNumber'];
          _familyPhoneNumber = doc['familyPhoneNumber'];
          _addressHome = doc['addressHome'];
          _profileImageUrl = doc['profileImageUrl'];
          _latitude = doc['latitude'];
          _longitude = doc['longitude'];
          _isLoading = false;

          // Initialize controllers with existing data
          _fullNameController.text = _fullName ?? '';
          _phoneNumberController.text = _phoneNumber ?? '';
          _familyPhoneNumberController.text = _familyPhoneNumber ?? '';
          _addressHomeController.text = _addressHome ?? '';
          _profileImageUrlController.text = _profileImageUrl ?? '';
          _latitudeController.text = _latitude.toString();
          _longitudeController.text = _longitude.toString();
        });
      }
    } catch (e) {
      print('Error fetching profile data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  Future<void> _saveProfileData() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      await FirebaseFirestore.instance
          .collection('alzheimer')
          .doc(user.uid)
          .update({
        'fullName': _fullNameController.text,
        'phoneNumber': _phoneNumberController.text,
        'familyPhoneNumber': _familyPhoneNumberController.text,
        'addressHome': _addressHomeController.text,
        'profileImageUrl': _profileImageUrlController.text,
        'latitude': double.parse(_latitudeController.text),
        'longitude': double.parse(_longitudeController.text),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      print('Error updating profile data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }
}


  // Add this method to pick an image
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);  // Pick image from gallery

    if (pickedFile != null) {
      setState(() {
        _profileImageUrl = pickedFile.path;  // Save the picked image path
        _profileImageUrlController.text = _profileImageUrl ?? '';  // Update the text controller
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        body: _isLoading
      ? Center(child: CircularProgressIndicator())
      : Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Center(
                    child: Text(
                      "Edit Profile", style: TextStyle(
                        color: Colors.white, fontSize: 24, 
                        fontWeight: FontWeight.bold),
                    )
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Center(
                      
                      child: GestureDetector(
                        onTap: _pickImage,  // Make the avatar clickable
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                              ? FileImage(File(_profileImageUrl!)) as ImageProvider
                              : const AssetImage('assets/images/default_avatar.png') as ImageProvider<Object>,
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                            size: 50.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: _buildProfileDetails(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetails() {
    return ListView(
      padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20),
      children: [        
        
        TextField(
          controller: _fullNameController,
          decoration: InputDecoration(
            labelText: "Full Name",
            labelStyle: TextStyle(color: Color.fromRGBO(95, 37, 133, 1.0)),
          ),
          keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]+')),
          LengthLimitingTextInputFormatter(30),
        ],
          //style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5.0),

        // Profile Details List
        TextField(
          controller: _phoneNumberController,
          decoration: InputDecoration(labelText: 'Phone Number'),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            LengthLimitingTextInputFormatter(11),
          ],
        ),
        
        TextField(
          controller: _familyPhoneNumberController,
          decoration: InputDecoration(labelText: 'Family Phone Number'),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            LengthLimitingTextInputFormatter(11),
          ],
        ),
        
        TextFormField(
          controller: _addressHomeController,
          decoration: InputDecoration(
            labelText: 'Home Address',              
          ),
          keyboardType: TextInputType.text,
          maxLines: 3,  // Adjust this to allow more or fewer lines
          inputFormatters: [
            LengthLimitingTextInputFormatter(100),  // Maximum characters
          ],
        ),
            // Save Button
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ElevatedButton(
            onPressed: _saveProfileData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(95, 37, 133, 1.0),
            ),
            child: const Text('Save Changes',style: TextStyle(color: Colors.white),),
          ),
        ),
        Divider(),
        Text("Your home location coordinates are:", style: TextStyle(color: Color.fromRGBO(95, 37, 133, 1.0)),),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _latitudeController,
                decoration: InputDecoration(
                  labelText: 'Latitude',
                  labelStyle: TextStyle(color: Color.fromRGBO(95, 37, 133, 1.0)),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              ),
            ),                
            Expanded(
              child: TextField(
                controller: _longitudeController,
                decoration: InputDecoration(                      
                  labelText: 'Longitude',
                  labelStyle: TextStyle(color: Color.fromRGBO(95, 37, 133, 1.0)),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              ),
            ),
          ]
        ),


        ElevatedButton(
          onPressed: () async {
            try {
              // Fetch the current location
              Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

              // Update the local state with the new latitude and longitude
              setState(() {
                _latitude = position.latitude;
                _longitude = position.longitude;
                _latitudeController.text = _latitude.toString();
                _longitudeController.text = _longitude.toString();
              });

              // Get the current user
              final user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                // Update the latitude and longitude in Firebase
                await FirebaseFirestore.instance
                    .collection('alzheimer')
                    .doc(user.uid)
                    .update({
                  'latitude': _latitude,
                  'longitude': _longitude,
                });

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Location updated successfully')),
                );
              } else {
                // Handle case where user is not logged in
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User not logged in')),
                );
              }
            } catch (e) {
              // Handle errors and show a failure message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to update location: $e')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(95, 37, 133, 1.0),
          ),
          child: Text(
            'Update Home Location',
            style: TextStyle(color: Colors.white),
          ),
        ),

        
      ],
    );
  }
}
