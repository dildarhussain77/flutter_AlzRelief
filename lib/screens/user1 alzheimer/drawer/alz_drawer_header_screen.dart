// ignore_for_file: unnecessary_const, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AlzheimerDrawerHeaderPage extends StatefulWidget {
  const AlzheimerDrawerHeaderPage({super.key});

  @override
  State<AlzheimerDrawerHeaderPage> createState() => _AlzheimerDrawerHeaderPageState();
}

class _AlzheimerDrawerHeaderPageState extends State<AlzheimerDrawerHeaderPage> {

  String? _fullName;
  String? _phoneNumber;
  String? _profileImageUrl;
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
            _profileImageUrl = doc['profileImageUrl'];
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

    return Container(
      color: Color.fromRGBO(95, 37, 133, 1.0),
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 10),
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
           _isLoading
            ? Center(child: CircularProgressIndicator())
            :
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImageUrl != null
                      ? NetworkImage(_profileImageUrl!) as ImageProvider
                      :  AssetImage('assets/images/default_avatar.png'),
                  backgroundColor: Colors.grey[300],
                ),
                 SizedBox(height: 15.0),
                Text(
                  _fullName ?? 'User Name',
                  style:  TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _phoneNumber ?? 'User number',
                  style:  TextStyle(
                    fontSize: 14.0,                  
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          //Text('Dildar Hussain Bhutto', style: TextStyle(color: Colors.white, fontSize: 20,),),
          //Text('dildarali99999@gmail.com', style: TextStyle(color: Colors.grey[200] ,fontSize: 14),),
        ],
      ),      
    );
  }  
}
