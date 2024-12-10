import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PsychologistProfilePage extends StatefulWidget {
  const PsychologistProfilePage({super.key});

  @override
  State<PsychologistProfilePage> createState() =>
      _PsychologistProfilePageState();
}

class _PsychologistProfilePageState extends State<PsychologistProfilePage> {
  String? _fullName;
  String? _phoneNumber;
  String? _profileImageUrl;
  String? _selectedSpecialty;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _description;

  bool _isLoading = true;

  // Controllers to manage the text inputs
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  // List of all specialties
  final List<String> _specialties = [
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
  ];

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
            .collection('psychologist')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          setState(() {
            _fullName = doc['fullName'];
            _phoneNumber = doc['phoneNumber'];
            _profileImageUrl = doc['profileImageUrl'];
            _selectedSpecialty = doc['specialty'];
            _description = doc['description'];
            _startTime = _parseTime(doc['startTime']);
            _endTime = _parseTime(doc['endTime']);
            _isLoading = false;

            // Initialize controllers with existing data
            _fullNameController.text = _fullName ?? '';
            _phoneNumberController.text = _phoneNumber ?? '';
            _descriptionController.text = _description ?? '';
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

  TimeOfDay? _parseTime(String? time) {
    if (time == null || time.isEmpty) return null;
    final parts = time.split(':');
    if (parts.length == 2) {
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      return TimeOfDay(hour: hour, minute: minute);
    }
    return null;
  }

  Future<void> _saveProfileData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('psychologist')
            .doc(user.uid)
            .update({
          'fullName': _fullNameController.text,
          'phoneNumber': _phoneNumberController.text,
          'description': _descriptionController.text,
          'specialty': _selectedSpecialty,
          'startTime': _startTime != null
              ? '${_startTime!.hour}:${_startTime!.minute.toString().padLeft(2, '0')}'
              : null,
          'endTime': _endTime != null
              ? '${_endTime!.hour}:${_endTime!.minute.toString().padLeft(2, '0')}'
              : null,
          'profileImageUrl': _profileImageUrl,
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

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImageUrl = pickedFile.path;
      });
    }
  }

  Future<void> _pickTime(bool isStartTime) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (_startTime ?? TimeOfDay.now())
          : (_endTime ?? TimeOfDay.now()),
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildHeader(),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
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
                
                onTap: _pickImage,
                child: CircleAvatar(                                    
                  radius: 70,
                  backgroundImage: _profileImageUrl != null &&
                          _profileImageUrl!.isNotEmpty
                      ? FileImage(File(_profileImageUrl!))
                      : const AssetImage('assets/images/default_avatar.png')
                          as ImageProvider<Object>,
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
    );
  }

  Widget _buildProfileDetails() {
    return ListView(
      padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20),
      children: [
        Center(
          child: Column(
            children: [                            
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  labelStyle:
                      TextStyle(color: Color.fromRGBO(95, 37, 133, 1.0)),
                ),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]+')),
                  LengthLimitingTextInputFormatter(30),
                ],
              ),
              const SizedBox(height: 5.0),
            ],
          ),
        ),
        TextField(
          controller: _phoneNumberController,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            labelStyle: TextStyle(color: Color.fromRGBO(95, 37, 133, 1.0)),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            LengthLimitingTextInputFormatter(11),
          ],
        ),
        
        _buildSpecialtyDropdown(),

        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',  
            labelStyle: TextStyle(color: Color.fromRGBO(95, 37, 133, 1.0)),            
          ),
          keyboardType: TextInputType.text,
          maxLines: 3,  // Adjust this to allow more or fewer lines
          inputFormatters: [
            LengthLimitingTextInputFormatter(100),  // Maximum characters
          ],
        ),
        
        _buildTimePickerRow("Start Time", _startTime, true),
        
        _buildTimePickerRow("End Time", _endTime, false),
        const SizedBox(height: 10.0),

        ElevatedButton(
          onPressed: _saveProfileData,
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0)),
          child: const Text('Save Changes',
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildSpecialtyDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedSpecialty,
      decoration: const InputDecoration(
        labelText: "Specialty",
        labelStyle: TextStyle(color: Color.fromRGBO(95, 37, 133, 1.0)),
      ),
      items: _specialties
          .map((specialty) => DropdownMenuItem(
                value: specialty,
                child: Text(specialty),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedSpecialty = value;
        });
      },
    );
  }

  Widget _buildTimePickerRow(
      String label, TimeOfDay? selectedTime, bool isStartTime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () => _pickTime(isStartTime),
          child: Text(
            selectedTime != null
                ? '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}'
                : 'Pick Time',
          ),
        ),
      ],
    );
  }
}
