import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Psychologist {
  final String id;
  final String fullName;
  // final String phoneNumber;
  final String specialty;
  final String description;
  final String? profileImageUrl;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  Psychologist({
    required this.id,
    required this.fullName,
    // required this.phoneNumber,
    required this.specialty,
    required this.description,
    this.profileImageUrl,
    this.startTime,
    this.endTime,
  });

  factory Psychologist.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Psychologist(
      id: doc.id,
      fullName: data['fullName'] ?? '',
      // phoneNumber: data['phoneNumber'] ?? '',
      specialty: data['specialty'] ?? '',
      description: data['description'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      startTime: data['startTime'] != null
          ? TimeOfDay(
              hour: int.parse(data['startTime'].split(':')[0]),
              minute: int.parse(data['startTime'].split(':')[1]),
            )
          : null,
      endTime: data['endTime'] != null
          ? TimeOfDay(
              hour: int.parse(data['endTime'].split(':')[0]),
              minute: int.parse(data['endTime'].split(':')[1]),
            )
          : null,
    );
  }
}
