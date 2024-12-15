import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';  // Import image_picker package

class FamilyProfilePage extends StatefulWidget {
  const FamilyProfilePage({super.key});

  @override
  State<FamilyProfilePage> createState() => _FamilyProfilePageState();
}

class _FamilyProfilePageState extends State<FamilyProfilePage> {
  String? _fullName;
  String? _phoneNumber;
  String? _relationWithAlzheimer;
  String? _profileImageUrl;
  bool _isLoading = true;

  // Controllers to manage the text inputs
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _relationWithAlzheimerController = TextEditingController();
  final TextEditingController _profileImageUrlController = TextEditingController();

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
            .collection('family')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          setState(() {
            _fullName = doc['fullName'];
            _phoneNumber = doc['phoneNumber'];            
            _relationWithAlzheimer = doc['relationWithAlzheimer'];
            _profileImageUrl = doc['profileImageUrl'];
            _isLoading = false;

            // Initialize controllers with existing data
            _fullNameController.text = _fullName ?? '';
            _phoneNumberController.text = _phoneNumber ?? '';            
            _relationWithAlzheimerController.text = _relationWithAlzheimer ?? '';
            _profileImageUrlController.text = _profileImageUrl ?? '';
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
            .collection('family')
            .doc(user.uid)
            .update({
          'fullName': _fullNameController.text,
          'phoneNumber': _phoneNumberController.text,          
          'relationWithAlzheimer': _relationWithAlzheimerController.text,
          'profileImageUrl': _profileImageUrlController.text,
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
        // Profile Header with Avatar
        Center(
          child: Column(
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
            ],
          ),
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
          controller: _relationWithAlzheimerController,
          decoration: InputDecoration(
            labelText: "Relation with Alzheimer",
            labelStyle: TextStyle(color: Color.fromRGBO(95, 37, 133, 1.0)),
          ),
          keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]+')),
          LengthLimitingTextInputFormatter(30),
        ],
          //style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
      ],
    );
  }
}