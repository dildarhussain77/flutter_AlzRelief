
import 'dart:io';
import 'package:alzrelief/screens/user1%20alzheimer/home/alz_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthHelper {
  static String? get currentUserId {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid; // Returns null if the user is not logged in
  }
}

class Alzheimer {
  final String fullName;
  final String phoneNumber;
  final String familyPhoneNumber;
  final String addressHome;
  final double latitude;
  final double longitude;
  final String? profileImageUrl;

  Alzheimer({
    required this.fullName,
    required this.phoneNumber,
    required this.familyPhoneNumber,
    required this.addressHome,
    required this.latitude,
    required this.longitude,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'familyPhoneNumber': familyPhoneNumber,
      'addressHome': addressHome,
      'latitude': latitude,
      'longitude': longitude,
      'profileImageUrl': profileImageUrl,
    };
  }
}

class AlzheimerRegistration extends StatefulWidget {
  const AlzheimerRegistration({super.key});

  @override
  _AlzheimerRegistrationState createState() => _AlzheimerRegistrationState();
}

class _AlzheimerRegistrationState extends State<AlzheimerRegistration> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _familyPhoneNoController = TextEditingController();
  final TextEditingController _addressHomeController = TextEditingController();
  
  String? _profileImagePath;
  double _latitude = 0.0;
  double _longitude = 0.0;

  //final ImagePicker _picker = ImagePicker();  

   // Method to pick image from gallery
  // Future<void> _pickImage() async {
  //   final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);  // Pick image from gallery
  //   if (pickedFile != null) {
  //     setState(() {
  //       _profileImagePath = pickedFile.path;
  //     });
  //   }
  // }
 


  // Function to get permission and location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location services are disabled.")),
      );
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location permission is denied.")),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

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
          .child('alzheimer_profiles/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(file);
final snapshot = await uploadTask.whenComplete(() => null);

      //log(snapshot.toString());
       
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    
  
    print('Image uploaded successfully, URL: $downloadUrl'); 
    return downloadUrl;
      
    //return await snapshot.ref.getDownloadURL();
    
    // return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Save Alzheimer details to Firestore
  Future<void> _saveAlzheimerToFirestore(Alzheimer alzheimer) async {
    try {
      final userId = AuthHelper.currentUserId;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('alzheimer')
            .doc(userId)
            .set(alzheimer.toMap());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Alzheimer registered successfully!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User not logged in. Please log in to continue.'),
        ));
      }

      if (alzheimer.profileImageUrl != null) {
        await FirebaseFirestore.instance
            .collection('alzheimer')
            .doc(userId)
            .set(alzheimer.toMap());
      } else {
        // Handle the case where there's no image URL (optional)
        print('No image uploaded for this Alzheimer record.');
      }
    } catch (e) {
      print('Error saving Alzheimer: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to register Alzheimer. Please try again.'),
      ));
    }
  }

  // Register Alzheimer
  Future<void> _registerAlzheimer() async {
    // Validate fields
    if (_fullNameController.text.isEmpty ||
        _phoneNoController.text.isEmpty ||
        _familyPhoneNoController.text.isEmpty ||
        _addressHomeController.text.isEmpty ||      
        _latitude == 0.0 ||
        _longitude == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('All fields are required.'),
      ));
      return;
    }

    String? profileImageUrl;
    if (_profileImagePath != null) {
      profileImageUrl = await _uploadImageToStorage(_profileImagePath!);
    }

    Alzheimer alzheimer = Alzheimer(
      fullName: _fullNameController.text.trim(),
      phoneNumber: _phoneNoController.text.trim(),
      familyPhoneNumber: _familyPhoneNoController.text.trim(),
      addressHome: _addressHomeController.text.trim(),
      latitude: _latitude,
      longitude: _longitude,
      profileImageUrl: profileImageUrl,
    );

    await _saveAlzheimerToFirestore(alzheimer);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AlzheimerHomePage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initial location fetch
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
   // final screenHeight = MediaQuery.of(context).size.height;
    // Scaling factors
    double paddingScale = screenWidth / 375.0; // Base width for scaling
   // double textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      appBar: AppBar(
        title: Text('Alzheimer Registration', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        iconTheme: IconThemeData(color: Colors.white),
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
                    width: 150.0 * paddingScale,
                    height: 150.0 * paddingScale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: _profileImagePath == null
                        ? Icon(
                            Icons.person,
                            size: 100.0 * paddingScale,
                            color: Colors.white,
                          )
                        : ClipOval(
                            child: Image.file(
                              File(_profileImagePath!),
                              width: 150.0 * paddingScale,
                              height: 150.0 * paddingScale,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                    size: 50.0 * paddingScale,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _fullNameController,
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
              controller: _familyPhoneNoController,
              decoration: InputDecoration(labelText: 'Family Phone Number'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                LengthLimitingTextInputFormatter(11),
              ],
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: _addressHomeController,
              decoration: InputDecoration(
                labelText: 'Home Address',
              ),
              keyboardType: TextInputType.text,
              maxLines: 3,
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
            ),
            SizedBox(height: 20.0),
            // Button to get current location
            ElevatedButton(
              onPressed: _getCurrentLocation,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
              ),
              child: Text('Get current Location',style: TextStyle(fontSize: 16.0, color: Colors.white),),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _registerAlzheimer,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
              ),
              child: Text(
                'Register Alzheimer',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to pick an image from the gallery
  // Future<void> _getImageFromGallery() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _profileImagePath = pickedFile.path;
  //     });
  //   }
  // }
}
