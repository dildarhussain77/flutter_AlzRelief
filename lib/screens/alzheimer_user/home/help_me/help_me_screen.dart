
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpMePage extends StatefulWidget {
  const HelpMePage({super.key});

  @override
  State<HelpMePage> createState() => _HelpMePageState();
}

class _HelpMePageState extends State<HelpMePage> {
  String? _fullName;
  String? _phoneNumber;
  String? _familyPhoneNumber;
  String? _addressHome;
  String? _profileImageUrl;
  double _latitude = 0.0;
  double _longitude = 0.0;
  bool _isLoading = true;

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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
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
                         SizedBox(height: 10),                                                   
                        Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 65,
                                backgroundImage: _profileImageUrl != null
                                    ? NetworkImage(_profileImageUrl!) as ImageProvider
                                    : const AssetImage('assets/images/default_avatar.png'),
                                backgroundColor: Colors.grey[300],
                              ),                 
                              const SizedBox(height: 10.0),
                              // Text for Name
                              Text(
                                'Hi, ${_fullName ?? "not available"}!',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),                  
                      ],
                    ),
                  ),
                 // const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
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
      padding: const EdgeInsets.only(top: 8.0, left: 20.0, right: 20),
      children: [
        // Profile Header with Avatar
        
        const SizedBox(height: 10.0),

        // Text for Phone Number
        Text(
          'Your phone number is:',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(95, 37, 133, 1.0),
          ),
        ),
        _buildDetailRow(
          icon: Icons.phone,
          color: Colors.lightBlue,
         // title: 'Phone Number',
          value: _phoneNumber ?? 'Not Available',
        ),
        const Divider(),

        // Text for Family Phone Number
        Text(
          'Your family phone number is:',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(95, 37, 133, 1.0),
          ),
        ),
        _buildDetailRow(
          icon: Icons.family_restroom_sharp,
          color: Color(0xFFFFC107),
          //title: 'Family Phone Number',
          value: _familyPhoneNumber ?? 'Not Available',
        ),
        const Divider(),

        // Text for Home Address
        Text(
          'You live here:',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(95, 37, 133, 1.0),
          ),
        ),
        _buildDetailRow(
          icon: Icons.home,
          color: Colors.lightGreen,
          //title: 'Home Address',
          value: _addressHome ?? 'Not Available',
        ),
         SizedBox(height: 10,),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
              child: ElevatedButton.icon(
                onPressed: () => _openGoogleMaps(_latitude, _longitude), // Google Maps function (or empty if not used)
                icon: const Icon(Icons.my_location_sharp,color: Colors.white,),
                label: const Text("Open Home Location",style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  padding: EdgeInsets.symmetric(vertical: 13), // Adjust vertical padding to make it uniform
                ),
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // 80% of screen width
              child: ElevatedButton.icon(
                onPressed: () => _launchPhoneCall(_familyPhoneNumber),
                icon: const Icon(Icons.phone_in_talk, color: Colors.white,),
                label: const Text("Call to Family", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  padding: EdgeInsets.symmetric(vertical: 13), // Adjust vertical padding to make it uniform
                ),
              ),
            ),
            
          ],
        ),
      ],
    );
  }

// Helper Widget for Each Row
  Widget _buildDetailRow({
    required IconData icon,
    // required String title,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24.0),
          const SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [               
                const SizedBox(height: 5.0),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
   Future<void> _openGoogleMaps(double latitude, double longitude) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch Google Maps.");
    }
  }

// Function to Launch Phone Call
  Future<void> _launchPhoneCall(String? familyPhoneNumber) async {
    if (familyPhoneNumber != null && familyPhoneNumber.isNotEmpty) {
      final uri = Uri.parse('tel:$familyPhoneNumber');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print("Could not launch phone call.");
      }
    }
  }

}
