import 'package:alzrelief/screens/users%20chat/add%20appointments/add_schedules.dart';
import 'package:alzrelief/screens/users%20chat/video_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatScreen extends StatefulWidget {
  final String userId; // Current user's ID
  final String peerId; // Other user's ID
  final String peerName; // Other user's Name
  final bool isPsychologist; // If true, current user is psychologist

  const ChatScreen({
    super.key,
    required this.userId,
    required this.peerId,
    required this.peerName,
    required this.isPsychologist,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

 // Request Permissions and Start Video Call
  Future<void> _startVideoCall() async {
  try {
    // Request camera and microphone permissions
    final cameraPermission = await Permission.camera.request();
    final microphonePermission = await Permission.microphone.request();

    if (!cameraPermission.isGranted || !microphonePermission.isGranted) {
      _showPermissionDeniedDialog();
      return;
    }

    // Notify the other user to join (via push notification or message)
    // This could involve sending a message that says "video call request"
    // Notify the other user about the video call
    await notifyVideoCall();

    // Now, navigate to the VideoCallPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoCallPage(
          userId: widget.userId, 
          peerId: widget.peerId
        ),
      ),
    );

    
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error initiating video call: $e')),
    );
  }
}
Future<void> notifyVideoCall() async {
  final chatMessage = {
    "message": "Video call initiated",
    "senderId": widget.userId,
    "receiverId": widget.peerId,
    "timestamp": FieldValue.serverTimestamp(),
    "type": "videoCall", // Add a type field to differentiate
  };

  await getChatCollection().add(chatMessage);
}


  // Show Permission Denied Dialog
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text('Camera and microphone permissions are needed for video calls.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Get chat reference based on the current user's role
  CollectionReference getChatCollection() {
    if (widget.isPsychologist) {
      return FirebaseFirestore.instance
          .collection('psychologist')
          .doc(widget.userId)
          .collection('appointedAlzheimers')
          .doc(widget.peerId)
          .collection('chats');
    } else {
      return FirebaseFirestore.instance
          .collection('alzheimer')
          .doc(widget.userId)
          .collection('appointedPsychologists')
          .doc(widget.peerId)
          .collection('chats');
    }
  }

  // Send message
  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final timestamp = FieldValue.serverTimestamp();
    final chatMessage = {
      "message": message.trim(),
      "senderId": widget.userId,
      "receiverId": widget.peerId,
      "timestamp": timestamp,
      "isRead": false, // Initially, set isRead to false
    };

    try {
      // Add message to the sender's chat collection
      await getChatCollection().add(chatMessage);

      // Add message to the receiver's chat collection
      if (widget.isPsychologist) {
        await FirebaseFirestore.instance
            .collection('alzheimer')
            .doc(widget.peerId)
            .collection('appointedPsychologists')
            .doc(widget.userId)
            .collection('chats')
            .add(chatMessage);
      } else {
        await FirebaseFirestore.instance
            .collection('psychologist')
            .doc(widget.peerId)
            .collection('appointedAlzheimers')
            .doc(widget.userId)
            .collection('chats')
            .add(chatMessage);
      }

      _messageController.clear();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  // Mark a message as read for both sender and receiver
  Future<void> _markMessageAsRead(DocumentSnapshot doc) async {
  if (doc['isRead'] == false && doc['receiverId'] == widget.userId) {
    final batch = FirebaseFirestore.instance.batch();

    // Update isRead field for the receiver's message
    batch.update(doc.reference, {"isRead": true});

    // Update isRead field for the sender's message as well
    final senderMessageQuery = await getChatCollection()
        .where('senderId', isEqualTo: doc['senderId'])
        .where('receiverId', isEqualTo: doc['receiverId'])
        .where('timestamp', isEqualTo: doc['timestamp'])
        .limit(1)
        .get();

    if (senderMessageQuery.docs.isNotEmpty) {
      final senderMessageDoc = senderMessageQuery.docs.first;
      batch.update(senderMessageDoc.reference, {"isRead": true});
    }

    // Commit the batch update
    await batch.commit();
  }
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF5F2585),
        body: Column(
          children: [            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items with space in between
                crossAxisAlignment: CrossAxisAlignment.center, // Vertically align items at the center
                children: [
                  // Back arrow icon
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  
                  // Peer name in the center
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.peerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  // // Favorite icon
                  // IconButton(
                  //   icon: const Icon(Icons.video_call, color: Colors.white),
                  //   onPressed: () {
                  //     _startVideoCall();  // Corrected to call the function
                  //   },
                  // ),

                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.video_call, color: Colors.white),
                        onPressed: _startVideoCall,
                      ),
                      if (widget.isPsychologist) // Add schedule icon
                        IconButton(
                          icon: const Icon(Icons.add_alarm_rounded, color: Colors.white),
                          onPressed: () {
                            final psychologistId = widget.userId; // Current user is the psychologist
                            final alzheimerId = widget.peerId; // Peer is the Alzheimer user

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddScheduleScreen(
                                  psychologistId: psychologistId,
                                  alzheimerId: alzheimerId,
                                ),
                              ),
                            );
                          },
                        ),

                      // if (widget.isPsychologist) // Add family icon
                      //   IconButton(
                      //     icon: const Icon(Icons.group_add, color: Colors.white),
                      //     onPressed: (){} //_addFamilyMember,
                      //   ),
                      
                    ],
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
  stream: getChatCollection()
      .orderBy('timestamp', descending: true)
      .snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Center(child: Text("No messages yet."));
    }

    final messages = snapshot.data!.docs;

    return ListView.builder(
  controller: _scrollController,
  reverse: true,
  itemCount: messages.length,
  itemBuilder: (context, index) {
    final message = messages[index];
    final messageData = message.data() as Map<String, dynamic>?; // Cast data to Map safely

    if (messageData != null &&
        messageData.containsKey('type') &&
        messageData['type'] == 'videoCall' &&
        messageData['receiverId'] == widget.userId) {
      // Navigate to VideoCallPage if a video call is initiated
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoCallPage(
              userId: widget.userId,
              peerId: messageData['senderId'],
            ),
          ),
        );
      });
    }

    final isSender = messageData?['senderId'] == widget.userId;
    final isRead = messageData?['isRead'] ?? false;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
        ),
        decoration: BoxDecoration(
          color: isSender ? const Color(0xFF5F2585) : Colors.grey[300],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          messageData?['message'] ?? "",
          style: TextStyle(
            color: isSender ? Colors.white : Colors.black,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  },
);
  },
),

              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: "Type your message...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF5F2585)),
                    onPressed: () => _sendMessage(_messageController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}