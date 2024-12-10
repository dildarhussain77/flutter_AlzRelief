// import 'package:cloud_firestore/cloud_firestore.dart';

// class NotificationModel {
//   final String type;
//   final String message;
//   final Timestamp timestamp;

//   NotificationModel({required this.type, required this.message, required this.timestamp});

//   factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return NotificationModel(
//       type: data['type'],
//       message: data['message'],
//       timestamp: data['timestamp'],
//     );
//   }
// }
