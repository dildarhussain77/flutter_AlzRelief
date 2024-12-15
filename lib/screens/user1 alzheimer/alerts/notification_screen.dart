import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates

class AlzheimerNotificationScreen extends StatefulWidget {
  const AlzheimerNotificationScreen({super.key});

  
  @override
  _AlzheimerNotificationScreenState createState() => _AlzheimerNotificationScreenState();
}

class _AlzheimerNotificationScreenState extends State<AlzheimerNotificationScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String title, String message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'alerts_channel', // Channel ID
    'Alerts', // Channel name
    channelDescription: 'This channel is used for alert notifications.',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('alert_sound'), // Custom sound file
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    title,
    message,
    platformChannelSpecifics,
  );
}

  // Fetch notifications as a list of maps
  Future<List<Map<String, dynamic>>> _fetchNotifications(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('alzheimer')
          .doc(userId)
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'type': data['type'],
          'message': data['message'],
          'timestamp': data['timestamp'],
        };
      }).toList();
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
          backgroundColor: const Color(0xFF5F2585),
        ),
        body: Center(
          child: Text(
            "You must be logged in to view notifications.",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(95, 37, 133, 1.0), // Purple background
        body: Column(
          children: [
            // Welcome row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7.0),
                      child: Text(
                        "Alerts",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Notification List
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 5,
                  right: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Light background for notifications
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchNotifications(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Error: ${snapshot.error}",
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "No notifications yet.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    final notifications = snapshot.data!;

                    return ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        // Check for 'alert' type and trigger sound notification
                          if (notification['type'].toLowerCase() == 'alert') {
                            _showNotification(
                              'Alert Notification',
                              notification['message'],
                            );
                          }
                        return NotificationCard(notification: notification);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    // Format timestamp
    final DateTime timestamp = notification['timestamp'].toDate();
    final String formattedTime = DateFormat('dd MMM yyyy, hh:mm a').format(timestamp);

    // Icon based on notification type
    IconData getIcon(String type) {
      switch (type.toLowerCase()) {
        case 'appointment':
          return Icons.event;
        case 'reminder':
          return Icons.notifications;
        case 'alert':
          return Icons.warning_amber_rounded;
        default:
          return Icons.info;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple.shade100,
          child: Icon(
            getIcon(notification['type']),
            color: const Color(0xFF5F2585),
          ),
        ),
        title: Text(
          notification['type'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: const Color(0xFF5F2585),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification['message'],
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              formattedTime,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
